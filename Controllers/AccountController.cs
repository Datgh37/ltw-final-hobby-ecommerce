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
                            ModelState.AddModelError(string.Empty, "Tài khoản của bạn chưa được kích hoạt. Vui lòng kiểm tra email.");
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

                        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                        {
                            return Json(new { success = true, message = "Đăng nhập thành công! Đang chuyển hướng...", returnUrl = returnUrl });
                        }

                        return LocalRedirect(returnUrl);
                    }
                }
                
                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = false, message = "Tên đăng nhập, email hoặc mật khẩu không đúng." });
                }

                ModelState.AddModelError(string.Empty, "Tên đăng nhập, email hoặc mật khẩu không đúng.");
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
            if (string.IsNullOrEmpty(email)) return Json(new { success = false, message = "Vui lòng nhập email." });
            if (string.IsNullOrEmpty(username)) return Json(new { success = false, message = "Vui lòng nhập tên đăng nhập." });

            // 1. Kiểm tra Username tồn tại chưa
            var usernameExists = await _context.Accounts.AnyAsync(a => a.AccountId == username);
            if (usernameExists) return Json(new { success = false, message = "Tên đăng nhập này đã tồn tại." });

            // 2. Kiểm tra Email tồn tại chưa
            var emailExists = await _context.Accounts.AnyAsync(a => a.Email == email);
            if (emailExists) return Json(new { success = false, message = "Email này đã được sử dụng." });

            var otpCode = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("RegisterOTP", otpCode);
            HttpContext.Session.SetString("RegisterEmail", email);

            try
            {
                string subject = "Mã xác thực đăng ký tài khoản - Hobby Shop";
                string body = $"<h3>Chào mừng bạn! Mã xác thực đăng ký của bạn là: <b style='color:#560bad;'>{otpCode}</b></h3><p>Vui lòng nhập mã này để hoàn tất đăng ký.</p>";
                
                await EmailHelper.SendEmailAsync(_configuration, email, subject, body);
                
                return Json(new { success = true, message = "Mã OTP đã được gửi." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi gửi mail: " + ex.Message });
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
                return Json(new { success = false, message = "Mã xác thực không chính xác hoặc đã hết hạn." });
            }

            var emailExists = await _context.Accounts.AnyAsync(a => a.Email == model.Email);
            if (emailExists) return Json(new { success = false, message = "Email này đã được sử dụng." });

            var usernameExists = await _context.Accounts.AnyAsync(a => a.AccountId == model.Username);
            if (usernameExists) return Json(new { success = false, message = "Tên đăng nhập này đã tồn tại." });

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

            return Json(new { success = true, message = "Đăng ký thành công! Đang chuyển hướng..." });
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

            if (ModelState.IsValid)
            {
                var account = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == model.AccountId);
                if (account == null) return NotFound();

                // Kiểm tra trùng Email khi thay đổi
                if (account.Email != model.Email)
                {
                    var emailExists = await _context.Accounts.AnyAsync(a => a.Email == model.Email && a.AccountId != model.AccountId);
                    if (emailExists)
                    {
                        ModelState.AddModelError("Email", "Email này đã được sử dụng bởi tài khoản khác.");
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
                    return Json(new { success = true, message = "Cập nhật hồ sơ thành công!" });
                }

                TempData["SuccessMessage"] = "Cập nhật hồ sơ thành công!";
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
            if (string.IsNullOrEmpty(email)) return Json(new { success = false, message = "Vui lòng nhập email." });

            var account = await _context.Accounts.FirstOrDefaultAsync(a => a.Email == email);
            if (account == null) return Json(new { success = false, message = "Email này không tồn tại trong hệ thống." });

            var otpCode = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("ResetOTP", otpCode);
            HttpContext.Session.SetString("ResetEmail", email);

            try
            {
                string subject = "Mã xác thực khôi phục mật khẩu - Hobby Shop";
                string body = $"<h3>Mã xác thực của bạn là: <b style='color:#560bad;'>{otpCode}</b></h3><p>Mã này sẽ hết hạn sau 10 phút. Nếu bạn không yêu cầu hành động này, vui lòng bỏ qua email.</p>";
                await EmailHelper.SendEmailAsync(_configuration, email, subject, body);
                return Json(new { success = true, message = "Mã OTP đã được gửi vào email của bạn." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi khi gửi email: " + ex.Message });
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
                return Json(new { success = true, message = "Xác thực thành công." });
            }
            return Json(new { success = false, message = "Mã xác thực không chính xác hoặc đã hết hạn." });
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
                ModelState.AddModelError("VerificationCode", "Mã xác thực không chính xác hoặc đã hết hạn.");
                return View(model);
            }

            if (ModelState.IsValid)
            {
                var account = await _context.Accounts.FirstOrDefaultAsync(a => a.Email == model.Email);
                if (account == null) return NotFound();

                // Kiểm tra mật khẩu mới trùng mật khẩu cũ
                if (BCrypt.Net.BCrypt.Verify(model.NewPassword, account.Password))
                {
                    ModelState.AddModelError("NewPassword", "Mật khẩu mới không được trùng với mật khẩu cũ.");
                    return View(model);
                }

                account.Password = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
                _context.Update(account);
                await _context.SaveChangesAsync();

                HttpContext.Session.Remove("ResetOTP");
                HttpContext.Session.Remove("ResetEmail");

                TempData["SuccessMessage"] = "Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.";
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

            if (account == null) return Json(new { success = false, message = "Không tìm thấy tài khoản." });

            if (!BCrypt.Net.BCrypt.Verify(model.OldPassword, account.Password))
            {
                return Json(new { success = false, message = "Mật khẩu hiện tại không chính xác." });
            }

            // Kiểm tra mật khẩu mới trùng mật khẩu cũ
            if (BCrypt.Net.BCrypt.Verify(model.NewPassword, account.Password))
            {
                return Json(new { success = false, message = "Mật khẩu mới không được trùng với mật khẩu cũ." });
            }

            account.Password = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
            _context.Update(account);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Đổi mật khẩu thành công!" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Home");
        }
    }
}
