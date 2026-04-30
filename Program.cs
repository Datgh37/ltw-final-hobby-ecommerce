using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            // Config cho web deploy (hiện tại đang thử nghiệm)
            var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
            builder.WebHost.ConfigureKestrel(options =>
            {
                options.ListenAnyIP(int.Parse(port));
            });

            var myConnectionString = builder.Configuration.GetConnectionString("MyConnectString");
            // Console.WriteLine("==================================================");
            // Console.WriteLine($"[DEBUG] Connection String Length: {myConnectionString?.Length ?? 0}");
            // Console.WriteLine($"[DEBUG] Connection String Starts With: {myConnectionString?.Substring(0, Math.Min(30, myConnectionString?.Length ?? 0))}");
            // Console.WriteLine("==================================================");

            // Add services to the container.
            builder.Services.AddControllersWithViews();
            builder.Services.AddDbContext<EcommerceHobbyShopContext>(option => option.UseSqlServer(myConnectionString));

            // Add Auto Mapper
            builder.Services.AddAutoMapper(cfg => {
                cfg.AddMaps(typeof(AutoMapperProfile).Assembly);
            });

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.Run();
        }
    }
}
