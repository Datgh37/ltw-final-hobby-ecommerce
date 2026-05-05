using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class AccountController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;

        public AccountController(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login(string returnUrl = "/")
        {
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

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
                    .FirstOrDefaultAsync(a => 
                        (a.Email == identifier || a.AccountId == identifier) 
                        && a.Password == password);

                if (account != null)
                {
                    if (!account.IsActive)
                    {
                        ModelState.AddModelError(string.Empty, "Tài khoản của bạn đã bị khóa.");
                        return View(model);
                    }

                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, account.FullName),
                        new Claim(ClaimTypes.Email, account.Email),
                        new Claim("AccountId", account.AccountId),
                        new Claim(ClaimTypes.Role, account.Role.RoleName)
                    };

                    var claimsIdentity = new ClaimsIdentity(
                        claims, CookieAuthenticationDefaults.AuthenticationScheme);

                    var authProperties = new AuthenticationProperties
                    {
                        IsPersistent = true,
                        ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7)
                    };

                    await HttpContext.SignInAsync(
                        CookieAuthenticationDefaults.AuthenticationScheme,
                        new ClaimsPrincipal(claimsIdentity),
                        authProperties);

                    return LocalRedirect(returnUrl);
                }
                
                ModelState.AddModelError(string.Empty, "Tên đăng nhập, email hoặc mật khẩu không đúng.");
            }

            ViewData["ReturnUrl"] = returnUrl;
            return View(model);
        }

        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                var emailExists = await _context.Accounts.AnyAsync(a => a.Email == model.Email);
                if (emailExists)
                {
                    ModelState.AddModelError("Email", "Email này đã được sử dụng.");
                    return View(model);
                }

                var usernameExists = await _context.Accounts.AnyAsync(a => a.AccountId == model.Username);
                if (usernameExists)
                {
                    ModelState.AddModelError("Username", "Tên đăng nhập này đã tồn tại. Vui lòng chọn tên khác.");
                    return View(model);
                }

                var newAccount = new Account
                {
                    AccountId = model.Username, // Use Username as AccountId
                    FullName = model.FullName,
                    Email = model.Email,
                    Password = model.Password, // Ideally should be hashed
                    RoleId = 0, // 0 is the default RoleId for Customers
                    IsActive = true
                };

                _context.Accounts.Add(newAccount);
                await _context.SaveChangesAsync();

                // Automatically login the user after successful registration
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, newAccount.FullName),
                    new Claim(ClaimTypes.Email, newAccount.Email),
                    new Claim("AccountId", newAccount.AccountId),
                    new Claim(ClaimTypes.Role, "Customer") // Assuming RoleId 2 is Customer
                };

                var claimsIdentity = new ClaimsIdentity(
                    claims, CookieAuthenticationDefaults.AuthenticationScheme);

                await HttpContext.SignInAsync(
                    CookieAuthenticationDefaults.AuthenticationScheme,
                    new ClaimsPrincipal(claimsIdentity));

                return RedirectToAction("Index", "Home");
            }

            return View(model);
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
