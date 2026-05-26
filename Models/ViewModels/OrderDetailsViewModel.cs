using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class OrderDetailsViewModel
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public string? FullName { get; set; }
        public string Address { get; set; } = null!;
        public string? PhoneNumber { get; set; }
        public string? Email { get; set; } // Lấy từ Account
        
        public string PaymentMethod { get; set; } = null!;
        public int StatusId { get; set; }
        public string StatusName { get; set; } = null!;
        public string StatusNameEn { get; set; } = null!;
        public bool IsPaid { get; set; }
        public string? TrackingNumber { get; set; }
        public string? TransactionId { get; set; }
        public string? VoucherCode { get; set; }
        public decimal ShippingFee { get; set; }

        public List<OrderDetailItemViewModel> Items { get; set; } = new();

        public decimal Subtotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal FinalTotal { get; set; }
    }

    public class OrderDetailItemViewModel
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = null!;
        public string? ProductImage { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }
}
