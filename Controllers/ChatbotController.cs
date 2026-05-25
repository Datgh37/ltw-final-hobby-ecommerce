using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TuNhanTamTInh_Ecommerce.Data;
using TuNhanTamTInh_Ecommerce.Models;
using TuNhanTamTInh_Ecommerce.Models.ViewModels;

namespace TuNhanTamTInh_Ecommerce.Controllers
{
    public class ChatbotController : Controller
    {
        private readonly EcommerceHobbyShopContext _context;
        private readonly IConfiguration _configuration;
        private static readonly HttpClient _httpClient = new HttpClient();

        // Bộ nhớ đệm tĩnh (Static In-Memory Cache) cho các thống kê nặng của cửa hàng cho cả VI và EN
        private static string? _cachedStoreInfoVi;
        private static string? _cachedStoreInfoEn;
        private static DateTime _cacheExpiration = DateTime.MinValue;
        private static readonly object CacheLock = new object();
        private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(10); // Hết hạn sau 10 phút

        public ChatbotController(EcommerceHobbyShopContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        /// <summary>
        /// Phương thức hỗ trợ lấy dữ liệu thống kê tổng quan (Sử dụng Cache để tránh tải DB)
        /// </summary>
        private async Task<string> GetOrUpdateStoreInfoCacheAsync(bool isEnglish)
        {
            // Kiểm tra nhanh (Double-checked locking pattern)
            string? cachedValue = isEnglish ? _cachedStoreInfoEn : _cachedStoreInfoVi;
            if (cachedValue != null && DateTime.Now < _cacheExpiration)
            {
                return cachedValue;
            }

            // Chờ cập nhật nếu đã hết hạn
            var storeInfo = "";
            bool needUpdate = false;

            lock (CacheLock)
            {
                cachedValue = isEnglish ? _cachedStoreInfoEn : _cachedStoreInfoVi;
                if (cachedValue == null || DateTime.Now >= _cacheExpiration)
                {
                    needUpdate = true;
                }
                else
                {
                    storeInfo = cachedValue;
                }
            }

            if (needUpdate)
            {
                // Thực hiện 12 truy vấn nặng một lần duy nhất mỗi 10 phút
                int totalProducts = await _context.Products.CountAsync();
                int totalInStock = await _context.Products.CountAsync(p => p.StockQuantity > 0);
                int totalOutOfStock = await _context.Products.CountAsync(p => p.StockQuantity <= 0);
                int totalDiscounted = await _context.Products.CountAsync(p => p.Discount > 0);

                var categoryStats = await _context.Categories
                    .Select(c => new { c.CategoryName, c.CategoryNameEn, ProductCount = c.Products.Count })
                    .ToListAsync();
                
                string categoryInfo = isEnglish
                    ? string.Join("\n", categoryStats.Select(c => $"  - {(!string.IsNullOrEmpty(c.CategoryNameEn) ? c.CategoryNameEn : c.CategoryName)}: {c.ProductCount} products"))
                    : string.Join("\n", categoryStats.Select(c => $"  - {c.CategoryName}: {c.ProductCount} sản phẩm"));

                var seriesStats = await _context.Series
                    .Where(s => s.SeriesName != null)
                    .Select(s => new { s.SeriesName, ProductCount = s.Products.Count })
                    .ToListAsync();
                
                string seriesInfo = isEnglish
                    ? string.Join("\n", seriesStats.Select(s => $"  - {s.SeriesName}: {s.ProductCount} products"))
                    : string.Join("\n", seriesStats.Select(s => $"  - {s.SeriesName}: {s.ProductCount} sản phẩm"));

                var supplierStats = await _context.Suppliers
                    .Select(s => new { s.CompanyName, ProductCount = s.Products.Count })
                    .ToListAsync();
                
                string supplierInfo = isEnglish
                    ? string.Join("\n", supplierStats.Select(s => $"  - {s.CompanyName}: {s.ProductCount} products"))
                    : string.Join("\n", supplierStats.Select(s => $"  - {s.CompanyName}: {s.ProductCount} sản phẩm"));

                var priceMin = await _context.Products.AnyAsync() ? await _context.Products.MinAsync(p => p.UnitPrice) : 0m;
                var priceMax = await _context.Products.AnyAsync() ? await _context.Products.MaxAsync(p => p.UnitPrice) : 0m;

                var activeVouchers = await _context.Vouchers
                    .Where(v => v.IsActive && (v.ExpiryDate == null || v.ExpiryDate > DateTime.Now))
                    .Select(v => new {
                        v.VoucherCode,
                        v.DiscountPercent,
                        v.DiscountAmount,
                        v.ExpiryDate
                    })
                    .ToListAsync();
                
                string voucherInfo;
                if (isEnglish)
                {
                    voucherInfo = activeVouchers.Any()
                        ? string.Join("\n", activeVouchers.Select(v =>
                            $"  - Code: {v.VoucherCode} | " +
                            (v.DiscountPercent.HasValue ? $"Off {v.DiscountPercent}%" : $"Off {v.DiscountAmount:N0}đ") +
                            (v.ExpiryDate.HasValue ? $" | Expiry: {v.ExpiryDate:dd/MM/yyyy}" : "")))
                        : "  - No active discount codes currently.";
                }
                else
                {
                    voucherInfo = activeVouchers.Any()
                        ? string.Join("\n", activeVouchers.Select(v =>
                            $"  - Mã: {v.VoucherCode} | " +
                            (v.DiscountPercent.HasValue ? $"Giảm {v.DiscountPercent}%" : $"Giảm {v.DiscountAmount:N0}đ") +
                            (v.ExpiryDate.HasValue ? $" | HSD: {v.ExpiryDate:dd/MM/yyyy}" : "")))
                        : "  - Hiện tại không có mã giảm giá nào đang hoạt động.";
                }

                var orderStatuses = await _context.Statuses
                    .OrderBy(s => s.StatusId)
                    .Select(s => new { s.StatusName, s.StatusNameEn })
                    .ToListAsync();
                
                string orderStatusFlow;
                if (isEnglish)
                {
                    orderStatusFlow = string.Join(" → ", orderStatuses.Select(s => !string.IsNullOrEmpty(s.StatusNameEn) ? s.StatusNameEn : s.StatusName));
                }
                else
                {
                    orderStatusFlow = string.Join(" → ", orderStatuses.Select(s => s.StatusName));
                }

                var topViewed = await _context.Products
                    .AsNoTracking()
                    .OrderByDescending(p => p.ViewCount)
                    .Take(5)
                    .Select(p => new { p.ProductName, p.ProductNameEn, p.ViewCount, p.UnitPrice, p.Discount })
                    .ToListAsync();
                
                string topViewedInfo;
                if (isEnglish)
                {
                    topViewedInfo = string.Join("\n", topViewed.Select(p =>
                        $"  - {(!string.IsNullOrEmpty(p.ProductNameEn) ? p.ProductNameEn : p.ProductName)} ({p.ViewCount} views, price {(p.Discount > 0 ? (p.UnitPrice * (1 - (decimal)p.Discount)).ToString("N0") : p.UnitPrice.ToString("N0"))}đ)"));
                }
                else
                {
                    topViewedInfo = string.Join("\n", topViewed.Select(p =>
                        $"  - {p.ProductName} ({p.ViewCount} lượt xem, giá {(p.Discount > 0 ? (p.UnitPrice * (1 - (decimal)p.Discount)).ToString("N0") : p.UnitPrice.ToString("N0"))}đ)"));
                }

                var topDiscounted = await _context.Products
                    .AsNoTracking()
                    .Where(p => p.Discount > 0)
                    .OrderByDescending(p => p.Discount)
                    .Take(5)
                    .Select(p => new { p.ProductName, p.ProductNameEn, p.UnitPrice, p.Discount })
                    .ToListAsync();
                
                string topDiscountedInfo;
                if (isEnglish)
                {
                    topDiscountedInfo = topDiscounted.Any()
                        ? string.Join("\n", topDiscounted.Select(p =>
                            $"  - {(!string.IsNullOrEmpty(p.ProductNameEn) ? p.ProductNameEn : p.ProductName)} (discount {p.Discount * 100}%, price {(p.UnitPrice * (1 - (decimal)p.Discount)).ToString("N0")}đ)"))
                        : "  - No products currently discounted.";
                }
                else
                {
                    topDiscountedInfo = topDiscounted.Any()
                        ? string.Join("\n", topDiscounted.Select(p =>
                            $"  - {p.ProductName} (giảm {p.Discount * 100}%, giá còn {(p.UnitPrice * (1 - (decimal)p.Discount)).ToString("N0")}đ)"))
                        : "  - Hiện tại không có sản phẩm nào đang giảm giá.";
                }

                var newest = await _context.Products
                    .AsNoTracking()
                    .OrderByDescending(p => p.CreatedAt)
                    .Take(5)
                    .Select(p => new { p.ProductName, p.ProductNameEn, p.UnitPrice, p.CreatedAt })
                    .ToListAsync();
                
                string newestInfo;
                if (isEnglish)
                {
                    newestInfo = string.Join("\n", newest.Select(p =>
                        $"  - {(!string.IsNullOrEmpty(p.ProductNameEn) ? p.ProductNameEn : p.ProductName)} (price {p.UnitPrice:N0}đ, arrived {p.CreatedAt:dd/MM/yyyy})"));
                }
                else
                {
                    newestInfo = string.Join("\n", newest.Select(p =>
                        $"  - {p.ProductName} (giá {p.UnitPrice:N0}đ, về ngày {p.CreatedAt:dd/MM/yyyy})"));
                }

                if (isEnglish)
                {
                    storeInfo = $@"=== STORE INFORMATION ===
- Name: Trinity Hobby Shop
- Specializes in: Assembly Models (Gunpla/Gundam), Figure, Model Kits of all kinds
- Address: 206 Nguyen Khuyen, Ward 5, Trang Dai Ward, Bien Hoa City, Dong Nai
- Hotline: +84 912 202 605 (24/7 support)
- Email: hello@nhom4.com
- Development Team: Tu Nhan Tam Tinh Group

=== GENERAL STATISTICS ===
- Total Products: {totalProducts} items
- In Stock: {totalInStock} | Out of Stock: {totalOutOfStock}
- Currently Discounted: {totalDiscounted} products
- Price Range: from {priceMin:N0}đ to {priceMax:N0}đ

=== PRODUCT CATEGORIES (with quantity) ===
{categoryInfo}

=== MODEL SERIES (with quantity) ===
{seriesInfo}

=== BRANDS / SUPPLIERS ===
{supplierInfo}

=== ACTIVE VOUCHERS / DISCOUNT CODES ===
{voucherInfo}

=== TOP 5 MOST VIEWED PRODUCTS ===
{topViewedInfo}

=== TOP 5 MOST DISCOUNTED PRODUCTS ===
{topDiscountedInfo}

=== TOP 5 NEWEST PRODUCTS ===
{newestInfo}

=== ORDER PROCESS ===
{orderStatusFlow}
- Supported Payment Methods: COD (Cash on Delivery)
- Shipping Fee: Depends on the order (usually 30,000đ for local delivery)

=== SHOP POLICIES ===
- Register/Login: An account is required to purchase, save favorites, and track orders. Register via email + OTP verification.
- Forgot Password: Recover via email OTP on the Forgot Password page.
- Favorites: Log in and click the heart on the product card to save it to your wishlist.
- Shopping Cart: Add products, adjust quantities, and delete products. Requires login.
- Search: Type keywords in the header search bar, live search results are supported.
- Product Filtering: Filter by category, series, price range, and sort by price/newest/views/ratings.";
                }
                else
                {
                    storeInfo = $@"=== THÔNG TIN CỬA HÀNG ===
- Tên: Trinity Hobby Shop
- Chuyên bán: Mô hình lắp ráp (Gunpla/Gundam), Figure, Model Kit các loại
- Địa chỉ: 206 Nguyễn Khuyến, Khu 5, Phường Trảng Dài, TP. Biên Hòa, Đồng Nai
- Hotline: +84 912 202 605 (hỗ trợ 24/7)
- Email: hello@nhom4.com
- Nhóm phát triển: Tứ Nhãn Tam Tinh

=== THỐNG KÊ TỔNG QUAN ===
- Tổng số sản phẩm: {totalProducts} mặt hàng
- Đang còn hàng: {totalInStock} | Hết hàng: {totalOutOfStock}
- Đang giảm giá: {totalDiscounted} sản phẩm
- Khoảng giá: từ {priceMin:N0}đ đến {priceMax:N0}đ

=== DANH MỤC SẢN PHẨM (kèm số lượng) ===
{categoryInfo}

=== DÒNG SERIES MÔ HÌNH (kèm số lượng) ===
{seriesInfo}

=== THƯƠNG HIỆU / NHÀ CUNG CẤP ===
{supplierInfo}

=== MÃ GIẢM GIÁ (VOUCHER) ĐANG HOẠT ĐỘNG ===
{voucherInfo}

=== TOP 5 SẢN PHẨM XEM NHIỀU NHẤT ===
{topViewedInfo}

=== TOP 5 SẢN PHẨM GIẢM GIÁ MẠNH NHẤT ===
{topDiscountedInfo}

=== TOP 5 SẢN PHẨM MỚI NHẤT ===
{newestInfo}

=== QUY TRÌNH ĐƠN HÀNG ===
{orderStatusFlow}
- Phương thức thanh toán hỗ trợ: COD (thanh toán khi nhận hàng)
- Phí ship: Tùy đơn hàng (thường 30.000đ nội thành)

=== CHÍNH SÁCH CỦA SHOP ===
- Đăng ký/Đăng nhập: Cần tài khoản để mua hàng, lưu yêu thích, theo dõi đơn. Đăng ký qua email + xác thực OTP.
- Quên mật khẩu: Khôi phục qua email OTP tại trang Quên mật khẩu.
- Yêu thích: Đăng nhập rồi bấm trái tim trên thẻ sản phẩm để lưu vào danh sách yêu thích.
- Giỏ hàng: Thêm sản phẩm, điều chỉnh số lượng, xóa sản phẩm. Cần đăng nhập.
- Tìm kiếm: Gõ từ khóa vào thanh tìm kiếm trên header, có hỗ trợ tìm kiếm trực tiếp (live search).
- Lọc sản phẩm: Lọc theo danh mục, series, khoảng giá, sắp xếp theo giá/mới nhất/xem nhiều/đánh giá.";
                }

                lock (CacheLock)
                {
                    if (isEnglish)
                    {
                        _cachedStoreInfoEn = storeInfo;
                    }
                    else
                    {
                        _cachedStoreInfoVi = storeInfo;
                    }
                    _cacheExpiration = DateTime.Now.Add(CacheDuration);
                }
            }

            return storeInfo;
        }

        [HttpPost]
        public async Task<IActionResult> Ask([FromBody] ChatbotRequest request)
        {
            var culture = System.Threading.Thread.CurrentThread.CurrentUICulture.Name;
            bool isEnglish = culture == "en-US";

            if (request == null || string.IsNullOrWhiteSpace(request.Message))
            {
                return Json(new { error = isEnglish ? "Message cannot be empty." : "Tin nhắn không được để trống." });
            }

            string userMessage = request.Message.Trim();

            try
            {
                // ================================================================
                // PHASE 1: LẤY THÔNG TIN TỔNG QUAN TỪ CACHE (Cực kỳ nhanh, 0 tốn tài nguyên DB)
                // ================================================================
                string cachedStoreInfo = await GetOrUpdateStoreInfoCacheAsync(isEnglish);

                // ================================================================
                // PHASE 2: TÌM KIẾM SẢN PHẨM CHI TIẾT THEO YÊU CẦU (Chỉ chạy khi có từ khóa)
                // ================================================================
                var matchedProducts = new List<ChatbotProductViewModel>();

                // Phân tích từ khóa để tìm sản phẩm
                bool isDiscountQuery = Regex.IsMatch(userMessage, @"(giảm giá|khuyến mãi|sale|giá rẻ|ưu đãi|giảm|khuyến|discount|promotion|cheap|off)", RegexOptions.IgnoreCase);
                bool isNewQuery = Regex.IsMatch(userMessage, @"(mới|hàng mới|mới về|new|mới nhất|latest|arrival)", RegexOptions.IgnoreCase);
                bool isHotQuery = Regex.IsMatch(userMessage, @"(bán chạy|hot|mua nhiều|nổi bật|xem nhiều|phổ biến|top|popular|views|best)", RegexOptions.IgnoreCase);
                bool isPriceQuery = Regex.IsMatch(userMessage, @"(giá|bao nhiêu|tiền|cost|price|rẻ|đắt|mắc|how much|expensive)", RegexOptions.IgnoreCase);

                // Tách từ khóa sản phẩm (loại bỏ các từ thông dụng vô nghĩa)
                string[] stopWords = { "mua", "bán", "cho", "xem", "tìm", "giá", "bao", "nhiêu", "cái", "con", 
                    "hình", "tại", "của", "này", "đang", "được", "không", "nào", "vậy", "nhé", "nhỉ",
                    "shop", "cửa", "hàng", "sản", "phẩm", "mặt", "hỏi", "muốn", "biết",
                    "thế", "thì", "còn", "hay", "hoặc", "với", "các", "những", "một", "trong", 
                    "trên", "dưới", "đây", "kia", "đấy", "rồi", "đã", "sẽ", "đều",
                    "buy", "sell", "show", "find", "how", "much", "want", "know", "the", "a", "an", "is", "are", "of", "to", "in", "on", "for", "with", "this", "that" };
                
                string[] keywords = userMessage.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                var parsedKeywords = new List<string>();
                foreach (var word in keywords)
                {
                    string cleaned = Regex.Replace(word, @"[^\w\d]", "").Trim().ToLower();
                    if (cleaned.Length > 1 && !stopWords.Contains(cleaned))
                    {
                        parsedKeywords.Add(cleaned);
                    }
                }

                // Cực kỳ tối ưu: Chỉ thực hiện truy vấn cơ sở dữ liệu nếu có từ khóa tìm kiếm cụ thể!
                if (parsedKeywords.Any() || isDiscountQuery || isNewQuery || isHotQuery)
                {
                    var query = _context.Products.AsNoTracking();

                    if (isDiscountQuery)
                    {
                        query = query.Where(p => p.Discount > 0);
                    }

                    if (parsedKeywords.Any())
                    {
                        var firstKeyword = parsedKeywords.First();
                        query = query.Where(p => p.ProductName.Contains(firstKeyword) 
                            || (p.ProductNameEn != null && p.ProductNameEn.Contains(firstKeyword))
                            || p.Category.CategoryName.Contains(firstKeyword) 
                            || (p.Category.CategoryNameEn != null && p.Category.CategoryNameEn.Contains(firstKeyword))
                            || (p.Series != null && p.Series.SeriesName.Contains(firstKeyword))
                            || p.Supplier.CompanyName.Contains(firstKeyword));
                        
                        foreach (var keyword in parsedKeywords.Skip(1))
                        {
                            string kw = keyword;
                            query = query.Where(p => p.ProductName.Contains(kw) 
                                || (p.ProductNameEn != null && p.ProductNameEn.Contains(kw))
                                || p.Category.CategoryName.Contains(kw) 
                                || (p.Category.CategoryNameEn != null && p.Category.CategoryNameEn.Contains(kw))
                                || (p.Series != null && p.Series.SeriesName.Contains(kw))
                                || p.Supplier.CompanyName.Contains(kw));
                        }
                    }

                    // Sắp xếp theo ý định người dùng
                    if (isNewQuery)
                        query = query.OrderByDescending(p => p.CreatedAt);
                    else if (isHotQuery)
                        query = query.OrderByDescending(p => p.ViewCount);
                    else if (isDiscountQuery)
                        query = query.OrderByDescending(p => p.Discount);
                    else if (isPriceQuery)
                        query = query.OrderBy(p => p.UnitPrice);
                    else
                        query = query.OrderByDescending(p => p.ViewCount);

                    var rawProducts = await query.Take(5).ToListAsync();
                    
                    matchedProducts = rawProducts.Select(x => new ChatbotProductViewModel
                    {
                        ProductId = x.ProductId,
                        ProductName = x.ProductName, // Tự động gọi dynamic getter đã cấu hình trong Product.cs
                        ProductSlug = x.ProductSlug ?? string.Empty,
                        UnitPrice = x.UnitPrice,
                        Discount = x.Discount,
                        FinalPrice = x.Discount > 0 ? x.UnitPrice * (1 - (decimal)x.Discount) : x.UnitPrice,
                        StockQuantity = x.StockQuantity,
                        PrimaryImageUrl = _context.ProductImages
                            .Where(pi => pi.ProductId == x.ProductId && pi.IsPrimary)
                            .Select(pi => pi.ImageUrl)
                            .FirstOrDefault() ?? "/images/product-default.png"
                    }).ToList();
                }

                // ================================================================
                // PHASE 3: XÂY DỰNG SYSTEM PROMPT
                // ================================================================
                var contextJson = matchedProducts.Any()
                    ? JsonSerializer.Serialize(matchedProducts.Select(p => isEnglish ? (object)new
                    {
                        p.ProductName,
                        OriginalPrice = p.UnitPrice.ToString("N0") + "đ",
                        SalePrice = p.FinalPrice.ToString("N0") + "đ",
                        Discount = (p.Discount * 100) + "%",
                        Stock = p.StockQuantity > 0 ? p.StockQuantity + " items" : "OUT OF STOCK"
                    } : new
                    {
                        p.ProductName,
                        GiaGoc = p.UnitPrice.ToString("N0") + "đ",
                        GiaBan = p.FinalPrice.ToString("N0") + "đ",
                        GiamGia = (p.Discount * 100) + "%",
                        TonKho = p.StockQuantity > 0 ? p.StockQuantity + " sản phẩm" : "HẾT HÀNG"
                    }))
                    : "[]";

                string systemPrompt = isEnglish
                    ? $@"{cachedStoreInfo}

=== MATCHED PRODUCTS FOR CURRENT INQUIRY ===
{contextJson}

=== RESPONSE RULES (MANDATORY COMPLIANCE) ===
1. Communicate in natural, friendly, and enthusiastic English, tailored to model kit collectors and hobby enthusiasts.
2. For statistic/overview questions → Use GENERAL STATISTICS to answer accurately.
3. For voucher/discount questions → Use ACTIVE VOUCHERS / DISCOUNT CODES to answer.
4. For order/shipping/payment questions → Use ORDER PROCESS + SHOP POLICIES.
5. For account/registration/login/forgot password questions → Use SHOP POLICIES.
6. For contact/address/hotline questions → Use STORE INFORMATION.
7. For specific product questions → Prioritize using MATCHED PRODUCTS. If empty, suggest from TOP products.
8. ABSOLUTELY DO NOT make up product names, prices, or specifications that are not present in the data above.
9. Present answers concisely using Markdown (bullet points, bold product names).
10. If there are products in the matched list, remind the customer to check the product cards shown below for detailed links."
                    : $@"{cachedStoreInfo}

=== SẢN PHẨM KHỚP VỚI CÂU HỎI HIỆN TẠI ===
{contextJson}

=== QUY TẮC TRẢ LỜI (BẮT BUỘC TUÂN THỦ) ===
1. Giao tiếp bằng tiếng Việt tự nhiên, thân thiện, dí dỏm phong cách dân chơi mô hình.
2. Với câu hỏi thống kê/tổng quan → Dùng THỐNG KÊ TỔNG QUAN để trả lời chính xác.
3. Với câu hỏi về voucher/mã giảm giá → Dùng MÃ GIẢM GIÁ để trả lời.
4. Với câu hỏi về đơn hàng/giao hàng/thanh toán → Dùng QUY TRÌNH ĐƠN HÀNG + CHÍNH SÁCH.
5. Với câu hỏi về tài khoản/đăng ký/đăng nhập/quên mật khẩu → Dùng CHÍNH SÁCH CỦA SHOP.
6. Với câu hỏi liên hệ/địa chỉ/hotline → Dùng THÔNG TIN CỬA HÀNG.
7. Với câu hỏi sản phẩm cụ thể → Ưu tiên dùng SẢN PHẨM KHỚP CÂU HỎI. Nếu rỗng, gợi ý từ TOP sản phẩm.
8. TUYỆT ĐỐI KHÔNG bịa đặt tên sản phẩm, giá tiền, thông số không có trong dữ liệu trên.
9. Trình bày ngắn gọn bằng Markdown (gạch đầu dòng, bôi đậm tên sản phẩm).
10. Nếu có sản phẩm trong danh sách khớp câu hỏi, nhắc khách xem thẻ sản phẩm bên dưới để click chi tiết.";

                // ================================================================
                // PHASE 4: GỌI GEMINI API
                // ================================================================
                string apiKey = _configuration["Gemini:ApiKey"] ?? "";
                string model = _configuration["Gemini:Model"] ?? "gemini-3.1-flash-lite";
                string apiUri = $"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={apiKey}";

                var requestBody = new
                {
                    contents = new[]
                    {
                        new { parts = new[] { new { text = userMessage } } }
                    },
                    systemInstruction = new
                    {
                        parts = new[] { new { text = systemPrompt } }
                    }
                };

                string jsonBody = JsonSerializer.Serialize(requestBody);
                var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                var apiResponse = await _httpClient.PostAsync(apiUri, content);
                if (!apiResponse.IsSuccessStatusCode)
                {
                    string errorContent = await apiResponse.Content.ReadAsStringAsync();
                    return Json(new { error = isEnglish ? "Error connecting to Gemini AI" : "Lỗi khi kết nối với Gemini AI", details = errorContent });
                }

                string responseString = await apiResponse.Content.ReadAsStringAsync();
                using var doc = JsonDocument.Parse(responseString);
                
                string replyText = doc.RootElement
                    .GetProperty("candidates")[0]
                    .GetProperty("content")
                    .GetProperty("parts")[0]
                    .GetProperty("text")
                    .GetString() ?? (isEnglish ? "Sorry, I had some trouble thinking of an answer." : "Xin lỗi bạn, tôi gặp chút trục trặc khi suy nghĩ câu trả lời.");

                return Json(new ChatbotResponse
                {
                    Reply = replyText,
                    Products = matchedProducts
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = isEnglish ? "A system error occurred" : "Đã xảy ra lỗi hệ thống", details = ex.Message });
            }
        }
    }
}
