using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;

namespace TuNhanTamTInh_Ecommerce.ViewComponents
{
    public class CartViewComponent : ViewComponent
    {
        private readonly EcommerceHobbyShopContext _context;
        public CartViewComponent(
            EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult>
            InvokeAsync()
        {
            int totalItems = 0;
            if (User.Identity.IsAuthenticated)
            {
                var accountId =
                    UserClaimsPrincipal
                    .FindFirst("AccountId")
                    ?.Value;
                var cart = await _context.Carts
                    .Include(x => x.CartItems)
                    .FirstOrDefaultAsync(x =>
                        x.AccountId == accountId);
                if (cart != null)
                {
                    totalItems =
                        cart.CartItems.Sum(x =>
                            x.Quantity);
                }
            }
            return View(totalItems);
        }
    }
}