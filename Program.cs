using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.HttpOverrides;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var isContainer = Environment.GetEnvironmentVariable("DOTNET_RUNNING_IN_CONTAINER") == "true";

            // Tự động nạp file .env ở thư mục gốc nếu tồn tại (Hỗ trợ chạy ngoài Docker vẫn nhận cấu hình bảo mật)
            var envPath = Path.Combine(Directory.GetCurrentDirectory(), ".env");
            if (File.Exists(envPath))
            {
                foreach (var line in File.ReadAllLines(envPath))
                {
                    var trimmed = line.Trim();
                    if (string.IsNullOrWhiteSpace(trimmed) || trimmed.StartsWith("#")) continue;
                    var parts = trimmed.Split('=', 2);
                    if (parts.Length == 2)
                    {
                        var key = parts[0].Trim();
                        var value = parts[1].Trim();

                        // Nếu chạy ngoài container (local host), ta KHÔNG nạp ConnectionString từ .env 
                        // để hệ thống tự sử dụng ConnectionString cục bộ (có pass sa = 123456) trong appsettings.json
                        if (!isContainer && key.StartsWith("ConnectionStrings"))
                        {
                            continue;
                        }

                        // Chỉ set nếu chưa có sẵn để tránh ghi đè các cấu hình hệ thống hoặc Docker Compose
                        if (Environment.GetEnvironmentVariable(key) == null)
                        {
                            Environment.SetEnvironmentVariable(key, value);
                        }
                    }
                }
            }

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
            builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");
            builder.Services.AddSingleton<Microsoft.Extensions.Localization.IStringLocalizerFactory, CustomStringLocalizerFactory>();

            builder.Services.AddControllersWithViews()
                .AddViewLocalization(Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat.Suffix)
                .AddDataAnnotationsLocalization();
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

            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("AdminOnly", policy => policy.RequireClaim("RoleId", "0"));
            });

            // Configure Forwarded Headers for Cloudflare Tunnel / Reverse Proxy hosting
            builder.Services.Configure<ForwardedHeadersOptions>(options =>
            {
                options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
                options.KnownNetworks.Clear();
                options.KnownProxies.Clear();
            });

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            app.UseForwardedHeaders();

            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            // Cấu hình ngôn ngữ hỗ trợ (Tiếng Việt mặc định & Tiếng Anh)
            var supportedCultures = new[] { "vi-VN", "en-US" };
            var localizationOptions = new RequestLocalizationOptions()
                .SetDefaultCulture(supportedCultures[0])
                .AddSupportedCultures(supportedCultures)
                .AddSupportedUICultures(supportedCultures);
            
            app.UseRequestLocalization(localizationOptions);

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
