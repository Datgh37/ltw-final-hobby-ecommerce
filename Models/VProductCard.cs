using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class VProductCard
{
    public int ProductId { get; set; }

    public string ProductName { get; set; } = null!;

    public string? ProductSlug { get; set; }

    public decimal UnitPrice { get; set; }

    public double Discount { get; set; }

    public string? CategoryName { get; set; }

    public string? SeriesName { get; set; }

    public string? PrimaryImage { get; set; }

    public double AverageRating { get; set; }
}
