namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class ProductCardViewModel
    {
        public int ProductId { get; set; }

        private string _productName = null!;
        public string ProductName 
        { 
            get 
            {
                var culture = System.Threading.Thread.CurrentThread.CurrentUICulture.Name;
                if (culture == "en-US" && !string.IsNullOrEmpty(ProductNameEn))
                {
                    return ProductNameEn;
                }
                return _productName;
            }
            set { _productName = value; }
        }

        public string? ProductNameEn { get; set; }

        public string? ProductSlug { get; set; }

        public decimal UnitPrice { get; set; }

        public double Discount { get; set; }

        public decimal FinalPrice { get; set; }

        public int CategoryId { get; set; }

        private string? _categoryName;
        public string? CategoryName
        {
            get
            {
                var culture = System.Threading.Thread.CurrentThread.CurrentUICulture.Name;
                if (culture == "en-US" && !string.IsNullOrEmpty(CategoryNameEn))
                {
                    return CategoryNameEn;
                }
                return _categoryName;
            }
            set { _categoryName = value; }
        }

        public string? CategoryNameEn { get; set; }

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
