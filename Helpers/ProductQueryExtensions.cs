using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public static class ProductQueryExtensions
    {
        /// <summary>
        /// Projects an IQueryable&lt;Product&gt; into IQueryable&lt;ProductCardViewModel&gt;.
        /// EF Core translates this to optimized SQL — no .Include() needed.
        /// </summary>
        public static IQueryable<ProductCardViewModel> ProjectToCard(this IQueryable<Product> query)
        {
            return query.Select(x => new ProductCardViewModel
            {
                ProductId = x.ProductId,
                ProductName = x.ProductName,
                ProductSlug = x.ProductSlug,
                UnitPrice = x.UnitPrice,
                Discount = x.Discount,
                FinalPrice = x.Discount > 0
                    ? x.UnitPrice * (1 - (decimal)x.Discount)
                    : x.UnitPrice,
                CategoryId = x.CategoryId,
                CategoryName = x.Category.CategoryName,
                SeriesId = x.SeriesId,
                SeriesName = x.Series != null ? x.Series.SeriesName : null,
                PrimaryImage = x.ProductImages
                    .Where(pi => pi.IsPrimary)
                    .Select(pi => pi.ImageUrl)
                    .FirstOrDefault(),
                AverageRating = x.Reviews.Any()
                    ? x.Reviews.Average(r => (double)r.Rating)
                    : 0,
                ViewCount = x.ViewCount,
                StockQuantity = x.StockQuantity,
                IsFavorite = false // Default false, will be set on client-side or in controller
            });
        }
    }
}
