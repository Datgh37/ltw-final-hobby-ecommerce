using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Helpers;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class AccountController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;
        private readonly IConfiguration _configuration;

        public AccountController(EcommerceHobbyShopContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        // GET: /Account/Login
        [HttpGet]
        public IActionResult Login(string returnUrl = "/")
        {
            if (User.Identity!.IsAuthenticated) return LocalRedirect(returnUrl);
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }
        
        // POST: /Account/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model, string returnUrl = "/")
        {
            if (ModelState.IsValid)
            {
                var identifier = model.UsernameOrEmail?.Trim();
                var password = model.Password?.Trim();

                var account = await _context.Accounts
                    .Include(a => a.Role)
                    .FirstOrDefaultAsync(a => (a.Email == identifier || a.AccountId == identifier));

                if (account != null)
                {
                    bool isPasswordValid = false;
                    try 
                    {
                        isPasswordValid = BCrypt.Net.BCrypt.Verify(password, account.Password);
                    } 
                    catch (Exception) 
                    {
                        // Fallback for old plain-text passwords
                        if (account.Password == password) 
                        {
                            isPasswordValid = true;
                            account.Password = BCrypt.Net.BCrypt.HashPassword(password!);
                            _context.Update(account);
                            await _context.SaveChangesAsync();
                        }
                    }

                    if (isPasswordValid)
                    {
                        if (!account.IsActive)
                        {
                            ModelState.AddModelError(string.Empty, Loc.T("Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email.", "Your account is not activated. Please check your email."));
                            return View(model);
                        }

                        var claims = new List<Claim>
                        {
                            new Claim(ClaimTypes.Name, account.FullName),
                            new Claim(ClaimTypes.Email, account.Email),
                            new Claim("AccountId", account.AccountId),
                            new Claim("UserImage", account.Image ?? "/images/user-default.png"),
                            new Claim("RoleId", account.RoleId.ToString()),
                            new Claim(ClaimTypes.Role, account.Role?.RoleName ?? "Khách hàng")
                        };

                        var claimsIdentity = new ClaimsIdentity(
                            claims, CookieAuthenticationDefaults.AuthenticationScheme);

                        var authProperties = new AuthenticationProperties
                        {
                            IsPersistent = model.RememberMe,
                            ExpiresUtc = model.RememberMe 
                                ? DateTimeOffset.UtcNow.AddDays(7)      // 7 ngày nếu tick
                                : DateTimeOffset.UtcNow.AddHours(1)     // 1 giờ nếu không tick
                        };

                        await HttpContext.SignInAsync(
                            CookieAuthenticationDefaults.AuthenticationScheme,
                            new ClaimsPrincipal(claimsIdentity),
                            authProperties);

                        // Gộp giỏ hàng vãng lai vào giỏ hàng chính thức sau khi đăng nhập thành công.
                        // Sử dụng stored procedure 'sp_SyncCart' để xử lý gộp số lượng an toàn.
                        if (Request.Cookies.TryGetValue("GuestCartId", out string? guestCartId))
                        {
                            await _context.Database.ExecuteSqlRawAsync("EXEC sp_SyncCart @p0, @p1", guestCartId, account.AccountId);
                            Response.Cookies.Delete("GuestCartId");
                        }

                        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                        {
                            return Json(new { success = true, message = Loc.T("Đăng nhập thành công! Đang chuyển hướng...", "Login successful! Redirecting..."), returnUrl = returnUrl });
                        }

                        return LocalRedirect(returnUrl);
                    }
                }
                
                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = false, message = Loc.T("Tên đăng nhập, email hoặc mật khẩu không đúng.", "Incorrect username, email or password.") });
                }

                ModelState.AddModelError(string.Empty, Loc.T("Tên đăng nhập, email hoặc mật khẩu không đúng.", "Incorrect username, email or password."));
            }

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return Json(new { success = false, message = string.Join("<br/>", errors) });
            }

            ViewData["ReturnUrl"] = returnUrl;
            return View(model);
        }
        
        // GET: /Account/Register
        [HttpGet]
        public IActionResult Register()
        {
            if (User.Identity!.IsAuthenticated) return RedirectToAction("Index", "Home");
            return View();
        }
        
        // POST: /Account/SendRegisterOTP (AJAX)
        [HttpPost]
        public async Task<IActionResult> SendRegisterOTP(string username, string email)
        {
            if (string.IsNullOrEmpty(email)) return Json(new { success = false, message = Loc.T("Vui lòng nhập email.", "Please enter email.") });
            if (string.IsNullOrEmpty(username)) return Json(new { success = false, message = Loc.T("Vui lòng nhập tên đăng nhập.", "Please enter username.") });

            // 1. Kiểm tra Username tồn tại chưa
            var usernameExists = await _context.Accounts.AnyAsync(a => a.AccountId == username);
            if (usernameExists) return Json(new { success = false, message = Loc.T("Tên đăng nhập này đã tồn tại.", "This username already exists.") });

            // 2. Kiểm tra Email tồn tại chưa
            var emailExists = await _context.Accounts.AnyAsync(a => a.Email == email);
            if (emailExists) return Json(new { success = false, message = Loc.T("Email này đã được sử dụng.", "This email is already in use.") });

            // 3. Kiểm tra tính hợp lệ của domain email và chống Typo
            var emailValidation = await EmailValidator.ValidateEmailDomainAsync(email);
            if (!emailValidation.IsValid)
            {
                return Json(new { success = false, message = emailValidation.ErrorMessage });
            }

            var otpCode = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("RegisterOTP", otpCode);
            HttpContext.Session.SetString("RegisterEmail", email);

            try
            {
                string subject = Loc.T("Mã xác thực đăng ký tài khoản - Hobby Shop", "Account Registration OTP Code - Hobby Shop");
                string body = Loc.T($"<h3>Chào mừng bạn! Mã xác thực đăng ký của bạn là: <b style='color:#560bad;'>{otpCode}</b></h3><p>Vui lòng nhập mã này để hoàn tất đăng ký.</p>",
                                     $"<h3>Welcome! Your registration verification code is: <b style='color:#560bad;'>{otpCode}</b></h3><p>Please enter this code to complete registration.</p>");
                
                await EmailHelper.SendEmailAsync(_configuration, email, subject, body);
                
                return Json(new { success = true, message = Loc.T("Mã OTP đã được gửi.", "OTP code has been sent.") });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = Loc.T("Lỗi gửi mail: ", "Email transmission error: ") + ex.Message });
            }
        }

        // POST: /Account/Register (AJAX)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return Json(new { success = false, message = string.Join("<br/>", errors) });
            }

            // Kiểm tra OTP
            var sessionOTP = HttpContext.Session.GetString("RegisterOTP");
            var sessionEmail = HttpContext.Session.GetString("RegisterEmail");

            if (model.VerificationCode != sessionOTP || model.Email != sessionEmail)
            {
                return Json(new { success = false, message = Loc.T("Mã xác thực không chính xác hoặc đã hết hạn.", "Verification code is incorrect or expired.") });
            }

            var emailExists = await _context.Accounts.AnyAsync(a => a.Email == model.Email);
            if (emailExists) return Json(new { success = false, message = Loc.T("Email này đã được sử dụng.", "This email is already in use.") });

            var usernameExists = await _context.Accounts.AnyAsync(a => a.AccountId == model.Username);
            if (usernameExists) return Json(new { success = false, message = Loc.T("Tên đăng nhập này đã tồn tại.", "This username already exists.") });

            var newAccount = new Account
            {
                AccountId = model.Username,
                FullName = model.FullName,
                Email = model.Email,
                Password = BCrypt.Net.BCrypt.HashPassword(model.Password),
                RoleId = 1,
                IsActive = true
            };

            _context.Accounts.Add(newAccount);
            await _context.SaveChangesAsync();

            // Dọn dẹp session
            HttpContext.Session.Remove("RegisterOTP");
            HttpContext.Session.Remove("RegisterEmail");

            // Login luôn
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, newAccount.FullName),
                new Claim(ClaimTypes.Email, newAccount.Email),
                new Claim("AccountId", newAccount.AccountId),
                new Claim("UserImage", newAccount.Image ?? "/images/user-default.png"),
                new Claim("RoleId", "1"),
                new Claim(ClaimTypes.Role, "Khách hàng")
            };
            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));

            // Gộp giỏ hàng vãng lai vào giỏ hàng chính thức sau khi đăng ký thành công.
            // Sử dụng stored procedure 'sp_SyncCart' để xử lý gộp số lượng an toàn.
            if (Request.Cookies.TryGetValue("GuestCartId", out string? guestCartId))
            {
                await _context.Database.ExecuteSqlRawAsync("EXEC sp_SyncCart @p0, @p1", guestCartId, newAccount.AccountId);
                Response.Cookies.Delete("GuestCartId");
            }

            return Json(new { success = true, message = Loc.T("Đăng ký thành công! Đang chuyển hướng...", "Registration successful! Redirecting...") });
        }

        // GET /Account/Profile
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> Profile()
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            var account = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == accountId);
            if (account == null) return NotFound();

            return View(account);
        }

        // GET: /Account/EditProfile
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> EditProfile()
        {
            // CLEAR OTP SESSION
            HttpContext.Session.Remove("EmailChangeOTP");
            HttpContext.Session.Remove("EmailChangeEmail");
            HttpContext.Session.Remove("EmailChangeOTPVerified");

            var accountId = User.FindFirst("AccountId")?.Value;
            var account = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == accountId);
            if (account == null) return NotFound();

            var model = new EditProfileViewModel
            {
                AccountId = account.AccountId,
                FullName = account.FullName,
                Email = account.Email,
                PhoneNumber = account.PhoneNumber,
                Address = account.Address,
                BirthDate = account.BirthDate,
                Gender = account.Gender,
                Image = account.Image
            };

            return View(model);
        }

        // POST: /Account/EditProfile
        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditProfile(EditProfileViewModel model)
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            if (accountId != model.AccountId) return Unauthorized();

            // Kiểm tra đủ 18 tuổi ở backend
            if (model.BirthDate.HasValue)
            {
                var today = DateTime.Today;
                var age = today.Year - model.BirthDate.Value.Year;
                if (model.BirthDate.Value.Date > today.AddYears(-age)) age--;

                if (age < 18)
                {
                    ModelState.AddModelError("BirthDate", Loc.T("Bạn phải đủ 18 tuổi để cập nhật thông tin.", "You must be at least 18 years old to update your profile."));
                }
            }

            if (ModelState.IsValid)
            {
                var account = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == model.AccountId);
                if (account == null) return NotFound();

                // Kiểm tra trùng Email khi thay đổi
                if (account.Email != model.Email)
                {
                    // Kiểm tra OTP xác thực đổi email
                    if (HttpContext.Session.GetString("EmailChangeOTPVerified") != "true")
                    {
                        ModelState.AddModelError("Email", Loc.T("Bạn chưa xác thực OTP cho email mới.", "You have not verified OTP for the new email."));
                        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                        {
                            return Json(new { success = false, message = Loc.T("Bạn chưa xác thực OTP cho email mới.", "You have not verified OTP for the new email.") });
                        }
                        return View(model);
                    }

                    var emailExists = await _context.Accounts.AnyAsync(a => a.Email == model.Email && a.AccountId != model.AccountId);
                    if (emailExists)
                    {
                        ModelState.AddModelError("Email", Loc.T("Email này đã được sử dụng bởi tài khoản khác.", "This email is already used by another account."));
                        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                        {
                            return Json(new { success = false, message = Loc.T("Email này đã được sử dụng bởi tài khoản khác.", "This email is already used by another account.") });
                        }
                        return View(model);
                    }
                }

                // Xử lý Upload Avatar
                if (model.AvatarFile != null && model.AvatarFile.Length > 0)
                {
                    var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "avatars");
                    if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

                    // Xóa ảnh cũ
                    if (!string.IsNullOrEmpty(account.Image) && account.Image != "~/images/user-default.png")
                    {
                        var oldPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", account.Image.Replace("~/", "").Replace("/", "\\"));
                        if (System.IO.File.Exists(oldPath)) System.IO.File.Delete(oldPath);
                    }

                    // Sử dụng GUID + Tên file gốc (Đã an toàn vì DB đã nâng cấp lên 255 ký tự)
                    var uniqueFileName = Guid.NewGuid().ToString() + "_" + model.AvatarFile.FileName;
                    var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        await model.AvatarFile.CopyToAsync(fileStream);
                    }

                    account.Image = "~/images/avatars/" + uniqueFileName;
                }

                // Cập nhật thông tin
                account.FullName = model.FullName;
                account.Email = model.Email;
                account.PhoneNumber = model.PhoneNumber;
                account.Address = model.Address;
                account.BirthDate = model.BirthDate;
                account.Gender = model.Gender;
                
                _context.Entry(account).State = EntityState.Modified;
                await _context.SaveChangesAsync();

                // Cập nhật lại Cookie Auth để hiển thị tên và ảnh mới trên Header ngay lập tức
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, account.FullName),
                    new Claim(ClaimTypes.Email, account.Email),
                    new Claim("AccountId", account.AccountId),
                    new Claim("UserImage", account.Image ?? "~/images/user-default.png"),
                    new Claim("RoleId", account.RoleId.ToString()),
                    new Claim(ClaimTypes.Role, User.FindFirstValue(ClaimTypes.Role) ?? "Khách hàng")
                };
                
                var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                var authProperties = new AuthenticationProperties
                {
                    IsPersistent = true,
                    ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7)
                };

                await HttpContext.SignInAsync(
                    CookieAuthenticationDefaults.AuthenticationScheme, 
                    new ClaimsPrincipal(claimsIdentity),
                    authProperties);

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = true, message = Loc.T("Cập nhật hồ sơ thành công!", "Profile updated successfully!") });
                }

                TempData["SuccessMessage"] = Loc.T("Cập nhật hồ sơ thành công!", "Profile updated successfully!");
                return RedirectToAction(nameof(Profile));
            }

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return Json(new { success = false, message = string.Join("<br/>", errors) });
            }

            return View(model);
        }

        // GET: /Account/ChangePassword
        [Authorize]
        [HttpGet]
        public IActionResult ChangePassword()
        {
            return View();
        }

        // GET: /Account/ForgotPassword
        [HttpGet]
        public IActionResult ForgotPassword()
        {
            return View(new ForgotPasswordViewModel());
        }

        // POST: /Account/SendOTP (AJAX)
        [HttpPost]
        public async Task<IActionResult> SendOTP(string email)
        {
            if (string.IsNullOrEmpty(email)) return Json(new { success = false, message = Loc.T("Vui lòng nhập email.", "Please enter email.") });

            var account = await _context.Accounts.FirstOrDefaultAsync(a => a.Email == email);
            if (account == null) return Json(new { success = false, message = Loc.T("Email này không tồn tại trong hệ thống.", "This email does not exist in the system.") });

            // 3. Kiểm tra tính hợp lệ của domain email và chống Typo
            var emailValidation = await EmailValidator.ValidateEmailDomainAsync(email);
            if (!emailValidation.IsValid)
            {
                return Json(new { success = false, message = emailValidation.ErrorMessage });
            }

            var otpCode = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("ResetOTP", otpCode);
            HttpContext.Session.SetString("ResetEmail", email);

            try
            {
                string subject = Loc.T("Mã xác thực khôi phục mật khẩu - Hobby Shop", "Password Recovery OTP Code - Hobby Shop");
                string body = Loc.T($"<h3>Mã xác thực của bạn là: <b style='color:#560bad;'>{otpCode}</b></h3><p>Mã này sẽ hết hạn sau 10 phút. Nếu bạn không yêu cầu hành động này, vui lòng bỏ qua email.</p>",
                                     $"<h3>Your verification code is: <b style='color:#560bad;'>{otpCode}</b></h3><p>This code will expire in 10 minutes. If you did not request this action, please ignore this email.</p>");
                await EmailHelper.SendEmailAsync(_configuration, email, subject, body);
                return Json(new { success = true, message = Loc.T("Mã OTP đã được gửi vào email của bạn.", "OTP code has been sent to your email.") });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = Loc.T("Lỗi khi gửi email: ", "Error sending email: ") + ex.Message });
            }
        }

        // POST: /Account/VerifyResetOTP (AJAX)
        [HttpPost]
        public IActionResult VerifyResetOTP(string email, string code)
        {
            var sessionOTP = HttpContext.Session.GetString("ResetOTP");
            var sessionEmail = HttpContext.Session.GetString("ResetEmail");

            if (code == sessionOTP && email == sessionEmail)
            {
                return Json(new { success = true, message = Loc.T("Xác thực thành công.", "Verification successful.") });
            }
            return Json(new { success = false, message = Loc.T("Mã xác thực không chính xác hoặc đã hết hạn.", "Verification code is incorrect or expired.") });
        }

        // POST: /Account/ForgotPassword
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ForgotPassword(ForgotPasswordViewModel model)
        {
            var sessionOTP = HttpContext.Session.GetString("ResetOTP");
            var sessionEmail = HttpContext.Session.GetString("ResetEmail");

            if (model.VerificationCode != sessionOTP || model.Email != sessionEmail)
            {
                ModelState.AddModelError("VerificationCode", Loc.T("Mã xác thực không chính xác hoặc đã hết hạn.", "Verification code is incorrect or expired."));
                return View(model);
            }

            if (ModelState.IsValid)
            {
                var account = await _context.Accounts.FirstOrDefaultAsync(a => a.Email == model.Email);
                if (account == null) return NotFound();

                // Kiểm tra mật khẩu mới trùng mật khẩu cũ
                if (BCrypt.Net.BCrypt.Verify(model.NewPassword, account.Password))
                {
                    ModelState.AddModelError("NewPassword", Loc.T("Mật khẩu mới không được trùng với mật khẩu cũ.", "New password cannot be the same as the old password."));
                    return View(model);
                }

                account.Password = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
                _context.Update(account);
                await _context.SaveChangesAsync();

                HttpContext.Session.Remove("ResetOTP");
                HttpContext.Session.Remove("ResetEmail");

                TempData["SuccessMessage"] = Loc.T("Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.", "Password reset successful! Please login again.");
                return RedirectToAction("Login");
            }
            return View(model);
        }

        // POST: /Account/ChangePassword
        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword(ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return Json(new { success = false, message = string.Join("<br/>", errors) });
            }

            var accountId = User.FindFirst("AccountId")?.Value;
            var account = await _context.Accounts.FindAsync(accountId);

            if (account == null) return Json(new { success = false, message = Loc.T("Không tìm thấy tài khoản.", "Account not found.") });

            if (!BCrypt.Net.BCrypt.Verify(model.OldPassword, account.Password))
            {
                return Json(new { success = false, message = Loc.T("Mật khẩu hiện tại không chính xác.", "Current password is incorrect.") });
            }

            // Kiểm tra mật khẩu mới trùng mật khẩu cũ
            if (BCrypt.Net.BCrypt.Verify(model.NewPassword, account.Password))
            {
                return Json(new { success = false, message = Loc.T("Mật khẩu mới không được trùng với mật khẩu cũ.", "New password cannot be the same as the old password.") });
            }

            account.Password = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
            _context.Update(account);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = Loc.T("Đổi mật khẩu thành công!", "Password changed successfully!") });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Home");
        }
        // POST: /Account/SendEmailChangeOTP (AJAX)
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> SendEmailChangeOTP(string newEmail)
        {
            if (string.IsNullOrEmpty(newEmail)) return Json(new { success = false, message = Loc.T("Vui lòng nhập email.", "Please enter email.") });

            var emailExists = await _context.Accounts.AnyAsync(a => a.Email == newEmail);
            if (emailExists) return Json(new { success = false, message = Loc.T("Email này đã được sử dụng bởi tài khoản khác.", "This email is already used by another account.") });

            // Kiểm tra tính hợp lệ của domain email và chống Typo
            var emailValidation = await EmailValidator.ValidateEmailDomainAsync(newEmail);
            if (!emailValidation.IsValid)
            {
                return Json(new { success = false, message = emailValidation.ErrorMessage });
            }

            var otpCode = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("EmailChangeOTP", otpCode);
            HttpContext.Session.SetString("EmailChangeEmail", newEmail);
            HttpContext.Session.Remove("EmailChangeOTPVerified");

            try
            {
                string subject = Loc.T("Mã xác thực thay đổi Email - Hobby Shop", "Email Change Verification OTP - Hobby Shop");
                string body = Loc.T($"<h3>Mã xác thực của bạn là: <b style='color:#560bad;'>{otpCode}</b></h3><p>Mã này sẽ hết hạn sau 10 phút. Vui lòng nhập mã này để hoàn tất thay đổi email.</p>",
                                     $"<h3>Your verification code is: <b style='color:#560bad;'>{otpCode}</b></h3><p>This code will expire in 10 minutes. Please enter this code to complete email change.</p>");
                await EmailHelper.SendEmailAsync(_configuration, newEmail, subject, body);
                return Json(new { success = true, message = Loc.T("Mã OTP đã được gửi vào email mới của bạn.", "OTP code has been sent to your new email.") });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = Loc.T("Lỗi khi gửi email: ", "Error sending email: ") + ex.Message });
            }
        }

        // POST: /Account/VerifyEmailChangeOTP (AJAX)
        [HttpPost]
        [Authorize]
        public IActionResult VerifyEmailChangeOTP(string code)
        {
            var sessionOTP = HttpContext.Session.GetString("EmailChangeOTP");

            if (!string.IsNullOrEmpty(sessionOTP) && code == sessionOTP)
            {
                HttpContext.Session.SetString("EmailChangeOTPVerified", "true");
                return Json(new { success = true, message = Loc.T("Xác thực thành công.", "Verification successful.") });
            }
            return Json(new { success = false, message = Loc.T("Mã xác thực không chính xác.", "Verification code is incorrect.") });
        }

        // POST: /Account/ClearEmailChangeOTP (AJAX)
        [HttpPost]
        [Authorize]
        public IActionResult ClearEmailChangeOTP()
        {
            HttpContext.Session.Remove("EmailChangeOTP");
            HttpContext.Session.Remove("EmailChangeEmail");
            HttpContext.Session.Remove("EmailChangeOTPVerified");
            return Json(new { success = true });
        }
    }
}
