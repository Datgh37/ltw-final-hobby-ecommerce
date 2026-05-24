using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class CheckOutController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;

        public CheckOutController(EcommerceHobbyShopContext context)
        {
            _context = context;
        }

        // =====================================
        // HELPER: LẤY HOẶC TẠO CART ID
        // =====================================
        private string GetOrCreateCartId()
        {
            // USER LOGIN
            if (User.Identity?.IsAuthenticated == true)
            {
                var accountId = User.FindFirst("AccountId")?.Value;

                var userCart = _context.Carts
                    .FirstOrDefault(c => c.AccountId == accountId);

                if (userCart != null)
                    return userCart.CartId;

                // Tạo cart mới
                string newCartId = Guid.NewGuid().ToString();

                var cart = new Cart
                {
                    CartId = newCartId,
                    AccountId = accountId
                };

                _context.Carts.Add(cart);
                _context.SaveChanges();

                return newCartId;
            }

            // GUEST
            if (Request.Cookies.TryGetValue("GuestCartId", out string cartId))
            {
                var existingCart = _context.Carts
                    .FirstOrDefault(c => c.CartId == cartId);

                if (existingCart != null)
                    return cartId;
            }

            // TẠO CART GUEST MỚI
            string freshCartId = Guid.NewGuid().ToString();

            var guestCart = new Cart
            {
                CartId = freshCartId,
                AccountId = null
            };

            _context.Carts.Add(guestCart);
            _context.SaveChanges();

            Response.Cookies.Append("GuestCartId", freshCartId, new CookieOptions
            {
                Expires = DateTime.Now.AddDays(30),
                HttpOnly = true,
                IsEssential = true,
                Path = "/"
            });

            return freshCartId;
        }

        // =====================================
        // GET: CHECKOUT PAGE
        // =====================================
        [HttpGet]
        public IActionResult Index()
        {
            var cartId = GetOrCreateCartId();

            var cart = _context.Carts
                .Include(c => c.CartItems)
                .ThenInclude(ci => ci.Product)
                .FirstOrDefault(c => c.CartId == cartId);

            decimal subtotal = cart.CartItems
                .Sum(x => x.Product.UnitPrice * x.Quantity);

            decimal discount = 0;
            if (!string.IsNullOrEmpty(HttpContext.Session.GetString("DiscountAmount")))
            {
                discount = Convert.ToDecimal(HttpContext.Session.GetString("DiscountAmount"));
            }
            ViewBag.DiscountText =  HttpContext.Session.GetString("DiscountText");
            var summary = new CartSummaryViewModel
            {
                Subtotal = subtotal,
                DiscountAmount = discount,
                FinalTotal = subtotal - discount,
                VoucherCode = HttpContext.Session.GetString("VoucherCode")
            };

            if (cart == null || !cart.CartItems.Any())
            {
                TempData["error"] = "Giỏ hàng đang trống!";
                return RedirectToAction("Index", "Cart");
            }

            var vm = new CheckoutPageViewModel
            {
                Cart = cart,
                Checkout = new CheckOutViewModel(),
                Summary = summary
            };

            return View(vm);
        }

        // =====================================
        // POST: PLACE ORDER
        // =====================================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult PlaceOrder(CheckoutPageViewModel vm)
        {
            // LOAD CART
            var cartId = GetOrCreateCartId();

            var cart = _context.Carts
                .Include(c => c.CartItems)
                .ThenInclude(ci => ci.Product)
                .FirstOrDefault(c => c.CartId == cartId);

            // GÁN LẠI CART CHO VIEWMODEL
            vm.Cart = cart;

            // CHECK CART
            if (cart == null || !cart.CartItems.Any())
            {
                TempData["error"] = "Giỏ hàng đang trống!";
                return RedirectToAction("Index", "Cart");
            }

            // VALIDATION FAIL
            if (!ModelState.IsValid)
            {
                decimal subtotal = cart.CartItems.Sum(x => x.Product.UnitPrice * x.Quantity);

                decimal discount = 0;

                if (!string.IsNullOrEmpty(HttpContext.Session.GetString("DiscountAmount")))
                {
                    discount = Convert.ToDecimal(HttpContext.Session.GetString("DiscountAmount"));
                }
                vm.Summary = new CartSummaryViewModel
                {
                    Subtotal = subtotal,
                    DiscountAmount = discount,
                    FinalTotal = subtotal - discount,
                    VoucherCode = HttpContext.Session.GetString("VoucherCode")
                };

                return View("Index", vm);
            }

            // CHECK STOCK
            foreach (var item in cart.CartItems)
            {
                var product = _context.Products
                    .FirstOrDefault(p => p.ProductId == item.ProductId);

                if (product == null)
                {
                    TempData["error"] =
                        $"Không tìm thấy sản phẩm {item.Product.ProductName}";

                    return RedirectToAction("Index", "Cart");
                }

                if (product.StockQuantity < item.Quantity)
                {
                    TempData["error"] =
                        $"Sản phẩm {item.Product.ProductName} không đủ hàng!";

                    return RedirectToAction("Index", "Cart");
                }
            }

            // TÍNH TỔNG TIỀN
            decimal total = cart.CartItems.Sum(x =>
                x.Product.UnitPrice * x.Quantity
            );

            //// TẠO ORDER
            //var order = new Order
            //{
            //    AccountId = User.Identity?.IsAuthenticated == true
            //        ? User.FindFirst("AccountId")?.Value
            //        : null,

            //    OrderDate = DateTime.Now,
            //    FullName = vm.Checkout.FullName,
            //    Address = vm.Checkout.Address,
            //    PhoneNumber = vm.Checkout.Phone,
            //    PaymentMethod = vm.Checkout.PaymentMethod,
            //    //ShippingFee = vm.Checkout.ShippingFee,
            //    VoucherCode = vm.Checkout.VoucherCode,
            //    TrackingNumber = null,
            //    // PENDING
            //    StatusId = 1
            //};

            //_context.Orders.Add(order);

            //_context.SaveChanges();

            //// ORDER DETAILS + TRỪ KHO
            //foreach (var item in cart.CartItems)
            //{
            //    var detail = new OrderDetail
            //    {
            //        OrderId = order.OrderId,

            //        ProductId = item.ProductId,

            //        Quantity = item.Quantity,

            //        UnitPrice = item.Product.UnitPrice
            //    };

            //    _context.OrderDetails.Add(detail);

            //    // TRỪ KHO
            //    item.Product.StockQuantity -= item.Quantity;
            //}

            //// XOÁ CART ITEMS
            //_context.CartItems.RemoveRange(cart.CartItems);

            //_context.SaveChanges();

            //// SUCCESS
            //return RedirectToAction(
            //    "Success",
            //    new { id = order.OrderId }
            //);
                

            TempData["Success"] ="Đặt hàng thành công (Demo)";

            // clear voucher
            HttpContext.Session.Remove("VoucherCode");

            HttpContext.Session.Remove("DiscountAmount");

            return RedirectToAction("Success");

        }

        // =====================================
        // SUCCESS PAGE
        // =====================================
        [HttpGet]
        public IActionResult Success(int id)
        {
            var order = _context.Orders
                .FirstOrDefault(o => o.OrderId == id);

            if (order == null)
            {
                return RedirectToAction("Index", "Home");
            }

            return View(order);
        }
    }
}