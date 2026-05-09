using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Chỉ ép cổng khi deploy (non-Development) có cung cấp PORT.
            // Development local sẽ dùng launchSettings (http/https).
            var port = Environment.GetEnvironmentVariable("PORT");
            if (!builder.Environment.IsDevelopment()
                && !string.IsNullOrWhiteSpace(port)
                && int.TryParse(port, out var parsedPort))
            {
                builder.WebHost.ConfigureKestrel(options =>
                {
                    options.ListenAnyIP(parsedPort);
                });
            }

            var myConnectionString = builder.Configuration.GetConnectionString("MyConnectString");

            // Add services to the container.
            builder.Services.AddControllersWithViews();
            builder.Services.AddDbContext<EcommerceHobbyShopContext>(option => option.UseSqlServer(myConnectionString));
            builder.Services.AddAutoMapper(cfg => cfg.AddMaps(typeof(AutoMapperProfile).Assembly));
            
            // Add Session support
            builder.Services.AddDistributedMemoryCache();
            builder.Services.AddSession(options =>
            {
                options.IdleTimeout = TimeSpan.FromMinutes(10); // Code hết hạn sau 10 phút
                options.Cookie.HttpOnly = true;
                options.Cookie.IsEssential = true;
            });
            
            // Add Cookie Authentication
            builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
                .AddCookie(options =>
                {
                    options.LoginPath = "/Account/Login";
                    options.LogoutPath = "/Account/Logout";
                    options.AccessDeniedPath = "/Account/AccessDenied";
                    options.Cookie.HttpOnly = true;
                    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
                });

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();
            app.UseSession();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.Run();
        }
    }
}
