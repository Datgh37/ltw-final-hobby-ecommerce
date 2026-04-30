using Microsoft.AspNetCore.Mvc;
using TuNhanTamTInh_Ecommerce.Data;

namespace TuNhanTamTInh_Ecommerce.ViewComponents
{
    public class ProductCardViewComponent : ViewComponent
    {
        private readonly EcommerceHobbyShopContext _context;
        public ProductCardViewComponent(EcommerceHobbyShopContext context)
        {
            _context = context;
        }
        public async Task<IViewComponentResult> InvokeAsync()
        {
            return View();
        }
    }
}
