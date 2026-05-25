using System.ComponentModel.DataAnnotations;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class LoginViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập Username hoặc Email. | Please enter your Username or Email.")]
        public string UsernameOrEmail { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập Mật khẩu. | Please enter your Password.")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        public bool RememberMe { get; set; }  
    }
}
