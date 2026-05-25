using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    [Authorize]
    public class OrdersController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;
        private readonly IConfiguration _configuration;

        public OrdersController(EcommerceHobbyShopContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        // GET: /Orders/History
        public async Task<IActionResult> History()
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            if (string.IsNullOrEmpty(accountId)) return RedirectToAction("Login", "Account");

            var orders = await _context.Orders
                .Include(o => o.Status)
                .Include(o => o.OrderDetails)
                .Where(o => o.AccountId == accountId)
                .OrderByDescending(o => o.OrderDate)
                .Select(o => new OrderHistoryViewModel
                {
                    OrderId = o.OrderId,
                    OrderDate = o.OrderDate,
                    StatusName = o.Status.StatusName,
                    StatusNameEn = o.Status.StatusNameEn,
                    IsPaid = o.IsPaid,
                    PaymentMethod = o.PaymentMethod,
                    StatusId = o.StatusId,
                    TotalAmount = o.OrderDetails.Sum(od => od.UnitPrice * od.Quantity) + o.ShippingFee // Trừ Discount sẽ tính kỹ hơn trong Details
                })
                .ToListAsync();

            // Tính toán lại TotalAmount chính xác có áp dụng Voucher
            foreach (var orderVm in orders)
            {
                var order = await _context.Orders
                    .Include(o => o.OrderDetails)
                    .Include(o => o.VoucherCodeNavigation)
                    .FirstOrDefaultAsync(o => o.OrderId == orderVm.OrderId);

                if (order != null)
                {
                    decimal subtotal = order.OrderDetails.Sum(od => od.UnitPrice * od.Quantity);
                    decimal discount = 0;
                    if (order.VoucherCodeNavigation != null)
                    {
                        if (order.VoucherCodeNavigation.DiscountPercent.HasValue)
                        {
                            discount = subtotal * order.VoucherCodeNavigation.DiscountPercent.Value / 100;
                        }
                        else if (order.VoucherCodeNavigation.DiscountAmount.HasValue)
                        {
                            discount = order.VoucherCodeNavigation.DiscountAmount.Value;
                        }
                        if (discount > subtotal) discount = subtotal;
                    }
                    orderVm.TotalAmount = subtotal - discount + order.ShippingFee;
                }
            }

            return View(orders);
        }

        // GET: /Orders/Details/5
        public async Task<IActionResult> Details(int id)
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            if (string.IsNullOrEmpty(accountId)) return RedirectToAction("Login", "Account");

            var order = await _context.Orders
                .Include(o => o.Status)
                .Include(o => o.Account)
                .Include(o => o.OrderDetails)
                    .ThenInclude(od => od.Product)
                        .ThenInclude(p => p.ProductImages)
                .Include(o => o.VoucherCodeNavigation)
                .FirstOrDefaultAsync(o => o.OrderId == id && o.AccountId == accountId);

            if (order == null)
            {
                return NotFound();
            }

            decimal subtotal = order.OrderDetails.Sum(od => od.UnitPrice * od.Quantity);
            decimal discount = 0;
            if (order.VoucherCodeNavigation != null)
            {
                if (order.VoucherCodeNavigation.DiscountPercent.HasValue)
                {
                    discount = subtotal * order.VoucherCodeNavigation.DiscountPercent.Value / 100;
                }
                else if (order.VoucherCodeNavigation.DiscountAmount.HasValue)
                {
                    discount = order.VoucherCodeNavigation.DiscountAmount.Value;
                }
                if (discount > subtotal) discount = subtotal;
            }

            var vm = new OrderDetailsViewModel
            {
                OrderId = order.OrderId,
                OrderDate = order.OrderDate,
                FullName = order.FullName,
                Address = order.Address,
                PhoneNumber = order.PhoneNumber,
                Email = order.Account.Email,
                PaymentMethod = order.PaymentMethod,
                StatusId = order.StatusId,
                StatusName = order.Status.StatusName,
                StatusNameEn = order.Status.StatusNameEn,
                IsPaid = order.IsPaid,
                TrackingNumber = order.TrackingNumber,
                VoucherCode = order.VoucherCode,
                ShippingFee = order.ShippingFee,
                Subtotal = subtotal,
                DiscountAmount = discount,
                FinalTotal = subtotal - discount + order.ShippingFee,
                Items = order.OrderDetails.Select(od => new OrderDetailItemViewModel
                {
                    ProductId = od.ProductId,
                    ProductName = od.Product.ProductName,
                    ProductImage = od.Product.ProductImages.FirstOrDefault(i => i.IsPrimary)?.ImageUrl 
                                    ?? od.Product.ProductImages.FirstOrDefault()?.ImageUrl 
                                    ?? "~/images/no-image.png",
                    Quantity = od.Quantity,
                    UnitPrice = od.UnitPrice
                }).ToList()
            };

            return View(vm);
        }

        // POST: /Orders/CancelOrder/5
        [HttpPost]
        public async Task<IActionResult> CancelOrder(int id)
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            if (string.IsNullOrEmpty(accountId)) return RedirectToAction("Login", "Account");

            var order = await _context.Orders
                .Include(o => o.Account)
                .Include(o => o.OrderDetails)
                .FirstOrDefaultAsync(o => o.OrderId == id && o.AccountId == accountId);

            if (order == null)
            {
                return NotFound();
            }

            if (order.StatusId >= 2)
            {
                TempData["error"] = Loc.T("Không thể hủy đơn hàng này.", "Cannot cancel this order.");
                return RedirectToAction("Details", new { id = order.OrderId });
            }

            try
            {
                // Gọi stored procedure từ C#
                await _context.Database.ExecuteSqlInterpolatedAsync($"EXEC sp_CancelOrder @OrderID={id}");
                
                TempData["Success"] = Loc.T("Hủy đơn hàng thành công.", "Order cancelled successfully.");

                // Gửi email thông báo hủy
                if (!string.IsNullOrEmpty(order.Account?.Email))
                {
                    try
                    {
                        string vnpayNote = "";
                        if (order.IsPaid && order.PaymentMethod == "VNPAY")
                        {
                            vnpayNote = $"<p style='color: #d9534f;'><strong>{Loc.T("Lưu ý:", "Note:")}</strong> {Loc.T("Đơn hàng của bạn đã được thanh toán qua VNPAY. Chúng tôi sẽ tiến hành đối soát và hoàn tiền lại vào tài khoản của bạn trong vòng 3-5 ngày làm việc.", "Your order has been paid via VNPAY. We will process and refund to your account within 3-5 business days.")}</p>";
                        }

                        string bodyHtml = $@"
                            <h2>{Loc.T("Thông báo hủy đơn hàng", "Order Cancellation Notice")} #{order.OrderId}</h2>
                            <p>{Loc.T("Xin chào", "Hello")} <strong>{order.FullName}</strong>,</p>
                            <p>{Loc.T("Đơn hàng của bạn đã được hủy thành công theo yêu cầu.", "Your order has been successfully cancelled as requested.")}</p>
                            <p>{Loc.T("Nếu bạn đã thanh toán trước, chúng tôi sẽ tiến hành hoàn tiền theo chính sách của cửa hàng.", "If you paid in advance, we will process your refund according to our policy.")}</p>
                            {vnpayNote}
                            <br/>
                            <p>{Loc.T("Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ bộ phận hỗ trợ của chúng tôi.", "If you have any questions, please contact our support team.")}</p>
                            <p><strong>Hobby Shop Team</strong></p>
                        ";
                        await Helpers.EmailHelper.SendEmailAsync(_configuration, order.Account.Email, Loc.T("Hủy đơn hàng", "Order Cancelled") + $" #{order.OrderId}", bodyHtml);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Error sending cancellation email: " + ex.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["error"] = Loc.T("Đã xảy ra lỗi khi hủy đơn hàng: ", "Error cancelling order: ") + ex.Message;
            }

            return RedirectToAction("Details", new { id = order.OrderId });
        }
    }
}
