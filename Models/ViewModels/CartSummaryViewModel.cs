namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class CartSummaryViewModel
    {
        public decimal Subtotal { get; set; }

        public decimal DiscountAmount { get; set; }

        public decimal FinalTotal { get; set; }

        public string? VoucherCode { get; set; }
    }
}
