using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Category
{
    public int CategoryId { get; set; }

    private string _categoryName = null!;
    public string CategoryName 
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

    public string? CategorySlug { get; set; }

    public string? Image { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
