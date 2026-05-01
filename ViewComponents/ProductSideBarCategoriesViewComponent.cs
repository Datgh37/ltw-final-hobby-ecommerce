using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;

namespace TuNhanTamTInh_Ecommerce.ViewComponents
{
    public class ProductSidebarCategoriesViewComponent : ViewComponent
    {
        private readonly EcommerceHobbyShopContext _context;

        public ProductSidebarCategoriesViewComponent(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var categories = await _context.Categories.AsNoTracking().OrderBy(x => x.CategoryId).ToListAsync();
            return View(categories);
        }
    }
}
