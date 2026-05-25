using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class CartController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;

        public CartController(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        // Lấy GuestCartId từ cookie của trình duyệt. 
        // Nếu chưa có, tạo mới một GUID và lưu vào cookie với thời hạn 30 ngày.
        // Hỗ trợ khách vãng lai (chưa đăng nhập) thêm sản phẩm vào giỏ hàng.
        private string GetOrSetGuestCartId()
        {
            if (Request.Cookies.TryGetValue("GuestCartId", out string cartId))
            {
                return cartId;
            }
            cartId = Guid.NewGuid().ToString();
            var options = new CookieOptions { Expires = DateTime.Now.AddDays(30), HttpOnly = true };
            Response.Cookies.Append("GuestCartId", cartId, options);
            return cartId;
        }

        // GET: /Cart/Index
        public async Task<IActionResult> Index()
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            var guestCartId = accountId == null ? GetOrSetGuestCartId() : null;

            Cart? cart = null;
            if (accountId != null)
            {
                cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .ThenInclude(x => x.Product)
                    .ThenInclude(x => x.ProductImages)
                    .FirstOrDefaultAsync(x => x.AccountId == accountId);
            }
            else
            {
                cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .ThenInclude(x => x.Product)
                    .ThenInclude(x => x.ProductImages)
                    .FirstOrDefaultAsync(x => x.CartId == guestCartId);
            }

            if (cart == null)
            {
                return View(new List<CartItem>());
            }

            return View(cart.CartItems.ToList());
        }

        // POST: /Cart/AddToCart (AJAX)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddToCart(int productId, int quantity = 1)
        {
            if (quantity <= 0) return Json(new { success = false, message = Loc.T("Số lượng không hợp lệ", "Invalid quantity") });

            var accountId = User.FindFirst("AccountId")?.Value;
            var guestCartId = accountId == null ? GetOrSetGuestCartId() : null;

            Cart? cart = null;
            if (accountId != null)
            {
                cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .FirstOrDefaultAsync(x => x.AccountId == accountId);
            }
            else
            {
                cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .FirstOrDefaultAsync(x => x.CartId == guestCartId);
            }

            if (cart == null)
            {
                cart = new Cart
                {
                    CartId = accountId != null ? Guid.NewGuid().ToString() : guestCartId,
                    AccountId = accountId,
                    CreatedAt = DateTime.Now
                };
                _context.Carts.Add(cart);
                await _context.SaveChangesAsync();
            }

            var cartItem = await _context.CartItems
                .Include(x => x.Product)
                .FirstOrDefaultAsync(x => x.CartId == cart.CartId && x.ProductId == productId);

            var product = await _context.Products.FindAsync(productId);
            if (product == null) return Json(new { success = false, message = Loc.T("Sản phẩm không tồn tại", "Product does not exist") });

            if (cartItem != null)
            {
                if (cartItem.Quantity + quantity > product.StockQuantity)
                {
                    return Json(new { success = false, message = Loc.T($"Chỉ còn {product.StockQuantity} sản phẩm trong kho", $"Only {product.StockQuantity} items left in stock") });
                }
                cartItem.Quantity += quantity;
            }
            else
            {
                if (quantity > product.StockQuantity)
                {
                    return Json(new { success = false, message = Loc.T($"Chỉ còn {product.StockQuantity} sản phẩm trong kho", $"Only {product.StockQuantity} items left in stock") });
                }
                cartItem = new CartItem
                {
                    CartId = cart.CartId,
                    ProductId = productId,
                    Quantity = quantity
                };
                _context.CartItems.Add(cartItem);
            }

            await _context.SaveChangesAsync();

            var summary = await GetCartSummary(accountId, guestCartId);
            return Json(new
            {
                success = true,
                totalItems = summary.TotalItems,
                message = Loc.T("Đã thêm vào giỏ hàng", "Added to cart")
            });
        }

        // POST: /Cart/UpdateQuantity (AJAX)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateQuantity(int cartItemId, int quantity)
        {
            if (quantity < 1) return Json(new { success = false, message = Loc.T("Số lượng không hợp lệ", "Invalid quantity") });

            // Lấy danh tính người dùng hiện tại để đảm bảo quyền sở hữu (Chống lỗi IDOR)
            var accountId = User.FindFirst("AccountId")?.Value;
            Request.Cookies.TryGetValue("GuestCartId", out string? guestCartId);

            // Chỉ tìm sản phẩm nếu nó thuộc về AccountId hoặc GuestCartId hiện tại để bảo mật
            var cartItemQuery = _context.CartItems
                .Include(x => x.Product)
                .Include(x => x.Cart)
                .Where(x => x.CartItemId == cartItemId);

            if (accountId != null)
                cartItemQuery = cartItemQuery.Where(x => x.Cart.AccountId == accountId);
            else if (!string.IsNullOrEmpty(guestCartId))
                cartItemQuery = cartItemQuery.Where(x => x.Cart.CartId == guestCartId);
            else
                return Json(new { success = false });

            var cartItem = await cartItemQuery.FirstOrDefaultAsync();

            if (cartItem == null) return Json(new { success = false });

            if (quantity > cartItem.Product.StockQuantity)
            {
                return Json(new { success = false, message = Loc.T($"Số lượng vượt quá tồn kho ({cartItem.Product.StockQuantity})", $"Quantity exceeds stock limit ({cartItem.Product.StockQuantity})") });
            }

            cartItem.Quantity = quantity;
            await _context.SaveChangesAsync();

            var summary = await GetCartSummary(accountId, guestCartId);

            return Json(new
            {
                success = true,
                quantity = cartItem.Quantity,
                subtotal = (cartItem.Product.UnitPrice * quantity).ToString("N0"),
                cartSubtotal = summary.Subtotal.ToString("N0"),
                discount = summary.Discount.ToString("N0"),
                grandTotal = summary.GrandTotal.ToString("N0"),
                totalItems = summary.TotalItems
            });
        }

        // POST: /Cart/DeleteCartItem (AJAX)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteCartItem(int cartItemId)
        {
            // Bảo mật: Xác thực danh tính từ Cookie/Token thay vì tin tưởng ID từ client
            var accountId = User.FindFirst("AccountId")?.Value;
            Request.Cookies.TryGetValue("GuestCartId", out string? guestCartId);

            // Verification: Kiểm tra chéo ID món hàng với ID chủ sở hữu (Chống lỗi IDOR)
            var cartItemQuery = _context.CartItems
                .Include(x => x.Cart)
                .Where(x => x.CartItemId == cartItemId);

            if (accountId != null)
                cartItemQuery = cartItemQuery.Where(x => x.Cart.AccountId == accountId);
            else if (!string.IsNullOrEmpty(guestCartId))
                cartItemQuery = cartItemQuery.Where(x => x.Cart.CartId == guestCartId);
            else
                return Json(new { success = false });

            var cartItem = await cartItemQuery.FirstOrDefaultAsync();

            if (cartItem == null) return Json(new { success = false });

            _context.CartItems.Remove(cartItem);
            await _context.SaveChangesAsync();

            var summary = await GetCartSummary(accountId, guestCartId);

            return Json(new
            {
                success = true,
                totalItems = summary.TotalItems,
                cartSubtotal = summary.Subtotal.ToString("N0"),
                discount = summary.Discount.ToString("N0"),
                grandTotal = summary.GrandTotal.ToString("N0")
            });
        }

        // GET: /Cart/GetCartPreview (AJAX - to reload the component)
        public IActionResult GetCartPreview()
        {
            return ViewComponent("Cart");
        }

        // Helper to get cart stats
        private async Task<(int TotalItems, decimal Subtotal, decimal Discount, decimal GrandTotal)> GetCartSummary(string? accountId, string? guestCartId = null)
        {
            Cart? cart = null;
            if (accountId != null)
            {
                cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .ThenInclude(x => x.Product)
                    .FirstOrDefaultAsync(x => x.AccountId == accountId);
            }
            else if (!string.IsNullOrEmpty(guestCartId))
            {
                cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .ThenInclude(x => x.Product)
                    .FirstOrDefaultAsync(x => x.CartId == guestCartId);
            }

            if (cart == null) return (0, 0, 0, 0);

            int totalItems = cart.CartItems.Sum(x => x.Quantity);
            decimal subtotal = cart.CartItems.Sum(x => (decimal)x.Quantity * x.Product.UnitPrice);
            decimal discount = 0;

            string? voucherCode = HttpContext.Session.GetString("VoucherCode");
            if (!string.IsNullOrEmpty(voucherCode))
            {
                var voucher = await _context.Vouchers.FirstOrDefaultAsync(v => v.VoucherCode == voucherCode && v.IsActive);
                if (voucher != null && (!voucher.ExpiryDate.HasValue || voucher.ExpiryDate.Value >= DateTime.Now))
                {
                    if (voucher.DiscountPercent.HasValue)
                    {
                        discount = subtotal * voucher.DiscountPercent.Value / 100;
                    }
                    else if (voucher.DiscountAmount.HasValue)
                    {
                        discount = voucher.DiscountAmount.Value;
                    }
                    if (discount > subtotal) discount = subtotal;

                    HttpContext.Session.SetString("DiscountAmount", discount.ToString());
                }
                else
                {
                    HttpContext.Session.Remove("DiscountAmount");
                    HttpContext.Session.Remove("DiscountText");
                    HttpContext.Session.Remove("VoucherCode");
                }
            }

            decimal grandTotal = subtotal - discount;

            return (totalItems, subtotal, discount, grandTotal);
        }

        [HttpPost]
        public async Task<IActionResult> ApplyVoucher(string voucherCode)
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            Request.Cookies.TryGetValue("GuestCartId", out string? guestCartId);

            Cart? cart = null;
            if (accountId != null)
            {
                cart = await _context.Carts
                    .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.Product)
                    .FirstOrDefaultAsync(c => c.AccountId == accountId);
            }
            else if (!string.IsNullOrEmpty(guestCartId))
            {
                cart = await _context.Carts
                    .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.Product)
                    .FirstOrDefaultAsync(c => c.CartId == guestCartId);
            }

            if (cart == null)
            {
                return Json(new
                {
                    success = false,
                    message = Loc.T("Không tìm thấy giỏ hàng", "Cart not found")
                });
            }

            decimal subtotal = cart.CartItems.Sum(x =>
                x.Product.UnitPrice * x.Quantity);

            // KHÔNG NHẬP VOUCHER HOẶC XÓA VOUCHER
            if (string.IsNullOrWhiteSpace(voucherCode))
            {
                HttpContext.Session.Remove("DiscountAmount");
                HttpContext.Session.Remove("DiscountText");
                HttpContext.Session.Remove("VoucherCode");

                return Json(new
                {
                    success = true,
                    discount = 0,
                    finalTotal = subtotal
                });
            }

            var voucher = await _context.Vouchers
                .FirstOrDefaultAsync(v =>
                    v.VoucherCode == voucherCode &&
                    v.IsActive);

            if (voucher == null || (voucher.ExpiryDate.HasValue && voucher.ExpiryDate.Value < DateTime.Now))
            {
                return Json(new
                {
                    success = false,
                    message = Loc.T("Voucher không hợp lệ hoặc đã hết hạn", "Invalid or expired voucher")
                });
            }

            if (voucher.UsageLimit.HasValue && voucher.UsedCount >= voucher.UsageLimit.Value)
            {
                return Json(new
                {
                    success = false,
                    message = Loc.T("Mã giảm giá này đã hết lượt sử dụng", "This voucher has reached its usage limit")
                });
            }

            decimal discount = 0;
            string discountText = "";

            // GIẢM %
            if (voucher.DiscountPercent.HasValue)
            {
                discount = subtotal * voucher.DiscountPercent.Value / 100;
                discountText = $"({voucher.DiscountPercent.Value}%)";
            }

            // GIẢM TIỀN
            else if (voucher.DiscountAmount.HasValue)
            {
                discount = voucher.DiscountAmount.Value;
            }

            // KHÔNG CHO ÂM
            if (discount > subtotal)
            {
                discount = subtotal;
            }

            decimal finalTotal = subtotal - discount;

            HttpContext.Session.SetString(
                "DiscountAmount",
                discount.ToString()
            );
            HttpContext.Session.SetString(
                "DiscountText",
                discountText
            );
            HttpContext.Session.SetString(
                "VoucherCode",
                voucher.VoucherCode
            );
            return Json(new
            {
                success = true,
                discount = discount,
                finalTotal = finalTotal,
                discountText = discountText
            });
        }
    }
}