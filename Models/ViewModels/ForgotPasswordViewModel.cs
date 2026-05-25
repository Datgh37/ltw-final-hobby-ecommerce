using System.ComponentModel.DataAnnotations;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class ForgotPasswordViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập Email. | Please enter your Email.")]
        [EmailAddress(ErrorMessage = "Định dạng Email không hợp lệ. | Invalid email format.")]
        [Display(Name = "Email")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập mã xác nhận. | Please enter the verification code.")]
        [Display(Name = "Mã xác nhận")]
        public string? VerificationCode { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mật khẩu mới. | Please enter a new password.")]
        [DataType(DataType.Password)]
        [StringLength(100, ErrorMessage = "{0} phải có ít nhất {2} ký tự. | {0} must be at least {2} characters long.", MinimumLength = 6)]
        [Display(Name = "Mật khẩu mới")]
        public string? NewPassword { get; set; }

        [Required(ErrorMessage = "Vui lòng xác nhận mật khẩu mới. | Please confirm your new password.")]
        [DataType(DataType.Password)]
        [Display(Name = "Xác nhận mật khẩu mới")]
        [Compare("NewPassword", ErrorMessage = "Mật khẩu mới và xác nhận mật khẩu không khớp. | New password and confirm password do not match.")]
        public string? ConfirmPassword { get; set; }

        // State to control which part of the UI to show
        public bool IsCodeVerified { get; set; } = false;
    }
}
