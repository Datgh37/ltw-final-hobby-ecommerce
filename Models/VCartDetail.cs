using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class VCartDetail
{
    public string CartId { get; set; } = null!;

    public int CartItemId { get; set; }

    public int ProductId { get; set; }

    public string ProductName { get; set; } = null!;

    public string? PrimaryImage { get; set; }

    public decimal UnitPrice { get; set; }

    public double Discount { get; set; }

    public int Quantity { get; set; }

    public double? TotalItemPrice { get; set; }
}
