using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.ViewComponents
{
    public class HeroSectionViewComponent : ViewComponent
    {
        private readonly EcommerceHobbyShopContext _context;

        public HeroSectionViewComponent(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync(bool isHome = false)
        {
            var viewModel = new HeroSectionViewModel
            {
                Categories = await _context.Categories.AsNoTracking().OrderBy(x => x.CategoryId).ToListAsync(),
                Series = await _context.Series.AsNoTracking().OrderBy(y => y.SeriesId).ToListAsync()
            };
            // Có 2 VC cho hero section, của home có thêm Ảnh bìa sản phẩm nổi bật
            var viewName = isHome ? "Home" : "Default";
            return View(viewName, viewModel);
        }
    }
}
