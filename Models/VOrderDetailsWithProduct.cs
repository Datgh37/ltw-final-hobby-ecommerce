using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class VOrderDetailsWithProduct
{
    public int OrderId { get; set; }

    public int OrderDetailId { get; set; }

    public int ProductId { get; set; }

    public string ProductName { get; set; } = null!;

    public string? PrimaryImage { get; set; }

    public decimal UnitPrice { get; set; }

    public int Quantity { get; set; }

    public double Discount { get; set; }

    public double? TotalPrice { get; set; }
}
