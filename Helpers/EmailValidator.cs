using DnsClient;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public static class EmailValidator
    {
        // Danh sách các đuôi email dễ bị gõ sai phổ biến
        private static readonly string[] InvalidTypoDomains = new[] { "gmail.co", "gmai.com", "gamil.com", "gmail.cmo", "yahoo.co", "yahoo.cmo", "hotmail.co", "hotmail.cmo" };

        public static async Task<(bool IsValid, string ErrorMessage)> ValidateEmailDomainAsync(string email)
        {
            if (string.IsNullOrWhiteSpace(email) || !email.Contains("@"))
            {
                return (false, Loc.T("Định dạng email không hợp lệ.", "Invalid email format."));
            }

            var parts = email.Split('@');
            if (parts.Length != 2) return (false, Loc.T("Định dạng email không hợp lệ.", "Invalid email format."));

            var domain = parts[1].ToLower();

            // 1. Kiểm tra typo phổ biến (Custom Validation)
            if (InvalidTypoDomains.Contains(domain))
            {
                string suggestedDomain = domain.Replace(".co", ".com").Replace("gmai.", "gmail.").Replace("gamil.", "gmail.").Replace(".cmo", ".com");
                return (false, Loc.T($"Tên miền '{domain}' có vẻ bị gõ sai. Có phải ý bạn là '@{suggestedDomain}'?", 
                                     $"Domain '{domain}' seems to be a typo. Did you mean '@{suggestedDomain}'?"));
            }

            // 2. Kiểm tra MX Record bằng DnsClient
            try
            {
                var lookup = new LookupClient();
                // Query MX (Mail Exchange) records cho domain
                var result = await lookup.QueryAsync(domain, QueryType.MX);
                
                // Nếu domain không có MX record nào
                if (result.HasError || !result.Answers.MxRecords().Any())
                {
                    return (false, Loc.T($"Không tìm thấy máy chủ nhận thư cho đuôi '@{domain}'. Email này không có thực.", 
                                         $"No mail server found for domain '@{domain}'. This email address is unreachable."));
                }
            }
            catch (Exception)
            {
                // Bỏ qua lỗi kết nối mạng cục bộ / DNS Server để không cản trở người dùng
                // Nếu timeout thì đành cho gửi thử
            }

            return (true, string.Empty);
        }
    }
}
