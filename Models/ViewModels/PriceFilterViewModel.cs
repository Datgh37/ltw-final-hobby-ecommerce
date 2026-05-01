namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class PriceFilterViewModel
    {
        public decimal MinPrice { get; set; }

        public decimal MaxPrice { get; set; }

        public decimal SelectedMinPrice { get; set; }

        public decimal SelectedMaxPrice { get; set; }

        /// <summary>
        /// Shared query parameters for preserving filters when applying price.
        /// </summary>
        public ProductIndexQueryViewModel Query { get; set; } = new();
    }
}
