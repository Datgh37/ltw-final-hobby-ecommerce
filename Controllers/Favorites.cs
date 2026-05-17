using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    [Authorize]
    public class FavoritesController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;

        public FavoritesController(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        // GET: /Favorites
        public async Task<IActionResult> Index()
        {
            var accountId = User.FindFirst("AccountId")?.Value;

            var favorites = await _context.Favorites
                .AsNoTracking()
                .Where(f => f.AccountId == accountId)
                .OrderByDescending(f => f.CreatedAt)
                .Include(f => f.Product)
                    .ThenInclude(p => p.ProductImages)
                .Include(f => f.Product)
                    .ThenInclude(p => p.Category)
                .ToListAsync();

            var breadcrumb = new BreadcrumbViewModel
            {
                Title = "Sản phẩm yêu thích",
                Items = new List<BreadcrumbItem>
                {
                    new BreadcrumbItem("Trang chủ", Url.Action("Index", "Home")),
                    new BreadcrumbItem("Yêu thích")
                }
            };
            ViewBag.Breadcrumb = breadcrumb;

            return View(favorites);
        }

        // POST: /Favorites/Remove (AJAX)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Remove(int productId)
        {
            var accountId = User.FindFirst("AccountId")?.Value;

            var favorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.AccountId == accountId && f.ProductId == productId);

            if (favorite == null)
                return Json(new { success = false, message = "Không tìm thấy sản phẩm trong danh sách yêu thích." });

            _context.Favorites.Remove(favorite);
            await _context.SaveChangesAsync();

            var totalCount = await _context.Favorites.CountAsync(f => f.AccountId == accountId);

            return Json(new
            {
                success = true,
                totalCount = totalCount,
                message = "Đã xóa khỏi danh sách yêu thích."
            });
        }
    }
}
