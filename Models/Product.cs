using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Product
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

    public int CategoryId { get; set; }

    public int? SeriesId { get; set; }

    public string SupplierId { get; set; } = null!;

    public decimal UnitPrice { get; set; }

    private string? _description;
    public string? Description 
    { 
        get 
        {
            var culture = System.Threading.Thread.CurrentThread.CurrentUICulture.Name;
            if (culture == "en-US" && !string.IsNullOrEmpty(DescriptionEn))
            {
                return DescriptionEn;
            }
            return _description;
        }
        set { _description = value; }
    }

    public string? DescriptionEn { get; set; }

    public double Discount { get; set; }

    public int ViewCount { get; set; }

    public int StockQuantity { get; set; }

    /// <summary>
    /// Tính giá bán thực tế sau khi áp dụng Discount của sản phẩm.
    /// Hỗ trợ cả Discount dạng phần trăm nguyên (20 = 20%) lẫn dạng thập phân (0.2 = 20%).
    /// </summary>
    public decimal GetFinalPrice()
    {
        if (Discount <= 0) return UnitPrice;
        double discountPercent = Discount > 1 ? Discount : Discount * 100;
        return UnitPrice * (1m - (decimal)discountPercent / 100m);
    }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();

    public virtual Category Category { get; set; } = null!;

    public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

    public virtual ICollection<ProductImage> ProductImages { get; set; } = new List<ProductImage>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual Series? Series { get; set; }

    public virtual Supplier Supplier { get; set; } = null!;
}
