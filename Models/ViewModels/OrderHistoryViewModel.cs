using System;
using System.Collections.Generic;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class OrderHistoryViewModel
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public string StatusName { get; set; } = null!;
        public string StatusNameEn { get; set; } = null!;
        public bool IsPaid { get; set; }
        public string PaymentMethod { get; set; } = null!;
        public int StatusId { get; set; }
    }
}
