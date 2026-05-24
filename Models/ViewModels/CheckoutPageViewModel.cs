using TuNhanTamTInh_Ecommerce.Models;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class CheckoutPageViewModel
    {
        [ValidateNever]
        public Cart Cart { get; set; } = new Cart();
        public CheckOutViewModel Checkout { get; set; }= new CheckOutViewModel();
        public CartSummaryViewModel Summary { get; set; }= new CartSummaryViewModel();
    }
}
