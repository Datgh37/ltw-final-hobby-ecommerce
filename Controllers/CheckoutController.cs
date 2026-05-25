using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;
using TuNhanTamTInh_Ecommerce.Helpers;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    [Authorize]
    public class CheckOutController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;
        private readonly IConfiguration _configuration;

        public CheckOutController(EcommerceHobbyShopContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        // =====================================
        // GET: CHECKOUT PAGE
        // =====================================
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            if (string.IsNullOrEmpty(accountId)) return RedirectToAction("Login", "Account");

            var cart = await _context.Carts
                .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.Product)
                        .ThenInclude(p => p.ProductImages)
                .FirstOrDefaultAsync(c => c.AccountId == accountId);

            if (cart == null || !cart.CartItems.Any())
            {
                TempData["error"] = "Giỏ hàng đang trống!";
                return RedirectToAction("Index", "Cart");
            }

            var account = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == accountId);

            decimal subtotal = cart.CartItems.Sum(x => x.Product.UnitPrice * x.Quantity);
            decimal discount = 0;
            string? sessionDiscount = HttpContext.Session.GetString("DiscountAmount");
            if (!string.IsNullOrEmpty(sessionDiscount))
            {
                discount = Convert.ToDecimal(sessionDiscount);
            }

            var summary = new CartSummaryViewModel
            {
                Subtotal = subtotal,
                DiscountAmount = discount,
                FinalTotal = subtotal - discount,
                VoucherCode = HttpContext.Session.GetString("VoucherCode")
            };
            ViewBag.DiscountText = HttpContext.Session.GetString("DiscountText");

            var checkoutVm = new CheckOutViewModel
            {
                FullName = account?.FullName ?? "",
                Email = account?.Email,
                Phone = account?.PhoneNumber ?? "",
                Address = account?.Address ?? "",
                VoucherCode = summary.VoucherCode
            };

            var vm = new CheckoutPageViewModel
            {
                Cart = cart,
                Checkout = checkoutVm,
                Summary = summary
            };

            return View(vm);
        }

        // =====================================
        // POST: PLACE ORDER
        // =====================================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PlaceOrder(CheckoutPageViewModel vm)
        {
            var accountId = User.FindFirst("AccountId")?.Value;
            if (string.IsNullOrEmpty(accountId)) return RedirectToAction("Login", "Account");

            var cart = await _context.Carts
                .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.Product)
                        .ThenInclude(p => p.ProductImages)
                .FirstOrDefaultAsync(c => c.AccountId == accountId);

            vm.Cart = cart ?? new Cart();

            if (cart == null || !cart.CartItems.Any())
            {
                TempData["error"] = Loc.T("Giỏ hàng đang trống!", "Your cart is empty!");
                return RedirectToAction("Index", "Cart");
            }

            // CHECK CONCURRENCY (Giỏ hàng có bị thay đổi ở tab khác không?)
            decimal actualSubtotal = cart.CartItems.Sum(x => x.Product.UnitPrice * x.Quantity);
            if (actualSubtotal != vm.Checkout.ExpectedSubtotal)
            {
                TempData["error"] = Loc.T("Giỏ hàng đã thay đổi (thêm/bớt sản phẩm ở nơi khác). Vui lòng kiểm tra và đặt hàng lại!", "Your cart has changed (items added/removed elsewhere). Please review and place your order again!");
                return RedirectToAction("Index", "Cart");
            }

            if (!ModelState.IsValid)
            {
                decimal subtotal = cart.CartItems.Sum(x => x.Product.UnitPrice * x.Quantity);
                decimal discount = 0;
                string? sessionDiscount = HttpContext.Session.GetString("DiscountAmount");
                if (!string.IsNullOrEmpty(sessionDiscount))
                {
                    discount = Convert.ToDecimal(sessionDiscount);
                }

                vm.Summary = new CartSummaryViewModel
                {
                    Subtotal = subtotal,
                    DiscountAmount = discount,
                    FinalTotal = subtotal - discount,
                    VoucherCode = HttpContext.Session.GetString("VoucherCode")
                };
                ViewBag.DiscountText = HttpContext.Session.GetString("DiscountText");

                // Giữ lại Email readonly từ DB
                var acc = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == accountId);
                vm.Checkout.Email = acc?.Email;

                return View("Index", vm);
            }

            // SMART SAVE-BACK: Cập nhật Profile nếu còn trống
            var account = await _context.Accounts.FirstOrDefaultAsync(a => a.AccountId == accountId);
            if (account != null)
            {
                bool isUpdated = false;
                if (string.IsNullOrEmpty(account.PhoneNumber) && !string.IsNullOrEmpty(vm.Checkout.Phone))
                {
                    account.PhoneNumber = vm.Checkout.Phone;
                    isUpdated = true;
                }
                if (string.IsNullOrEmpty(account.Address) && !string.IsNullOrEmpty(vm.Checkout.Address))
                {
                    account.Address = vm.Checkout.Address;
                    isUpdated = true;
                }

                if (isUpdated)
                {
                    _context.Update(account);
                    await _context.SaveChangesAsync();
                }
            }

            // CHECK STOCK
            foreach (var item in cart.CartItems)
            {
                if (item.Product.StockQuantity < item.Quantity)
                {
                    TempData["error"] = $"Sản phẩm {item.Product.ProductName} không đủ hàng!";
                    return RedirectToAction("Index", "Cart");
                }
            }
            // CHECK VOUCHER VALIDITY & LIMIT
            string? sessionVoucherCode = HttpContext.Session.GetString("VoucherCode");
            Voucher? appliedVoucher = null;

            if (!string.IsNullOrEmpty(sessionVoucherCode))
            {
                appliedVoucher = await _context.Vouchers.FirstOrDefaultAsync(v => v.VoucherCode == sessionVoucherCode && v.IsActive);
                
                if (appliedVoucher == null || (appliedVoucher.ExpiryDate.HasValue && appliedVoucher.ExpiryDate.Value < DateTime.Now))
                {
                    TempData["error"] = Loc.T("Voucher không hợp lệ hoặc đã hết hạn. Vui lòng đặt hàng lại.", "Invalid or expired voucher. Please order again.");
                    HttpContext.Session.Remove("VoucherCode");
                    HttpContext.Session.Remove("DiscountAmount");
                    HttpContext.Session.Remove("DiscountText");
                    return RedirectToAction("Index", "Cart");
                }

                if (appliedVoucher.UsageLimit.HasValue && appliedVoucher.UsedCount >= appliedVoucher.UsageLimit.Value)
                {
                    TempData["error"] = Loc.T("Mã giảm giá này đã hết lượt sử dụng. Vui lòng đặt hàng lại.", "This voucher has reached its usage limit. Please order again.");
                    HttpContext.Session.Remove("VoucherCode");
                    HttpContext.Session.Remove("DiscountAmount");
                    HttpContext.Session.Remove("DiscountText");
                    return RedirectToAction("Index", "Cart");
                }
            }

            // TẠO ORDER
            var order = new Order
            {
                AccountId = accountId,
                OrderDate = DateTime.Now,
                FullName = vm.Checkout.FullName,
                Address = vm.Checkout.Address,
                PhoneNumber = vm.Checkout.Phone,
                PaymentMethod = vm.Checkout.PaymentMethod,
                ShippingFee = 0,
                VoucherCode = HttpContext.Session.GetString("VoucherCode"),
                StatusId = 0, // Chờ xử lý
                IsPaid = false
            };
            
            _context.Orders.Add(order);
            await _context.SaveChangesAsync(); // Sinh ra OrderId

            // TẠO ORDER DETAILS & TRỪ TỒN KHO
            foreach (var item in cart.CartItems)
            {
                var orderDetail = new OrderDetail
                {
                    OrderId = order.OrderId,
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    UnitPrice = item.Product.UnitPrice,
                    Discount = item.Product.Discount
                };
                _context.OrderDetails.Add(orderDetail);

                item.Product.StockQuantity -= item.Quantity;
                if (item.Product.StockQuantity < 0) item.Product.StockQuantity = 0;
            }

            // CẬP NHẬT LƯỢT SỬ DỤNG VOUCHER
            if (appliedVoucher != null)
            {
                appliedVoucher.UsedCount++;
                _context.Update(appliedVoucher);
            }

            // CHUẨN BỊ DỮ LIỆU EMAIL TRƯỚC KHI XÓA GIỎ HÀNG
            decimal emailSubtotal = 0;
            decimal emailDiscount = 0;
            decimal emailTotal = 0;
            string itemsHtml = "";

            if (!string.IsNullOrEmpty(account?.Email))
            {
                emailSubtotal = cart.CartItems.Sum(x => x.Product.UnitPrice * x.Quantity);
                emailDiscount = Convert.ToDecimal(HttpContext.Session.GetString("DiscountAmount") ?? "0");
                emailTotal = emailSubtotal - emailDiscount;

                itemsHtml = string.Join("", cart.CartItems.Select(item =>
                    $@"<tr>
                        <td style='padding: 8px; border: 1px solid #ddd;'>{item.Product.ProductName}</td>
                        <td style='padding: 8px; border: 1px solid #ddd; text-align: center;'>{item.Quantity}</td>
                        <td style='padding: 8px; border: 1px solid #ddd; text-align: right;'>{item.Product.UnitPrice:N0} đ</td>
                        <td style='padding: 8px; border: 1px solid #ddd; text-align: right;'>{(item.Product.UnitPrice * item.Quantity):N0} đ</td>
                    </tr>"
                ));
            }

            // XÓA GIỎ HÀNG
            _context.CartItems.RemoveRange(cart.CartItems);

            await _context.SaveChangesAsync();

            TempData["Success"] = Loc.T("Đặt hàng thành công! Đơn hàng của bạn đang được xử lý.", "Order placed successfully! Your order is being processed.");

            // SEND EMAIL CONFIRMATION
            if (!string.IsNullOrEmpty(account?.Email))
            {
                try
                {
                    string bodyHtml = $@"
                        <h2>{Loc.T("Xác nhận đơn hàng", "Order Confirmation")} #{order.OrderId}</h2>
                        <p>{Loc.T("Xin chào", "Hello")} <strong>{order.FullName}</strong>,</p>
                        <p>{Loc.T("Cảm ơn bạn đã đặt hàng tại Hobby Shop. Đơn hàng của bạn đang được xử lý.", "Thank you for shopping at Hobby Shop. Your order is being processed.")}</p>
                        <h3>{Loc.T("Chi tiết đơn hàng", "Order Details")}</h3>
                        <table style='width: 100%; border-collapse: collapse;'>
                            <thead>
                                <tr style='background-color: #f2f2f2;'>
                                    <th style='padding: 8px; border: 1px solid #ddd;'>{Loc.T("Sản phẩm", "Product")}</th>
                                    <th style='padding: 8px; border: 1px solid #ddd;'>{Loc.T("Số lượng", "Quantity")}</th>
                                    <th style='padding: 8px; border: 1px solid #ddd;'>{Loc.T("Đơn giá", "Unit Price")}</th>
                                    <th style='padding: 8px; border: 1px solid #ddd;'>{Loc.T("Thành tiền", "Total")}</th>
                                </tr>
                            </thead>
                            <tbody>
                                {itemsHtml}
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan='3' style='padding: 8px; border: 1px solid #ddd; text-align: right; font-weight: bold;'>{Loc.T("Tổng tạm tính", "Subtotal")}:</td>
                                    <td style='padding: 8px; border: 1px solid #ddd; text-align: right;'>{emailSubtotal:N0} đ</td>
                                </tr>
                                <tr>
                                    <td colspan='3' style='padding: 8px; border: 1px solid #ddd; text-align: right; font-weight: bold;'>{Loc.T("Giảm giá", "Discount")}:</td>
                                    <td style='padding: 8px; border: 1px solid #ddd; text-align: right; color: green;'>-{emailDiscount:N0} đ</td>
                                </tr>
                                <tr>
                                    <td colspan='3' style='padding: 8px; border: 1px solid #ddd; text-align: right; font-weight: bold;'>{Loc.T("Tổng cộng", "Grand Total")}:</td>
                                    <td style='padding: 8px; border: 1px solid #ddd; text-align: right; font-weight: bold; color: red;'>{emailTotal:N0} đ</td>
                                </tr>
                            </tfoot>
                        </table>
                        <br/>
                        <p><strong>{Loc.T("Phương thức thanh toán", "Payment Method")}:</strong> {(order.PaymentMethod == "COD" ? Loc.T("Thanh toán khi nhận hàng", "Cash on Delivery") : Loc.T("Thanh toán trực tuyến", "Online Payment"))}</p>
                        <p><strong>{Loc.T("Trạng thái thanh toán", "Payment Status")}:</strong> {(order.IsPaid ? Loc.T("Đã thanh toán", "Paid") : Loc.T("Chưa thanh toán", "Unpaid"))}</p>
                        <p><strong>{Loc.T("Địa chỉ giao hàng", "Shipping Address")}:</strong> {order.Address}</p>
                        <p><strong>{Loc.T("Số điện thoại", "Phone")}:</strong> {order.PhoneNumber}</p>
                        <br/>
                        <p>{Loc.T("Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ bộ phận hỗ trợ của chúng tôi.", "If you have any questions, please contact our support team.")}</p>
                        <p><strong>Hobby Shop Team</strong></p>
                    ";

                    await EmailHelper.SendEmailAsync(_configuration, account.Email, Loc.T("Xác nhận đơn hàng", "Order Confirmation") + $" #{order.OrderId}", bodyHtml);
                }
                catch (Exception ex)
                {
                    // Log error if needed, but do not block the checkout flow
                    Console.WriteLine("Error sending email: " + ex.Message);
                }
            }

            HttpContext.Session.Remove("VoucherCode");
            HttpContext.Session.Remove("DiscountAmount");
            HttpContext.Session.Remove("DiscountText");

            return RedirectToAction("History", "Orders");
        }

        // =====================================
        // SUCCESS PAGE
        // =====================================
        [HttpGet]
        public IActionResult Success(int id)
        {
            // Dummy success view
            return View();
        }
    }
}