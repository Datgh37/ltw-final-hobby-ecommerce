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

        public async Task<IViewComponentResult> InvokeAsync(int take = 6, string type = "latest")
        {
            var query = _context.Products.AsNoTracking();

            switch (type.ToLower())
            {
                case "toprated":
                    query = query.OrderByDescending(x => x.Reviews.Average(r => r.Rating));
                    break;
                case "popular":
                    query = query.OrderByDescending(x => x.ViewCount);
                    break;
                default:
                    query = query.OrderByDescending(x => x.CreatedAt);
                    break;
            }

            var products = await query
                .Take(take)
                .ProjectToCard()
                .ToListAsync();

            return View(products);
        }
    }
}
