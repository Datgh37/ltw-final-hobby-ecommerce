using System.Net;
using System.Net.Mail;

namespace TuNhanTamTInh_Ecommerce.Helpers
{
    public static class EmailHelper
    {
        public static async Task SendEmailAsync(IConfiguration configuration, string email, string subject, string htmlMessage)
        {
            var mailSettings = configuration.GetSection("MailSettings");
            
            var host = mailSettings["Host"];
            var port = int.Parse(mailSettings["Port"] ?? "587");
            var fromEmail = mailSettings["Email"];
            var password = mailSettings["Password"];
            var displayName = mailSettings["DisplayName"];

            if (string.IsNullOrWhiteSpace(fromEmail) || 
                fromEmail.Contains("YOUR_EMAIL") || 
                !fromEmail.Contains("@"))
            {
                throw new ArgumentException(
                    "SMTP Sender Email is not configured. Please update the 'Email' field in 'MailSettings' section of appsettings.json or set the 'MailSettings__Email' environment variable on your hosting panel. | " +
                    "Chưa cấu hình Email gửi SMTP. Vui lòng cập nhật trường 'Email' trong mục 'MailSettings' tại appsettings.json hoặc cấu hình biến môi trường 'MailSettings__Email' trên trang quản trị hosting của bạn."
                );
            }

            using (var client = new SmtpClient(host, port))
            {
                client.EnableSsl = true;
                client.Credentials = new NetworkCredential(fromEmail, password);

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(fromEmail, displayName),
                    Subject = subject,
                    Body = htmlMessage,
                    IsBodyHtml = true
                };

                mailMessage.To.Add(email);

                await client.SendMailAsync(mailMessage);
            }
        }
    }
}
