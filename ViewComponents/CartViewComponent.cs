using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
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
                if (User.Identity?.IsAuthenticated == true)
                {
                    var accountId = UserClaimsPrincipal.FindFirst("AccountId")?.Value;
                    if (!string.IsNullOrEmpty(accountId))
                    {
                        var cart = await _context.Carts
                            .Include(x => x.CartItems)
                                .ThenInclude(ci => ci.Product)
                                    .ThenInclude(p => p.ProductImages)
                            .FirstOrDefaultAsync(x => x.AccountId == accountId);

                        if (cart != null && cart.CartItems != null)
                        {
                            model.TotalItems = cart.CartItems.Sum(x => x.Quantity);
                            model.GrandTotal = cart.CartItems.Sum(x => x.Quantity * x.Product.UnitPrice);
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