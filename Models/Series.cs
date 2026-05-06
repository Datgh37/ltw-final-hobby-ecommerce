using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Series
{
    public int SeriesId { get; set; }

    public string SeriesName { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
