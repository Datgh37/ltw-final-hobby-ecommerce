using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;

namespace TuNhanTamTInh_Ecommerce
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            var myConnectionString = builder.Configuration.GetConnectionString("MyConnectString");

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
