using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Helpers;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly EcommerceHobbyShopContext _context;

        public HomeController(ILogger<HomeController> logger, EcommerceHobbyShopContext context)
        {
            _logger = logger;
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var categories = await _context.Categories.AsNoTracking().ToListAsync();
            
            var featuredProducts = await _context.Products
                .AsNoTracking()
                .OrderBy(x => Guid.NewGuid()) // Random Products from Database
                .Take(8)
                .ProjectToCard()
                .ToListAsync();

            var viewModel = new HomeViewModel
            {
                FeaturedCategories = categories,
                FeaturedProducts = featuredProducts
            };

            return View(viewModel);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
