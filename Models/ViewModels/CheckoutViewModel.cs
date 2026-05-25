using System.ComponentModel.DataAnnotations;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class CheckOutViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập họ và tên | Please enter your full name")]
        public string FullName { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại | Please enter your phone number")]
        [RegularExpression(@"^(0[3|5|7|8|9])+([0-9]{8})$", ErrorMessage = "Số điện thoại không hợp lệ | Invalid phone number")]
        public string Phone { get; set; } = null!;

        public string? Email { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập địa chỉ nhận hàng | Please enter your delivery address")]
        public string Address { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng chọn phương thức thanh toán | Please select a payment method")]
        public string PaymentMethod { get; set; } = null!;

        public string? VoucherCode { get; set; }

        public string? Note { get; set; }

        public decimal ExpectedSubtotal { get; set; }
    }
}