using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Category
{
    public int CategoryId { get; set; }

    public string CategoryName { get; set; } = null!;

    public string? CategorySlug { get; set; }

    public string? Image { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
