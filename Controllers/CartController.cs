using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class CartController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;

        public CartController(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> AddToCart(int productId)
        {
            int accountIdInt =
                HttpContext.Session.GetInt32("AccountId") ?? 0;

            if (accountIdInt == 0)
            {
                return Json(new
                {
                    success = false,
                    message = "Vui lòng đăng nhập"
                });
            }
            string accountId = accountIdInt.ToString();

            var cart = await _context.Carts.FirstOrDefaultAsync(c => c.AccountId == accountId);

            if (cart == null)
            {
                cart = new Cart
                {
                    CartId = Guid.NewGuid().ToString(),
                    AccountId = accountId,
                    CreatedAt = DateTime.UtcNow
                };
                _context.Carts.Add(cart);
            }

            var cartItem = await _context.CartItems
                .FirstOrDefaultAsync(x =>
                    x.ProductId == productId &&
                    x.Cart.AccountId == accountId);

            if (cartItem != null)
            {
                cartItem.Quantity++;
            }
            else
            {
                cartItem = new CartItem
                {
                    CartId = cart.CartId,
                    ProductId = productId,
                    Quantity = 1,
                };

                _context.CartItems.Add(cartItem);
            }

            await _context.SaveChangesAsync();

            int totalItems = await _context.CartItems
                .Where(x => x.Cart.AccountId == accountId)
                .SumAsync(x => x.Quantity);

            return Json(new
            {
                success = true,
                totalItems = totalItems,
                message = "Đã thêm vào giỏ hàng"
            });
        }

        public async Task<IActionResult> Index()
        {
            int accountIdInt =
                HttpContext.Session.GetInt32("AccountId") ?? 0;

            if (accountIdInt == 0)
            {
                return View(new List<CartItem>());
            }
            string accountId = accountIdInt.ToString();

            var cartItems = await _context.CartItems
                .Include(x => x.Product)
                .Where(x => x.Cart.AccountId == accountId)
                .ToListAsync();

            return View(cartItems);
        }
    }
}