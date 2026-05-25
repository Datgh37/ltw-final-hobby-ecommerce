using System;
using System.ComponentModel.DataAnnotations;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public class MinimumAgeAttribute : ValidationAttribute
    {
        private readonly int _minimumAge;

        public MinimumAgeAttribute(int minimumAge)
        {
            _minimumAge = minimumAge;
        }

        protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
        {
            if (value == null)
            {
                return ValidationResult.Success; // Not required by default
            }

            if (DateTime.TryParse(value.ToString(), out DateTime dateOfBirth))
            {
                var today = DateTime.Today;
                var age = today.Year - dateOfBirth.Year;
                
                // Go back to the year in which the person was born in case of a leap year
                if (dateOfBirth.Date > today.AddYears(-age))
                {
                    age--;
                }

                if (age < _minimumAge)
                {
                    // The error message specifies both languages separated by a pipe if needed,
                    // but we can just use the provided ErrorMessage in the view model.
                    return new ValidationResult(ErrorMessage ?? $"Bạn phải từ {_minimumAge} tuổi trở lên. | You must be at least {_minimumAge} years old.");
                }

                return ValidationResult.Success;
            }

            return new ValidationResult(ErrorMessage ?? "Ngày sinh không hợp lệ. | Invalid date of birth.");
        }
    }
}
