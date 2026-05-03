using TuNhanTamTInh_Ecommerce.Models.ViewModels;
using TuNhanTamTInh_Ecommerce.Models;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class HomeViewModel
    {
        public List<ProductCardViewModel> FeaturedProducts { get; set; } = new();
        public List<Category> FeaturedCategories { get; set; } = new();
    }
}
