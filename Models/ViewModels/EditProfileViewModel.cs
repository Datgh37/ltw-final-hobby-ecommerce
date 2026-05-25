using System;
using System.ComponentModel.DataAnnotations;

namespace TuNhanTamTInh_Ecommerce.Models.ViewModels
{
    public class EditProfileViewModel
    {
        public string AccountId { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập họ và tên | Please enter your full name")]
        [Display(Name = "Họ và tên")]
        public string FullName { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập email | Please enter your email")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ | Invalid email address")]
        [Display(Name = "Email")]
        public string Email { get; set; } = null!;

        [RegularExpression(@"^(0[3|5|7|8|9])+([0-9]{8})$", ErrorMessage = "Số điện thoại không hợp lệ | Invalid phone number")]
        [Display(Name = "Số điện thoại")]
        public string? PhoneNumber { get; set; }

        [Display(Name = "Địa chỉ")]
        public string? Address { get; set; }

        [DataType(DataType.Date)]
        [TuNhanTamTInh_Ecommerce.Helpers.MinimumAge(18, ErrorMessage = "Người dùng phải từ 18 tuổi trở lên! | User must be at least 18 years old!")]
        [Display(Name = "Ngày sinh")]
        public DateTime? BirthDate { get; set; }

        [Display(Name = "Giới tính")]
        public bool Gender { get; set; } // true: Nam, false: Nữ

        [Display(Name = "Ảnh đại diện")]
        public string? Image { get; set; }

        [Display(Name = "Tải ảnh mới")]
        public IFormFile? AvatarFile { get; set; }
    }
}
