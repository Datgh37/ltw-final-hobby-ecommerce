namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class ProductCardViewModel
    {
        public int ProductId { get; set; }

        public string ProductName { get; set; } = null!;

        public string? ProductSlug { get; set; }

        public decimal UnitPrice { get; set; }

        public double Discount { get; set; }

        public decimal FinalPrice { get; set; }

        public int CategoryId { get; set; }

        public string? CategoryName { get; set; }

        public int? SeriesId { get; set; }

        public string? SeriesName { get; set; }

        public string? PrimaryImage { get; set; }

        public double AverageRating { get; set; }

        public int ViewCount { get; set; }

        public int StockQuantity { get; set; }

        public bool IsOnSale => Discount > 0;

        public bool IsInStock => StockQuantity > 0;

        public decimal DiscountPercent => Discount > 1 ? (decimal)Discount : (decimal)(Discount * 100);

        public bool IsFavorite { get; set; } // Thêm property này để theo dõi trạng thái yêu thích của người dùng
    }
}
