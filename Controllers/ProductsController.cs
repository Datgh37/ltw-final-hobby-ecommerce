using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.DTOs;
using TuNhanTamTInh_Ecommerce.Helpers;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class ProductsController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;

        public ProductsController(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        // GET: Products
        public async Task<IActionResult> Index(int? categoryId, int? seriesId, string? keyword, string? sort, decimal? minPrice, decimal? maxPrice, int page = 1, int pageSize = 12)
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

            // Use centralized ProjectToCard() — no duplicate Select blocks
            var products = await productQuery
                .Skip(skipItems)
                .Take(pageSize)
                .ProjectToCard()
                .ToListAsync();

            var saleOffProducts = await _context.Products
                .AsNoTracking()
                .Where(x => x.Discount > 0)
                .OrderByDescending(x => x.Discount)
                .Take(6)
                .ProjectToCard()
                .ToListAsync();

            // Shared query object — single source of truth for filter params
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

            var viewModel = new ProductIndexViewModel
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
                Products = products,
                SaleOffProducts = saleOffProducts
            };

            return View(viewModel);
        }
        // GET: Products/AdminIndex
        public async Task<IActionResult> AdminIndex()
        {
            var ecommerceHobbyShopContext = _context.Products.Include(p => p.Category).Include(p => p.Series).Include(p => p.Supplier);
            return View(await ecommerceHobbyShopContext.ToListAsync());
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
                .FirstOrDefaultAsync(m => m.ProductId == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        // GET: Products/Create
        public IActionResult Create()
        {
            PopulateDropdowns();
            return View();
        }

        // POST: Products/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ProductUpdateInfoDTO model)
        {
            if (ModelState.IsValid)
            {
                Product product = new Product
                {
                    ProductName = model.ProductName,
                    ProductSlug = SlugHelper.GenerateSlug(model.ProductName),
                    CategoryId = model.CategoryId,
                    SeriesId = model.SeriesId,
                    SupplierId = model.SupplierId,
                    UnitPrice = model.UnitPrice,
                    Description = model.Description,
                    Discount = model.Discount,
                    StockQuantity = model.StockQuantity,
                };

                _context.Products.Add(product);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            PopulateDropdowns(model.CategoryId, model.SeriesId, model.SupplierId);
            return View(model);
        }

        // GET: Products/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            // Map entity → DTO to prevent over-posting (ViewCount excluded)
            var model = new ProductUpdateInfoDTO
            {
                ProductName = product.ProductName,
                ProductSlug = product.ProductSlug,
                CategoryId = product.CategoryId,
                SeriesId = product.SeriesId,
                SupplierId = product.SupplierId,
                UnitPrice = product.UnitPrice,
                Description = product.Description,
                Discount = product.Discount,
                StockQuantity = product.StockQuantity
            };

            PopulateDropdowns(product.CategoryId, product.SeriesId, product.SupplierId);
            return View(model);
        }

        // POST: Products/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, ProductUpdateInfoDTO model)
        {
            if (ModelState.IsValid)
            {
                var product = await _context.Products.FindAsync(id);
                if (product == null)
                {
                    return NotFound();
                }

                // Map DTO → entity (only allowed fields)
                product.ProductName = model.ProductName;
                product.ProductSlug = SlugHelper.GenerateSlug(model.ProductName);
                product.CategoryId = model.CategoryId;
                product.SeriesId = model.SeriesId;
                product.SupplierId = model.SupplierId;
                product.UnitPrice = model.UnitPrice;
                product.Description = model.Description;
                product.Discount = model.Discount;
                product.StockQuantity = model.StockQuantity;

                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ProductExists(id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            PopulateDropdowns(model.CategoryId, model.SeriesId, model.SupplierId);
            return View(model);
        }

        // GET: Products/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Products
                .Include(p => p.Category)
                .Include(p => p.Series)
                .Include(p => p.Supplier)
                .FirstOrDefaultAsync(m => m.ProductId == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        // POST: Products/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product != null)
            {
                _context.Products.Remove(product);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ProductExists(int id)
        {
            return _context.Products.Any(e => e.ProductId == id);
        }

        /// <summary>
        /// Populates Category/Series/Supplier dropdowns showing Name instead of ID.
        /// </summary>
        private void PopulateDropdowns(int? selectedCategory = null, int? selectedSeries = null, string? selectedSupplier = null)
        {
            ViewData["CategoryId"] = new SelectList(_context.Categories, "CategoryId", "CategoryName", selectedCategory);
            ViewData["SeriesId"] = new SelectList(_context.Series, "SeriesId", "SeriesName", selectedSeries);
            ViewData["SupplierId"] = new SelectList(_context.Suppliers, "SupplierId", "CompanyName", selectedSupplier);
        }
    }
}
