using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.ViewComponents
{
    public class CartViewComponent : ViewComponent
    {
        private readonly EcommerceHobbyShopContext _context;

        public CartViewComponent(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var model = new CartPreviewViewModel();

            try
            {
                var accountId = User.Identity?.IsAuthenticated == true ? UserClaimsPrincipal.FindFirst("AccountId")?.Value : null;
                HttpContext.Request.Cookies.TryGetValue("GuestCartId", out string? guestCartId);

                Cart? cart = null;
                if (!string.IsNullOrEmpty(accountId))
                {
                    cart = await _context.Carts
                        .Include(x => x.CartItems)
                            .ThenInclude(ci => ci.Product)
                                .ThenInclude(p => p.ProductImages)
                        .FirstOrDefaultAsync(x => x.AccountId == accountId);
                }
                else if (!string.IsNullOrEmpty(guestCartId))
                {
                    cart = await _context.Carts
                        .Include(x => x.CartItems)
                            .ThenInclude(ci => ci.Product)
                                .ThenInclude(p => p.ProductImages)
                        .FirstOrDefaultAsync(x => x.CartId == guestCartId);
                }

                if (cart != null && cart.CartItems != null)
                {
                            model.TotalItems = cart.CartItems.Sum(x => x.Quantity);
                            model.GrandTotal = cart.CartItems.Sum(x => x.Quantity * x.Product.GetFinalPrice());
                            model.Items = cart.CartItems
                                .OrderByDescending(x => x.CartItemId)
                                .Select(ci => new CartPreviewItem
                                {
                                    CartItemId = ci.CartItemId,
                                    ProductId = ci.ProductId,
                                    ProductName = ci.Product?.ProductName ?? "Sản phẩm",
                                    ImageUrl = ci.Product?.ProductImages?
                                        .FirstOrDefault(img => img.IsPrimary)?.ImageUrl
                                        ?? ci.Product?.ProductImages?
                                            .FirstOrDefault()?.ImageUrl
                                        ?? "~/images/product-default.png",
                                    UnitPrice = ci.Product?.UnitPrice ?? 0,
                                    Quantity = ci.Quantity,
                                    StockQuantity = ci.Product?.StockQuantity ?? 0
                                })
                                .ToList();
                }
            }
            catch
            {
                // Nếu có lỗi, trả về giỏ hàng trống thay vì crash cả trang
            }

            return View(model);
        }
    }
}