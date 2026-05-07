using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using TuNhanTamTInh_Ecommerce.Data;

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
            string userId = UserClaimsPrincipal?
                .FindFirst(ClaimTypes.NameIdentifier)?
                .Value;

            if (userId == null)
            {
                return View(0);
            }

            int totalItems = await _context.CartItems
                .Where(x => x.Cart.AccountId == userId)
                .SumAsync(x => x.Quantity);

            return View(totalItems);
        }
    }
}