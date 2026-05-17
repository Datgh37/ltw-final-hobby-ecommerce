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

        // Bộ nhớ đệm tĩnh (Static In-Memory Cache) cho các thống kê nặng của cửa hàng
        private static string? _cachedStoreInfo;
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
        private async Task<string> GetOrUpdateStoreInfoCacheAsync()
        {
            // Kiểm tra nhanh (Double-checked locking pattern)
            if (_cachedStoreInfo != null && DateTime.Now < _cacheExpiration)
            {
                return _cachedStoreInfo;
            }

            // Chờ cập nhật nếu đã hết hạn
            var storeInfo = "";
            bool needUpdate = false;

            lock (CacheLock)
            {
                if (_cachedStoreInfo == null || DateTime.Now >= _cacheExpiration)
                {
                    needUpdate = true;
                }
                else
                {
                    storeInfo = _cachedStoreInfo;
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
                    .Select(c => new { c.CategoryName, ProductCount = c.Products.Count })
                    .ToListAsync();
                string categoryInfo = string.Join("\n", categoryStats.Select(c => $"  - {c.CategoryName}: {c.ProductCount} sản phẩm"));

                var seriesStats = await _context.Series
                    .Where(s => s.SeriesName != null)
                    .Select(s => new { s.SeriesName, ProductCount = s.Products.Count })
                    .ToListAsync();
                string seriesInfo = string.Join("\n", seriesStats.Select(s => $"  - {s.SeriesName}: {s.ProductCount} sản phẩm"));

                var supplierStats = await _context.Suppliers
                    .Select(s => new { s.CompanyName, ProductCount = s.Products.Count })
                    .ToListAsync();
                string supplierInfo = string.Join("\n", supplierStats.Select(s => $"  - {s.CompanyName}: {s.ProductCount} sản phẩm"));

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
                string voucherInfo = activeVouchers.Any()
                    ? string.Join("\n", activeVouchers.Select(v =>
                        $"  - Mã: {v.VoucherCode} | " +
                        (v.DiscountPercent.HasValue ? $"Giảm {v.DiscountPercent}%" : $"Giảm {v.DiscountAmount:N0}đ") +
                        (v.ExpiryDate.HasValue ? $" | HSD: {v.ExpiryDate:dd/MM/yyyy}" : "")))
                    : "  - Hiện tại không có mã giảm giá nào đang hoạt động.";

                var orderStatuses = await _context.Statuses
                    .OrderBy(s => s.StatusId)
                    .Select(s => s.StatusName)
                    .ToListAsync();
                string orderStatusFlow = string.Join(" → ", orderStatuses);

                var topViewed = await _context.Products
                    .AsNoTracking()
                    .OrderByDescending(p => p.ViewCount)
                    .Take(5)
                    .Select(p => new { p.ProductName, p.ViewCount, p.UnitPrice, p.Discount })
                    .ToListAsync();
                string topViewedInfo = string.Join("\n", topViewed.Select(p =>
                    $"  - {p.ProductName} ({p.ViewCount} lượt xem, giá {(p.Discount > 0 ? (p.UnitPrice * (1 - (decimal)p.Discount)).ToString("N0") : p.UnitPrice.ToString("N0"))}đ)"));

                var topDiscounted = await _context.Products
                    .AsNoTracking()
                    .Where(p => p.Discount > 0)
                    .OrderByDescending(p => p.Discount)
                    .Take(5)
                    .Select(p => new { p.ProductName, p.UnitPrice, p.Discount })
                    .ToListAsync();
                string topDiscountedInfo = topDiscounted.Any()
                    ? string.Join("\n", topDiscounted.Select(p =>
                        $"  - {p.ProductName} (giảm {p.Discount * 100}%, giá còn {(p.UnitPrice * (1 - (decimal)p.Discount)).ToString("N0")}đ)"))
                    : "  - Hiện tại không có sản phẩm nào đang giảm giá.";

                var newest = await _context.Products
                    .AsNoTracking()
                    .OrderByDescending(p => p.CreatedAt)
                    .Take(5)
                    .Select(p => new { p.ProductName, p.UnitPrice, p.CreatedAt })
                    .ToListAsync();
                string newestInfo = string.Join("\n", newest.Select(p =>
                    $"  - {p.ProductName} (giá {p.UnitPrice:N0}đ, về ngày {p.CreatedAt:dd/MM/yyyy})"));

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

                lock (CacheLock)
                {
                    _cachedStoreInfo = storeInfo;
                    _cacheExpiration = DateTime.Now.Add(CacheDuration);
                }
            }

            return storeInfo;
        }

        [HttpPost]
        public async Task<IActionResult> Ask([FromBody] ChatbotRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Message))
            {
                return Json(new { error = "Tin nhắn không được để trống." });
            }

            string userMessage = request.Message.Trim();

            try
            {
                // ================================================================
                // PHASE 1: LẤY THÔNG TIN TỔNG QUAN TỪ CACHE (Cực kỳ nhanh, 0 tốn tài nguyên DB)
                // ================================================================
                string cachedStoreInfo = await GetOrUpdateStoreInfoCacheAsync();

                // ================================================================
                // PHASE 2: TÌM KIẾM SẢN PHẨM CHI TIẾT THEO YÊU CẦU (Chỉ chạy khi có từ khóa)
                // ================================================================
                var matchedProducts = new List<ChatbotProductViewModel>();

                // Phân tích từ khóa để tìm sản phẩm
                bool isDiscountQuery = Regex.IsMatch(userMessage, @"(giảm giá|khuyến mãi|sale|giá rẻ|ưu đãi|giảm|khuyến)", RegexOptions.IgnoreCase);
                bool isNewQuery = Regex.IsMatch(userMessage, @"(mới|hàng mới|mới về|new|mới nhất)", RegexOptions.IgnoreCase);
                bool isHotQuery = Regex.IsMatch(userMessage, @"(bán chạy|hot|mua nhiều|nổi bật|xem nhiều|phổ biến|top)", RegexOptions.IgnoreCase);
                bool isPriceQuery = Regex.IsMatch(userMessage, @"(giá|bao nhiêu|tiền|cost|price|rẻ|đắt|mắc)", RegexOptions.IgnoreCase);

                // Tách từ khóa sản phẩm (loại bỏ các từ thông dụng vô nghĩa)
                string[] stopWords = { "mua", "bán", "cho", "xem", "tìm", "giá", "bao", "nhiêu", "cái", "con", 
                    "hình", "tại", "của", "này", "đang", "được", "không", "nào", "vậy", "nhé", "nhỉ",
                    "shop", "cửa", "hàng", "sản", "phẩm", "mặt", "hỏi", "muốn", "biết",
                    "thế", "thì", "còn", "hay", "hoặc", "với", "các", "những", "một", "trong", 
                    "trên", "dưới", "đây", "kia", "đấy", "rồi", "đã", "sẽ", "đều" };
                
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
                // Nếu khách chỉ chào hỏi hoặc hỏi chính sách, chúng ta có 0 lượt truy vấn DB động!
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
                            || p.Category.CategoryName.Contains(firstKeyword) 
                            || (p.Series != null && p.Series.SeriesName.Contains(firstKeyword))
                            || p.Supplier.CompanyName.Contains(firstKeyword));
                        
                        foreach (var keyword in parsedKeywords.Skip(1))
                        {
                            string kw = keyword;
                            query = query.Where(p => p.ProductName.Contains(kw) 
                                || p.Category.CategoryName.Contains(kw) 
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
                        ProductName = x.ProductName,
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
                    ? JsonSerializer.Serialize(matchedProducts.Select(p => new
                    {
                        p.ProductName,
                        GiaGoc = p.UnitPrice.ToString("N0") + "đ",
                        GiaBan = p.FinalPrice.ToString("N0") + "đ",
                        GiamGia = (p.Discount * 100) + "%",
                        TonKho = p.StockQuantity > 0 ? p.StockQuantity + " sản phẩm" : "HẾT HÀNG"
                    }))
                    : "[]";

                string systemPrompt = $@"{cachedStoreInfo}

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
                    return Json(new { error = "Lỗi khi kết nối với Gemini AI", details = errorContent });
                }

                string responseString = await apiResponse.Content.ReadAsStringAsync();
                using var doc = JsonDocument.Parse(responseString);
                
                string replyText = doc.RootElement
                    .GetProperty("candidates")[0]
                    .GetProperty("content")
                    .GetProperty("parts")[0]
                    .GetProperty("text")
                    .GetString() ?? "Xin lỗi bạn, tôi gặp chút trục trặc khi suy nghĩ câu trả lời.";

                return Json(new ChatbotResponse
                {
                    Reply = replyText,
                    Products = matchedProducts
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = "Đã xảy ra lỗi hệ thống", details = ex.Message });
            }
        }
    }
}
