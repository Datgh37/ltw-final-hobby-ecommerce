using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class ProductIndexViewModel
    {
        public ProductIndexQueryViewModel Query { get; set; } = new();

        public PriceFilterViewModel PriceFilter { get; set; } = new();

        public SortOptionsViewModel SortOptions { get; set; } = new();

        public PaginationViewModel Pagination { get; set; } = new();

        public IReadOnlyList<ProductCardViewModel> Products { get; set; } = [];

        public IReadOnlyList<ProductCardViewModel> SaleOffProducts { get; set; } = [];
    }
}
