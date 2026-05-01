using TuNhanTamTInh_Ecommerce.Models;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class SaleOffProductsViewModel
    {
        public IReadOnlyList<VProductCard> Products { get; set; } = [];
    }
}
