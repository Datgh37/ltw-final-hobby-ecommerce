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

            // Query only distinct CategoryId - SeriesId pairs from Products table
            // This is extremely lightweight and fast
            var productMappings = await _context.Products
                .AsNoTracking()
                .Where(p => p.SeriesId != null)
                .Select(p => new { p.CategoryId, SeriesId = p.SeriesId.Value })
                .Distinct()
                .ToListAsync();

            var categorySeriesMap = new Dictionary<int, List<TuNhanTamTInh_Ecommerce.Models.Series>>();
            
            foreach (var mapping in productMappings)
            {
                if (!categorySeriesMap.ContainsKey(mapping.CategoryId))
                {
                    categorySeriesMap[mapping.CategoryId] = new List<TuNhanTamTInh_Ecommerce.Models.Series>();
                }

                var seriesObj = viewModel.Series.FirstOrDefault(s => s.SeriesId == mapping.SeriesId);
                if (seriesObj != null)
                {
                    categorySeriesMap[mapping.CategoryId].Add(seriesObj);
                }
            }

            viewModel.CategorySeriesMap = categorySeriesMap;

            ViewData["IsHomePage"] = isHome;
            return View(viewModel);
        }
    }
}
