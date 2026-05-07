using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Voucher
{
    public string VoucherCode { get; set; } = null!;

    public int? DiscountPercent { get; set; }

    public decimal? DiscountAmount { get; set; }

    public int? UsageLimit { get; set; }

    public int UsedCount { get; set; }

    public DateTime? ExpiryDate { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
}
