using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models;

public partial class Order
{
    public int OrderId { get; set; }

    public string AccountId { get; set; } = null!;

    public DateTime OrderDate { get; set; }

    public string? FullName { get; set; }

    public string Address { get; set; } = null!;

    public string? PhoneNumber { get; set; }

    public string PaymentMethod { get; set; } = null!;

    public decimal ShippingFee { get; set; }

    public int StatusId { get; set; }

    public bool IsPaid { get; set; }

    public string? TrackingNumber { get; set; }

    public string? VoucherCode { get; set; }

    public string? TransactionId { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

    public virtual Status Status { get; set; } = null!;

    public virtual Voucher? VoucherCodeNavigation { get; set; }
}
