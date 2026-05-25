using System.ComponentModel.DataAnnotations;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class RegisterViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập Tên đăng nhập (Username). | Please enter your Username.")]
        [MaxLength(20, ErrorMessage = "Username không được vượt quá 20 ký tự. | Username cannot exceed 20 characters.")]
        [RegularExpression(@"^[a-zA-Z0-9_]+$", ErrorMessage = "Username chỉ được chứa chữ cái, số và dấu gạch dưới. | Username can only contain letters, numbers, and underscores.")]
        public string Username { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập Họ và Tên. | Please enter your Full Name.")]
        [MaxLength(50, ErrorMessage = "Họ và Tên không được vượt quá 50 ký tự. | Full Name cannot exceed 50 characters.")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập Email. | Please enter your Email.")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ. | Invalid email address.")]
        [MaxLength(50, ErrorMessage = "Email không được vượt quá 50 ký tự. | Email cannot exceed 50 characters.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập Mật khẩu. | Please enter your Password.")]
        [DataType(DataType.Password)]
        [MinLength(6, ErrorMessage = "Mật khẩu phải có ít nhất 6 ký tự. | Password must be at least 6 characters long.")]
        [MaxLength(50, ErrorMessage = "Mật khẩu không được vượt quá 50 ký tự. | Password cannot exceed 50 characters.")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Vui lòng xác nhận Mật khẩu. | Please confirm your Password.")]
        [DataType(DataType.Password)]
        [Compare("Password", ErrorMessage = "Mật khẩu và Xác nhận Mật khẩu không khớp. | Password and Confirm Password do not match.")]
        public string ConfirmPassword { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mã xác thực email. | Please enter the email verification code.")]
        public string VerificationCode { get; set; }
    }
}
