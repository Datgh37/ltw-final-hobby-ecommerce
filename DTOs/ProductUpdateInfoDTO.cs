namespace TuNhanTamTInh_Ecommerce.DTOs
{
    public class ProductUpdateInfoDTO
    {
        public string ProductName { get; set; } = null!;
        public string? ProductSlug { get; set; }
        public int CategoryId { get; set; }
        public int? SeriesId { get; set; }
        public string SupplierId { get; set; } = null!;
        public decimal UnitPrice { get; set; }
        public string? Description { get; set; }
        public double Discount { get; set; }
        public int StockQuantity { get; set; }
    }
}
