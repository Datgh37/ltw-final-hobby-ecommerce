using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce.ViewComponents
{
    public class ProductLatestProductsViewComponent : ViewComponent
    {
        private readonly EcommerceHobbyShopContext _context;

        public ProductLatestProductsViewComponent(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync(int take = 6)
        {
            var latestProducts = await _context.Products
                .AsNoTracking()
                .OrderByDescending(x => x.ProductId)
                .Take(take)
                .ProjectToCard()
                .ToListAsync();

            return View(latestProducts);
        }
    }
}
