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
        public async Task<IActionResult> AddToCart(int productId, int quantity = 1)
        {
            // Kiểm tra login
            if (!User.Identity.IsAuthenticated)
            {
                return Json(new
                {
                    success = false,
                    message = "Vui lòng đăng nhập"
                });
            }

            // Lấy AccountId từ Claim
            var accountId = User
                .FindFirst("AccountId")?
                .Value;

            if (string.IsNullOrEmpty(accountId))
            {
                return Json(new
                {
                    success = false,
                    message = "Không tìm thấy tài khoản"
                });
            }

            // Tìm cart
            var cart = await _context.Carts
                .Include(x => x.CartItems)
                .FirstOrDefaultAsync(x =>
                    x.AccountId == accountId);

            // Nếu chưa có cart
            if (cart == null)
            {
                cart = new Cart
                {
                    CartId = Guid.NewGuid().ToString(),
                    AccountId = accountId,
                    CreatedAt = DateTime.Now
                };

                _context.Carts.Add(cart);

                await _context.SaveChangesAsync();
            }

            // Tìm sản phẩm trong cart
            var cartItem = await _context.CartItems
                .FirstOrDefaultAsync(x =>
                    x.CartId == cart.CartId &&
                    x.ProductId == productId);

            // Nếu đã có → tăng số lượng
            if (cartItem != null)
            {
                cartItem.Quantity += quantity;
            }
            else
            {
                // Nếu chưa có → tạo mới
                cartItem = new CartItem
                {
                    CartId = cart.CartId,
                    ProductId = productId,
                    Quantity = quantity
                };

                _context.CartItems.Add(cartItem);
            }

            await _context.SaveChangesAsync();

            // Tổng số lượng cart
            int totalItems = await _context.CartItems
                .Where(x => x.CartId == cart.CartId)
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
            if (!User.Identity.IsAuthenticated)
            {
                return RedirectToAction(
                    "Login",
                    "Account");
            }

            var accountId =
                User.FindFirst("AccountId")?.Value;

            var cart = await _context.Carts
                .Include(x => x.CartItems)
                .ThenInclude(x => x.Product)
                .ThenInclude(x => x.ProductImages)
                .FirstOrDefaultAsync(x =>
                    x.AccountId == accountId);
            if (cart == null)
            {
                return View(new List<CartItem>());
            }

            return View(cart.CartItems.ToList());
        }
        [HttpPost]
        public async Task<IActionResult> UpdateQuantity(int cartItemId,int quantity)
        {
            if (quantity < 1)
            {
                return Json(new
                {
                    success = false
                });
            }
            var cartItem = await _context.CartItems
                .Include(x => x.Product)
                .Include(x => x.Cart)
                .FirstOrDefaultAsync(x =>
                    x.CartItemId == cartItemId);
            if (cartItem == null)
            {
                return Json(new
                {
                    success = false
                });
            }
            cartItem.Quantity = quantity;
            await _context.SaveChangesAsync();
            var subtotal =
                cartItem.Product.UnitPrice * quantity;
            var grandTotal = await _context.CartItems
                .Where(x => x.CartId == cartItem.CartId)
                .SumAsync(x =>
                    x.Product.UnitPrice * x.Quantity);
            var totalItems = await _context.CartItems
                .Where(x => x.CartId == cartItem.CartId)
                .SumAsync(x => x.Quantity);
            return Json(new
            {
                success = true,
                quantity = cartItem.Quantity,
                subtotal = subtotal.ToString("N0"),
                grandTotal = grandTotal.ToString("N0"),
                totalItems
            });
        }
        [HttpPost]
        public async Task<IActionResult> Delete(int cartItemId)
        {
            var cartItem = await _context.CartItems
                .Include(x => x.Cart)
                .FirstOrDefaultAsync(x =>
                    x.CartItemId == cartItemId);
            if (cartItem == null)
            {
                return Json(new
                {
                    success = false
                });
            }
            string cartId = cartItem.CartId;
            _context.CartItems.Remove(cartItem);
            await _context.SaveChangesAsync();
            var grandTotal = await _context.CartItems
                .Where(x => x.CartId == cartId)
                .SumAsync(x =>
                    x.Product.UnitPrice * x.Quantity);
            var totalItems = await _context.CartItems
                .Where(x => x.CartId == cartId)
                .SumAsync(x => x.Quantity);
            return Json(new
            {
                success = true,
                grandTotal = grandTotal.ToString("N0"),
                totalItems
            });
        }
        [HttpPost]
        public async Task<IActionResult>DeleteCartItem(int cartItemId)
        {
            var cartItem =
                await _context.CartItems
                .Include(x => x.Cart)
                .Include(x => x.Product)
                .FirstOrDefaultAsync(x =>
                    x.CartItemId == cartItemId);
            if (cartItem == null)
            {
                return Json(new
                {
                    success = false
                });
            }
            _context.CartItems.Remove(cartItem);
            await _context.SaveChangesAsync();
            var accountId =
                User.FindFirst("AccountId")
                ?.Value;
            var totalItems =
                await _context.CartItems
                .Include(x => x.Cart)
                .Where(x =>
                    x.Cart.AccountId == accountId)
                .SumAsync(x =>
                    x.Quantity);
            var grandTotal =
                await _context.CartItems
                .Include(x => x.Product)
                .Include(x => x.Cart)
                .Where(x =>
                    x.Cart.AccountId == accountId)
                .SumAsync(x =>
                    x.Product.UnitPrice
                    * x.Quantity);
            return Json(new
            {
                success = true,
                totalItems,
                grandTotal =
                    grandTotal.ToString("N0")
            });
        }
    }
}