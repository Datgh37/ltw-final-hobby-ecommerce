using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.DTOs;
using TuNhanTamTInh_Ecommerce.Helpers;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

using Microsoft.AspNetCore.Authorization;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class ProductsController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;
        private readonly IMapper _mapper;

        public ProductsController(EcommerceHobbyShopContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        // GET: Products
        public async Task<IActionResult> Index(int? categoryId, int? seriesId, string? keyword, string? sort, decimal? minPrice, decimal? maxPrice, int page = 1, int pageSize = 12)
        {
            var viewModel = await PrepareProductIndexViewModel(categoryId, seriesId, keyword, sort, minPrice, maxPrice, page, pageSize);
            
            // For full Index request, we also need SaleOffProducts
            viewModel.SaleOffProducts = await _context.Products
                .AsNoTracking()
                .Where(x => x.Discount > 0)
                .OrderByDescending(x => x.Discount)
                .Take(6)
                .ProjectToCard()
                .ToListAsync();

            if (User.Identity.IsAuthenticated)
            {
                var accountId = User.FindFirst("AccountId")?.Value;
                var favoriteProductIds = await _context.Favorites
                    .Where(f => f.AccountId == accountId)
                    .Select(f => f.ProductId)
                    .ToListAsync();

                foreach (var product in viewModel.SaleOffProducts)
                {
                    product.IsFavorite = favoriteProductIds.Contains(product.ProductId);
                }
            }

            return View(viewModel);
        }

        // GET: Products/Filter (AJAX Partial)
        public async Task<IActionResult> Filter(int? categoryId, int? seriesId, string? keyword, string? sort, decimal? minPrice, decimal? maxPrice, int page = 1, int pageSize = 12)
        {
            var viewModel = await PrepareProductIndexViewModel(categoryId, seriesId, keyword, sort, minPrice, maxPrice, page, pageSize);
            return PartialView("_ProductListPartial", viewModel);
        }

        // GET: Products/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Products
                .Include(p => p.Category)
                .Include(p => p.Series)
                .Include(p => p.Supplier)
                .Include(p => p.ProductImages)
                .FirstOrDefaultAsync(m => m.ProductId == id);
            if (product == null)
            {
                return NotFound();
            }

            var relatedProducts = await _context.Products
                .AsNoTracking()
                .Where(p => p.CategoryId == product.CategoryId && p.ProductId != product.ProductId)
                .OrderBy(x => Guid.NewGuid()) // Lấy ngẫu nhiên
                .Take(4)
                .ProjectToCard()
                .ToListAsync();

            ViewBag.RelatedProducts = relatedProducts;

            // Check if product is favorited by current user
            bool isFavorite = false;
            if (User.Identity.IsAuthenticated)
            {
                var accountId = User.FindFirst("AccountId")?.Value;
                isFavorite = await _context.Favorites
                    .AnyAsync(f => f.AccountId == accountId && f.ProductId == product.ProductId);
            }
            ViewBag.IsFavorite = isFavorite;

            return View(product);
        }

        // GET: Products/LiveSearch (AJAX)
        public async Task<IActionResult> LiveSearch(string keyword)
        {
            if (string.IsNullOrWhiteSpace(keyword) || keyword.Length < 2)
            {
                return Json(new List<object>());
            }

            var results = await _context.Products
                .AsNoTracking()
                .Where(x => x.ProductName.Contains(keyword))
                .OrderByDescending(x => x.ViewCount)
                .Take(10) // Lấy tối đa 10 kết quả nhưng chỉ hiện 5 trong CSS (scroll)
                .Select(x => new
                {
                    productId = x.ProductId,
                    productName = x.ProductName,
                    unitPrice = x.UnitPrice,
                    discount = x.Discount,
                    imageUrl = x.ProductImages.FirstOrDefault(img => img.IsPrimary).ImageUrl ?? 
                               x.ProductImages.FirstOrDefault().ImageUrl ?? "~/images/product-default.png"
                })
                .ToListAsync();

            return Json(results);
        }

        // POST: Products/ToggleFavorite (AJAX)
        [HttpPost]
        public async Task<IActionResult> ToggleFavorite(int productId)
        {
            if (!User.Identity.IsAuthenticated)
            {
                return Json(new { success = false, message = Loc.T("Vui lòng đăng nhập để lưu sản phẩm yêu thích.", "Please login to save favorite products.") });
            }

            var accountId = User.FindFirst("AccountId")?.Value;
            var favorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.AccountId == accountId && f.ProductId == productId);

            bool isAdded = false;
            if (favorite == null)
            {
                favorite = new Favorite
                {
                    AccountId = accountId,
                    ProductId = productId
                };
                _context.Favorites.Add(favorite);
                isAdded = true;
            }
            else
            {
                _context.Favorites.Remove(favorite);
                isAdded = false;
            }

            await _context.SaveChangesAsync();
            var totalCount = await _context.Favorites.CountAsync(f => f.AccountId == accountId);

            return Json(new { 
                success = true, 
                isAdded = isAdded, 
                totalCount = totalCount,
                message = isAdded ? Loc.T("Đã thêm vào yêu thích", "Added to favorites") : Loc.T("Đã xóa khỏi yêu thích", "Removed from favorites") 
            });
        }

        // GET: Products/GetFavoriteCount (AJAX)
        public async Task<IActionResult> GetFavoriteCount()
        {
            if (!User.Identity.IsAuthenticated) return Json(0);
            var accountId = User.FindFirst("AccountId")?.Value;
            var count = await _context.Favorites.CountAsync(f => f.AccountId == accountId);
            return Json(count);
        }

        // GET: Products/CheckFavoriteStatus (AJAX)
        public async Task<IActionResult> CheckFavoriteStatus(int productId)
        {
            if (!User.Identity.IsAuthenticated)
                return Json(new { isFavorite = false });

            var accountId = User.FindFirst("AccountId")?.Value;
            var isFavorite = await _context.Favorites
                .AnyAsync(f => f.AccountId == accountId && f.ProductId == productId);

            return Json(new { isFavorite = isFavorite });
        }
        
        // Helper để dùng chung cho Index và Filter AJAX
        private async Task<ProductIndexViewModel> PrepareProductIndexViewModel(int? categoryId, int? seriesId, string? keyword, string? sort, decimal? minPrice, decimal? maxPrice, int page = 1, int pageSize = 12)
        {
            var productQuery = _context.Products
                .AsNoTracking()
                .AsQueryable();

            if (categoryId.HasValue)
            {
                productQuery = productQuery.Where(x => x.CategoryId == categoryId.Value);
            }

            if (seriesId.HasValue)
            {
                productQuery = productQuery.Where(x => x.SeriesId == seriesId.Value);
            }

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                productQuery = productQuery.Where(x => x.ProductName.Contains(keyword));
            }

            var overallMaxPrice = await _context.Products.AsNoTracking().Select(x => (decimal?)x.UnitPrice).MaxAsync() ?? 0m;
            var selectedMinPrice = minPrice ?? 0m;
            var selectedMaxPrice = maxPrice ?? overallMaxPrice;

            if (selectedMinPrice > 0 || selectedMaxPrice < overallMaxPrice)
            {
                productQuery = productQuery.Where(x => x.UnitPrice >= selectedMinPrice && x.UnitPrice <= selectedMaxPrice);
            }

            productQuery = sort?.ToLowerInvariant() switch
            {
                "price_asc" => productQuery.OrderBy(x => x.UnitPrice),
                "price_desc" => productQuery.OrderByDescending(x => x.UnitPrice),
                "newest" => productQuery.OrderByDescending(x => x.ProductId),
                "top_rated" => productQuery.OrderByDescending(x => x.Reviews.Any() ? x.Reviews.Average(r => r.Rating) : 0).ThenByDescending(x => x.ProductId),
                "discount_desc" => productQuery.OrderByDescending(x => x.Discount).ThenByDescending(x => x.ProductId),
                "viewcount_desc" => productQuery.OrderByDescending(x => x.ViewCount).ThenByDescending(x => x.ProductId),
                _ => productQuery.OrderBy(x => x.ProductName)
            };

            var totalCount = await productQuery.CountAsync();
            var totalPages = Math.Max(1, (int)Math.Ceiling(totalCount / (double)pageSize));
            page = Math.Clamp(page, 1, totalPages);
            var skipItems = (page - 1) * pageSize;

            var products = await productQuery
                .Skip(skipItems)
                .Take(pageSize)
                .ProjectToCard()
                .ToListAsync();

            if (User.Identity.IsAuthenticated)
            {
                var accountId = User.FindFirst("AccountId")?.Value;
                var favoriteProductIds = await _context.Favorites
                    .Where(f => f.AccountId == accountId)
                    .Select(f => f.ProductId)
                    .ToListAsync();

                foreach (var product in products)
                {
                    product.IsFavorite = favoriteProductIds.Contains(product.ProductId);
                }
            }

            var queryVM = new ProductIndexQueryViewModel
            {
                CategoryId = categoryId,
                SeriesId = seriesId,
                Keyword = keyword,
                Sort = sort,
                MinPrice = minPrice,
                MaxPrice = maxPrice,
                Page = page,
                PageSize = pageSize
            };

            return new ProductIndexViewModel
            {
                Query = queryVM,
                PriceFilter = new PriceFilterViewModel
                {
                    MinPrice = 0m,
                    MaxPrice = overallMaxPrice,
                    SelectedMinPrice = selectedMinPrice,
                    SelectedMaxPrice = selectedMaxPrice,
                    Query = queryVM
                },
                SortOptions = new SortOptionsViewModel
                {
                    SelectedSort = sort,
                    TotalCount = totalCount,
                    Query = queryVM
                },
                Pagination = new PaginationViewModel
                {
                    CurrentPage = page,
                    TotalPages = totalPages,
                    TotalCount = totalCount,
                    PageSize = pageSize,
                    ShowArrows = totalPages > 1,
                    Query = queryVM
                },
                Products = products
            };
        }
    }
}
