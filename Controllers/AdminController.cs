using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.DTOs;
using TuNhanTamTInh_Ecommerce.Helpers;
using TuNhanTamTInh_Ecommerce.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using System.IO;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    [Authorize(Policy = "AdminOnly")]
    [Route("Admin")]
    public class AdminController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;
        private readonly IMapper _mapper;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public AdminController(EcommerceHobbyShopContext context, IMapper mapper, IWebHostEnvironment webHostEnvironment)
        {
            _context = context;
            _mapper = mapper;
            _webHostEnvironment = webHostEnvironment;
        }

        #region Product CRUD Actions

        // GET: Admin/Products
        [Route("Products")]
        public async Task<IActionResult> Products()
        {
            var ecommerceHobbyShopContext = _context.Products.Include(p => p.Category).Include(p => p.Series).Include(p => p.Supplier);
            return View("~/Views/Admin/Products/Index.cshtml", await ecommerceHobbyShopContext.ToListAsync());
        }

        // GET: Admin/Products/Details/5
        [Route("Products/Details/{id}")]
        public async Task<IActionResult> ProductDetails(int? id)
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

            return View("~/Views/Admin/Products/Details.cshtml", product);
        }

        // GET: Admin/Products/Create
        [HttpGet("Products/Create")]
        public IActionResult ProductCreate()
        {
            PopulateDropdowns();
            return View("~/Views/Admin/Products/Create.cshtml");
        }

        // POST: Admin/Products/Create
        [HttpPost("Products/Create")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProductCreate(ProductUpdateInfoDTO model)
        {
            if (ModelState.IsValid)
            {
                var product = _mapper.Map<Product>(model);
                product.Discount = model.Discount / 100.0;
                product.ProductSlug = SlugHelper.GenerateSlug(product.ProductName);

                _context.Products.Add(product);
                await _context.SaveChangesAsync();

                // Handle Image Uploads
                var folderName = $"product_{product.ProductId}";
                var productFolder = Path.Combine(_webHostEnvironment.WebRootPath, "images", "Products", folderName);

                // 1. Handle Primary Image
                if (model.PrimaryImageFile != null && model.PrimaryImageFile.Length > 0)
                {
                    if (!Directory.Exists(productFolder))
                    {
                        Directory.CreateDirectory(productFolder);
                    }

                    var primaryFileName = "primary_" + Path.GetFileName(model.PrimaryImageFile.FileName);
                    var primaryFilePath = Path.Combine(productFolder, primaryFileName);
                    using (var stream = new FileStream(primaryFilePath, FileMode.Create))
                    {
                        await model.PrimaryImageFile.CopyToAsync(stream);
                    }

                    var primaryImage = new ProductImage
                    {
                        ProductId = product.ProductId,
                        ImageUrl = $"~/images/Products/{folderName}/{primaryFileName}",
                        IsPrimary = true
                    };
                    _context.ProductImages.Add(primaryImage);
                }

                // 2. Handle Sub-Images
                if (model.SubImageFiles != null && model.SubImageFiles.Count > 0)
                {
                    if (!Directory.Exists(productFolder))
                    {
                        Directory.CreateDirectory(productFolder);
                    }

                    int counter = 1;
                    foreach (var file in model.SubImageFiles)
                    {
                        if (file != null && file.Length > 0)
                        {
                            var subFileName = $"sub_{counter}_{Path.GetFileName(file.FileName)}";
                            var subFilePath = Path.Combine(productFolder, subFileName);
                            using (var stream = new FileStream(subFilePath, FileMode.Create))
                            {
                                await file.CopyToAsync(stream);
                            }

                            var subImage = new ProductImage
                            {
                                ProductId = product.ProductId,
                                ImageUrl = $"~/images/Products/{folderName}/{subFileName}",
                                IsPrimary = false
                            };
                            _context.ProductImages.Add(subImage);
                            counter++;
                        }
                    }
                }

                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Products));
            }
            PopulateDropdowns(model.CategoryId, model.SeriesId, model.SupplierId);
            return View("~/Views/Admin/Products/Create.cshtml", model);
        }

        // GET: Admin/Products/Edit/5
        [HttpGet("Products/Edit/{id}")]
        public async Task<IActionResult> ProductEdit(int? id)
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

            var model = _mapper.Map<ProductUpdateInfoDTO>(product);
            model.Discount = product.Discount * 100.0;

            PopulateDropdowns(product.CategoryId, product.SeriesId, product.SupplierId);
            return View("~/Views/Admin/Products/Edit.cshtml", model);
        }

        // POST: Admin/Products/Edit/5
        [HttpPost("Products/Edit/{id}")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProductEdit(int id, ProductUpdateInfoDTO model)
        {
            if (ModelState.IsValid)
            {
                var product = await _context.Products.FindAsync(id);
                if (product == null)
                {
                    return NotFound();
                }

                _mapper.Map(model, product);
                product.Discount = model.Discount / 100.0;
                product.ProductSlug = SlugHelper.GenerateSlug(product.ProductName);

                // Handle Image Uploads
                var folderName = $"product_{id}";
                var productFolder = Path.Combine(_webHostEnvironment.WebRootPath, "images", "Products", folderName);

                // 1. Handle Primary Image
                if (model.PrimaryImageFile != null && model.PrimaryImageFile.Length > 0)
                {
                    if (!Directory.Exists(productFolder))
                    {
                        Directory.CreateDirectory(productFolder);
                    }

                    // Delete old primary image if exists
                    var existingPrimary = await _context.ProductImages.FirstOrDefaultAsync(pi => pi.ProductId == id && pi.IsPrimary);
                    if (existingPrimary != null)
                    {
                        var oldPath = Path.Combine(_webHostEnvironment.WebRootPath, existingPrimary.ImageUrl.Replace("~/", "").Replace("/", "\\"));
                        if (System.IO.File.Exists(oldPath))
                        {
                            System.IO.File.Delete(oldPath);
                        }
                        _context.ProductImages.Remove(existingPrimary);
                    }

                    var primaryFileName = "primary_" + Path.GetFileName(model.PrimaryImageFile.FileName);
                    var primaryFilePath = Path.Combine(productFolder, primaryFileName);
                    using (var stream = new FileStream(primaryFilePath, FileMode.Create))
                    {
                        await model.PrimaryImageFile.CopyToAsync(stream);
                    }

                    var primaryImage = new ProductImage
                    {
                        ProductId = id,
                        ImageUrl = $"~/images/Products/{folderName}/{primaryFileName}",
                        IsPrimary = true
                    };
                    _context.ProductImages.Add(primaryImage);
                }

                // 2. Handle Sub-Images
                if (model.SubImageFiles != null && model.SubImageFiles.Count > 0)
                {
                    if (!Directory.Exists(productFolder))
                    {
                        Directory.CreateDirectory(productFolder);
                    }

                    int counter = await _context.ProductImages.CountAsync(pi => pi.ProductId == id && !pi.IsPrimary) + 1;
                    foreach (var file in model.SubImageFiles)
                    {
                        if (file != null && file.Length > 0)
                        {
                            var subFileName = $"sub_{counter}_{Path.GetFileName(file.FileName)}";
                            var subFilePath = Path.Combine(productFolder, subFileName);
                            using (var stream = new FileStream(subFilePath, FileMode.Create))
                            {
                                await file.CopyToAsync(stream);
                            }

                            var subImage = new ProductImage
                            {
                                ProductId = id,
                                ImageUrl = $"~/images/Products/{folderName}/{subFileName}",
                                IsPrimary = false
                            };
                            _context.ProductImages.Add(subImage);
                            counter++;
                        }
                    }
                }

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
                return RedirectToAction(nameof(Products));
            }
            PopulateDropdowns(model.CategoryId, model.SeriesId, model.SupplierId);
            return View("~/Views/Admin/Products/Edit.cshtml", model);
        }

        // GET: Admin/Products/Delete/5
        [HttpGet("Products/Delete/{id}")]
        public async Task<IActionResult> ProductDelete(int? id)
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

            return View("~/Views/Admin/Products/Delete.cshtml", product);
        }

        // POST: Admin/Products/Delete/5
        [HttpPost("Products/Delete/{id}"), ActionName("ProductDelete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProductDeleteConfirmed(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product != null)
            {
                // Triệt để xóa thư mục chứa hình ảnh của sản phẩm đó trong wwwroot
                var folderName = $"product_{id}";
                var productFolder = Path.Combine(_webHostEnvironment.WebRootPath, "images", "Products", folderName);
                
                if (Directory.Exists(productFolder))
                {
                    try
                    {
                        Directory.Delete(productFolder, true);
                    }
                    catch (Exception)
                    {
                        // Bắt exception để tránh crash luồng chính nếu file đang bị lock tạm thời bởi IIS/Process khác
                    }
                }

                _context.Products.Remove(product);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Products));
        }

        #endregion

        #region Category CRUD Actions

        // GET: Admin/Categories
        [Route("Categories")]
        public async Task<IActionResult> Categories()
        {
            return View("~/Views/Admin/Categories/Index.cshtml", await _context.Categories.ToListAsync());
        }

        // GET: Admin/Categories/Details/5
        [Route("Categories/Details/{id}")]
        public async Task<IActionResult> CategoryDetails(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var category = await _context.Categories
                .FirstOrDefaultAsync(m => m.CategoryId == id);
            if (category == null)
            {
                return NotFound();
            }

            return View("~/Views/Admin/Categories/Details.cshtml", category);
        }

        // GET: Admin/Categories/Create
        [HttpGet("Categories/Create")]
        public IActionResult CategoryCreate()
        {
            return View("~/Views/Admin/Categories/Create.cshtml");
        }

        // POST: Admin/Categories/Create
        [HttpPost("Categories/Create")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CategoryCreate([Bind("CategoryId,CategoryName,CategorySlug,Image")] Category category)
        {
            if (ModelState.IsValid)
            {
                _context.Add(category);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Categories));
            }
            return View("~/Views/Admin/Categories/Create.cshtml", category);
        }

        // GET: Admin/Categories/Edit/5
        [HttpGet("Categories/Edit/{id}")]
        public async Task<IActionResult> CategoryEdit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var category = await _context.Categories.FindAsync(id);
            if (category == null)
            {
                return NotFound();
            }
            return View("~/Views/Admin/Categories/Edit.cshtml", category);
        }

        // POST: Admin/Categories/Edit/5
        [HttpPost("Categories/Edit/{id}")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CategoryEdit(int id, [Bind("CategoryId,CategoryName,CategorySlug,Image")] Category category)
        {
            if (id != category.CategoryId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(category);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CategoryExists(category.CategoryId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Categories));
            }
            return View("~/Views/Admin/Categories/Edit.cshtml", category);
        }

        // GET: Admin/Categories/Delete/5
        [HttpGet("Categories/Delete/{id}")]
        public async Task<IActionResult> CategoryDelete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var category = await _context.Categories
                .FirstOrDefaultAsync(m => m.CategoryId == id);
            if (category == null)
            {
                return NotFound();
            }

            return View("~/Views/Admin/Categories/Delete.cshtml", category);
        }

        // POST: Admin/Categories/Delete/5
        [HttpPost("Categories/Delete/{id}"), ActionName("CategoryDelete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CategoryDeleteConfirmed(int id)
        {
            var category = await _context.Categories.FindAsync(id);
            if (category != null)
            {
                _context.Categories.Remove(category);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Categories));
        }

        #endregion

        #region Helpers

        private bool ProductExists(int id)
        {
            return _context.Products.Any(e => e.ProductId == id);
        }

        private bool CategoryExists(int id)
        {
            return _context.Categories.Any(e => e.CategoryId == id);
        }

        private void PopulateDropdowns(int? selectedCategory = null, int? selectedSeries = null, string? selectedSupplier = null)
        {
            ViewData["CategoryId"] = new SelectList(_context.Categories, "CategoryId", "CategoryName", selectedCategory);
            ViewData["SeriesId"] = new SelectList(_context.Series, "SeriesId", "SeriesName", selectedSeries);
            ViewData["SupplierId"] = new SelectList(_context.Suppliers, "SupplierId", "CompanyName", selectedSupplier);
        }

        #endregion
    }
}
