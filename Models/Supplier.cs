using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Supplier
{
    public string SupplierId { get; set; } = null!;

    public string CompanyName { get; set; } = null!;

    public string Logo { get; set; } = null!;

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
