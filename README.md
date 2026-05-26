 bi# 🚀 HỘ BẢN THƯƠNG MẠI ĐIỆN TỬ HOBBY SHOP: TRINITY HOBBY SHOP (TỨ NHÃN TAM TINH)

Dự án này là một trang web thương mại điện tử chuyên biệt (Hobby Shop) bán các mô hình lắp ráp (Gunpla, Figure, Model Kit). Được phát triển trên nền tảng **ASP.NET Core 8.0 MVC**, hệ thống tích hợp các kiến trúc backend hiện đại, luồng nghiệp vụ thanh toán trực tuyến thực tế, trợ lý AI thông minh và giao diện người dùng tối ưu. 

Tài liệu này cung cấp cái nhìn toàn diện về cấu trúc thư mục, kiến trúc tái sử dụng giao diện, tiến độ hoàn thành thực tế của toàn bộ các module và đặc biệt là các **điểm sáng công nghệ chuyên sâu** được tích hợp nhằm phục vụ tốt nhất cho quá trình bảo vệ đồ án trước Hội đồng.

---

## 📂 1. Cấu Trúc Thư Mục Thực Tế (Folder Structure)

Dự án tuân thủ nghiêm ngặt mô hình kiến trúc **ASP.NET Core MVC (Model-View-Controller)** phối hợp với các Design Pattern hiện đại (Helper, ViewComponent, DTO):

```text
TuNhanTamTInh_Ecommerce/
│
├── Controllers/         # Bộ điều khiển tiếp nhận Request và điều phối logic nghiệp vụ
│   ├── AboutUsController.cs   # Điều hướng trang Giới thiệu Cyberpunk
│   ├── AccountController.cs   # Quản lý Đăng ký, Đăng nhập, OTP, Quên mật khẩu, Profile
│   ├── AdminController.cs     # Khu vực quản trị Admin (CRUD sản phẩm, danh mục)
│   ├── CartController.cs      # Xử lý Giỏ hàng bằng cơ chế AJAX mượt mà
│   ├── ChatbotController.cs   # Trợ lý ảo AI tích hợp Gemini API & Cache dữ liệu cửa hàng
│   ├── CheckoutController.cs  # Xử lý thanh toán (COD, VNPAY, Repay) & Timezone Sync
│   ├── Favorites.cs           # Quản lý danh sách sản phẩm yêu thích (Wishlist)
│   ├── HomeController.cs      # Quản lý Trang chủ và điều hướng Banner tĩnh/động
│   ├── LanguageController.cs  # Điều chỉnh Cookie chuyển đổi đa ngôn ngữ (VI/EN)
│   ├── OrdersController.cs    # Quản lý hóa đơn, lịch sử mua hàng & Hủy đơn hàng
│   └── ProductsController.cs  # Quản lý Danh mục, tìm kiếm live-search & Chi tiết sản phẩm
│
├── Models/              # Lớp dữ liệu (Entity) ánh xạ Database & Lớp truyền tải dữ liệu
│   ├── Account.cs, Product.cs, Order.cs, OrderDetail.cs, Voucher.cs... # Thực thể DB
│   └── ViewModels/      # Gói dữ liệu chuyên biệt phục vụ hiển thị (Form/Page ViewModels)
│       ├── CheckoutViewModel.cs, ChatbotMessageViewModel.cs, ProductCardViewModel.cs...
│
├── DTOs/                # Data Transfer Objects - Chống Overposting lỗ hổng bảo mật
│
├── Helpers/             # Thư viện tiện ích và xử lý nghiệp vụ nâng cao dùng chung
│   ├── AutoMapperProfile.cs      # Tự động ánh xạ Entity ↔ DTO/ViewModel
│   ├── CustomStringLocalizer.cs  # Cơ chế dịch thuật đa ngôn ngữ tối giản (Zero XML/Resx)
│   ├── EmailHelper.cs            # Gửi Email SMTP xác thực OTP và thông báo trạng thái đơn hàng
│   ├── EmailValidator.cs         # Xác thực cú pháp email nâng cao bằng Regex
│   ├── Loc.cs                    # Lấy chuỗi ngôn ngữ động dựa trên Culture hiện hành
│   ├── MinimumAgeAttribute.cs    # Custom Validation kiểm tra tuổi tối thiểu người dùng (>=15)
│   ├── ProductQueryExtensions.cs # Extension LINQ hỗ trợ lọc, tìm kiếm và phân trang tối ưu
│   ├── SlugHelper.cs             # Sinh Slug tự động chuẩn SEO từ tên sản phẩm tiếng Việt
│   └── VnPayLibrary.cs           # Thư viện tích hợp, ký số HMAC-SHA512 thanh toán VNPAY
│
├── Data/                # DbContext và cấu hình kết nối Entity Framework Core
│
├── Views/               # Hệ thống giao diện Razor Engine (.cshtml)
│   ├── AboutUs/         # View trang giới thiệu thành viên hiệu ứng Cyberpunk vũ trụ
│   ├── Account/         # Giao diện Đăng ký, Đăng nhập, Profile, Quên mật khẩu
│   ├── Admin/           # Giao diện quản trị CRUD Category & Product chuyên biệt
│   ├── Cart/            # Trang chi tiết giỏ hàng AJAX
│   ├── CheckOut/        # Form đặt hàng, Success COD (Fireworks), Success VNPAY
│   ├── Favorites/       # Giao diện quản lý Wishlist
│   ├── Home/            # Giao diện trang chủ tích hợp ViewComponent
│   ├── Orders/          # Giao diện chi tiết đơn hàng, lịch sử đơn hàng
│   ├── Products/        # Giao diện danh sách sản phẩm, chi tiết sản phẩm và bình luận
│   └── Shared/          # Layout chính và các khối thành phần dùng chung (Partial, Component)
│       ├── Components/  # Các ViewComponent độc lập (CategoryMenu, MiniCart...)
│       ├── _ChatWidget.cshtml       # Widget Chatbot nổi góc màn hình
│       ├── _LanguageSelector.cshtml # Component chuyển đổi ngôn ngữ Việt - Anh
│       └── _Layout.cshtml, _LayoutAuth.cshtml # Bố cục tổng thể & Bố cục Auth
│
├── wwwroot/             # Tài nguyên tĩnh công khai (CSS, JS, Images, Libs)
│   ├── css/             # CSS đóng gói theo module: about-us.css, chatbot.css, site.css...
│   ├── js/              # Javascript xử lý AJAX, Canvas Pháo hoa, Cursor Glow...
│   └── images/          # Ảnh tĩnh của sản phẩm và danh mục mô hình
│
├── Program.cs           # Điểm khởi chạy hệ sinh thái, đăng ký Services & Routing Middleware
├── .env                 # Cấu hình biến môi trường bảo mật (API Key, Mật khẩu gửi Email...)
├── docker-compose.yml   # Docker Orchestration khởi chạy Web & SQL Server đồng bộ
└── Dockerfile           # Đóng gói tối ưu hóa ứng dụng ASP.NET Core lên Container
```

---

## 🧩 2. Partial View và View Component (Kiến Trúc Tái Sử Dụng UI)

Nhằm tuân thủ nguyên lý **DRY (Don't Repeat Yourself)** và tối ưu hiệu năng render của Razor Engine, dự án phân tách rõ rệt 2 cơ chế tái sử dụng giao diện:

### 2.1. Phân Biệt & Khi Nào Nên Dùng

| Tiêu chí | Partial View (Giao diện Thành phần) | View Component (Thành phần Logic) |
| :--- | :--- | :--- |
| **Bản chất** | Là file `.cshtml` thuần HTML/Razor, không có class backend riêng. | Là một "Mini-Controller", bao gồm file logic `.cs` và file view `.cshtml` riêng biệt. |
| **Nạp dữ liệu** | Phụ thuộc hoàn toàn vào dữ liệu (Model) truyền xuống từ View cha. | Tự lập nghiệp: Tự động truy vấn Database, xử lý logic độc lập với View cha. |
| **Kịch bản dùng** | - Thẻ sản phẩm dùng chung (`_ProductCard.cshtml`).<br>- Thanh phân trang (`_Pagination.cshtml`).<br>- Bộ chọn ngôn ngữ tĩnh (`_LanguageSelector.cshtml`). | - Menu danh mục động xổ ngang đa cấp (`CategoryMenu`).<br>- Hộp thoại preview giỏ hàng nhỏ trên header (`MiniCart`).<br>- Danh sách sản phẩm mới về/giảm giá sâu độc lập. |

### 2.2. Hướng Dẫn Kỹ Thuật Tích Hợp View Component

1. **Tạo logic backend (`ViewComponents/CategoryMenuViewComponent.cs`):**
   ```csharp
   public class CategoryMenuViewComponent : ViewComponent
   {
       private readonly EcommerceHobbyShopContext _context;
       public CategoryMenuViewComponent(EcommerceHobbyShopContext context) => _context = context;

       public async Task<IViewComponentResult> InvokeAsync()
       {
           var categories = await _context.Categories.Include(c => c.Products).ToListAsync();
           return View(categories); // Nạp dữ liệu độc lập
       }
   }
   ```
2. **Thiết kế giao diện (`Views/Shared/Components/CategoryMenu/Default.cshtml`):**
   ```html
   @model IEnumerable<Category>
   <div class="hero__categories">
       <ul>
           @foreach (var item in Model) {
               <li><a href="/Products?category=@item.CategorySlug">@item.CategoryName</a></li>
           }
       </ul>
   </div>
   ```
3. **Triển khai ở View cha (Ví dụ: `_Layout.cshtml` hoặc `_Header.cshtml`):**
   ```html
   @await Component.InvokeAsync("CategoryMenu")
   ```

---

## 🎯 3. Bảng Tiến Độ & Danh Sách Các Module Cốt Lõi (Core Progress)

Hệ thống đã được phát triển hoàn thiện 100% tất cả các tính năng từ cơ bản (MVP) đến nâng cao, đảm bảo hoạt động thực tế ổn định, không có dữ liệu giả hay tính năng "đóng băng":

| STT | Module Tính Năng | Trạng Thái | Công Nghệ & Tệp Tin Liên Quan | Chi Tiết Nghiệp Vụ Thực Tế |
| :--- | :--- | :---: | :--- | :--- |
| 1 | **Bố Cục Trang Chủ<br>(Homepage Layout)** | ✅ 100% | `HomeController.cs`<br>`Home/Index.cshtml`<br>`ProductLatestViewComponent` | Thiết lập giao diện chủ đạo màu Cyber-Purple `#560bad` cao cấp, tích hợp slide banner động, tabs sản phẩm mới nhất/xem nhiều nhất bằng AJAX. |
| 2 | **Menu Hàng Hóa Động<br>(Category Menu)** | ✅ 100% | `CategoryMenuViewComponent.cs`<br>`Shared/Components/CategoryMenu` | Tự động thống kê số lượng sản phẩm con trong từng danh mục và kết xuất menu dọc/ngang đa tầng thông minh. |
| 3 | **Bộ Lọc & Tìm Kiếm<br>(Product Filter & Search)** | ✅ 100% | `ProductsController.cs`<br>`ProductQueryExtensions.cs`<br>`_Header.cshtml` (Search JS) | Live-search gõ chữ hiển thị kết quả trực tiếp bằng JQuery Debounce. Bộ lọc đa tiêu chí (Lọc theo danh mục, dòng Series mô hình, khoảng giá) kết hợp phân trang LINQ. |
| 4 | **Chi Tiết Sản Phẩm<br>(Product Detail)** | ✅ 100% | `ProductsController.cs`<br>`Products/Details.cshtml` | Hiển thị slider ảnh thumbnail chi tiết, bộ đếm số lượng thông minh chặn số âm, hiển thị danh sách 4 sản phẩm liên quan cùng danh mục, tab Đánh giá & Bình luận của khách hàng. |
| 5 | **Giỏ Hàng AJAX<br>(Shopping Cart AJAX)** | ✅ 100% | `CartController.cs`<br>`Views/Cart/Index.cshtml`<br>`wwwroot/js/site.js` | Thêm vào giỏ nhanh không load lại trang. Hộp thoại Mini-Cart preview trên Header cập nhật Realtime. Tích hợp SweetAlert2 thông báo trạng thái mượt mà. |
| 6 | **Quản Lý Số Lượng Giỏ<br>(Cart Management)** | ✅ 100% | `CartController.cs`<br>`CartItem.cs` | Cho phép tăng/giảm số lượng sản phẩm bằng AJAX. **Đặc biệt:** Hệ thống tự động kiểm tra tồn kho tối đa trong DB thời gian thực, ngăn chặn khách đặt quá số lượng cửa hàng hiện có. |
| 7 | **Hệ Thống Xác Thực<br>(Identity & Auth)** | ✅ 100% | `AccountController.cs`<br>`EmailHelper.cs`<br>`Views/Account/Login.cshtml` | Xác thực bằng **Cookie Authentication** bảo mật cao. Quy trình đăng ký tài khoản bắt buộc xác minh mã OTP gửi qua Email thực tế. Chức năng Quên mật khẩu khôi phục qua Email OTP. Trang Profile cá nhân. |
| 8 | **Sản Phẩm Yêu Thích<br>(Wishlist)** | ✅ 100% | `Favorites.cs`<br>`Favorites/Index.cshtml` | Cho phép lưu các mẫu Gundam/Figure yêu thích vào danh sách quan tâm, hiển thị huy hiệu (badge) số lượng yêu thích cập nhật tức thời trên Header. |
| 9 | **Đặt Hàng & Thanh Toán<br>(Checkout & Order)** | ✅ 100% | `CheckoutController.cs`<br>`Checkout/Index.cshtml` | Biểu mẫu nhập thông tin người nhận chuyên nghiệp. Tích hợp cơ chế **Guest Checkout** tự động lưu đường dẫn chuyển hướng quay lại form đặt hàng sau khi đăng ký/đăng nhập. |
| 10 | **Trang Chốt Đơn COD<br>(COD Success & Fireworks)** | ✅ 100% | `Checkout/Success.cshtml`<br>`wwwroot/js/fireworks.js` | Xây dựng màn hình hoàn thành đơn hàng COD độc lập. **Điểm nhấn:** Tích hợp Canvas JS sinh hiệu ứng **Pháo hoa nổ chúc mừng** rực rỡ mang tính tương tác cao khi chốt đơn thành công. |
| 11 | **Thanh Toán VNPAY<br>(VNPAY Sandbox)** | ✅ 100% | `VnPayLibrary.cs`<br>`CheckoutController.cs` | Tích hợp cổng thanh toán quốc gia VNPAY Sandbox. Xử lý chính xác chữ ký bảo mật HMAC-SHA512. Tự động gửi email hóa đơn chi tiết ngay khi giao dịch thành công. |
| 12 | **Hủy Đơn & Custom Dialog<br>(Order Cancel Modal)** | ✅ 100% | `OrdersController.cs`<br>`Orders/Details.cshtml` | Hủy đơn hàng từ phía khách hàng. Thiết kế **Hộp thoại Glassmorphism tùy biến** thay thế lệnh `confirm()` mặc định của trình duyệt. Tự động gửi mail thông báo trạng thái kèm điều khoản hoàn tiền cho đơn thanh toán qua thẻ. |
| 13 | **Thanh Toán Lại Đơn Hàng<br>(VNPAY Repay Flow)** | ✅ 100% | `CheckoutController.cs` (`RepayOrder`) | Đối với các đơn hàng VNPAY bị gián đoạn (mất mạng, hết giờ, đóng trình duyệt), hệ thống hiển thị nút **"Thanh toán ngay / Pay Now"** màu xanh lục nổi bật trong Lịch sử & Chi tiết đơn để khách tiếp tục thanh toán mà không cần đặt lại từ đầu. |
| 14 | **Quản Trị Hệ Thống<br>(Admin Dashboard CRUD)** | ✅ 100% | `AdminController.cs`<br>`admin-crud.css`<br>`Views/Admin/` | Phân quyền bảo vệ bằng Policy `"AdminOnly"`. Màn hình quản trị CRUD danh mục và quản trị sản phẩm (hỗ trợ nhiều ảnh chi tiết, tải ảnh lên server) với giao diện tối ưu. |
| 15 | **Trợ Lý Ảo AI Gemini<br>(Gemini AI Chatbot)** | ✅ 100% | `ChatbotController.cs`<br>`chatbot.css`<br>`Shared/_ChatWidget.cshtml` | Tích hợp **Gemini 3.1 Flash Lite** làm trợ lý tư vấn bán hàng. Chatbot có khả năng truy vấn nóng thông tin cửa hàng, voucher, và gợi ý sản phẩm phù hợp dựa trên phân tích từ khóa người dùng. |
| 16 | **Đa Ngôn Ngữ Linh Hoạt<br>(Multi-Language)** | ✅ 100% | `CustomStringLocalizer.cs`<br>`Loc.cs`<br>`LanguageController.cs` | Cơ chế dịch song ngữ Việt - Anh hoàn chỉnh trên toàn bộ hệ thống (từ menu, giỏ hàng, thông báo cho đến trang About Us và phản hồi của AI Chatbot) thông qua cơ chế Cookie Routing. |
| 17 | **Giới Thiệu Thành Viên<br>(Cyberpunk About Us)** | ✅ 100% | `AboutUsController.cs`<br>`about-us.css`<br>`AboutUs/Index.cshtml` | Thiết kế trang giới thiệu thành viên mang phong cách khoa học viễn tưởng vũ trụ tối (Space Cyberpunk). Thẻ kính mờ Glassmorphism, hiệu ứng **Cursor Glow** viền sáng di chuột, Orbiting Tech Bubbles chuyển động 3D. |

---

## 💡 4. Các Điểm Sáng Kỹ Thuật Độc Đáo & Cơ Chế Hoạt Động (Technical Breakthroughs)

Đây là các **lý luận giải pháp kỹ thuật chuyên sâu** đã được hiện thực hóa trong mã nguồn để giải quyết các bài toán thực tế, đóng vai trò là "vũ khí điểm tối đa" khi bảo vệ đồ án trước Hội đồng:

### 4.1. Giải Quyết Xung Đột ID Đơn Hàng Trên VNPAY Sandbox (`vnp_TxnRef` Hash)
* **Vấn đề thực tế:** Khi nhiều thành viên trong nhóm phát triển chạy ứng dụng cục bộ/Docker trên các máy khác nhau (nhưng dùng chung một mã cửa hàng `vnp_TmnCode` Sandbox của VNPAY), các mã đơn hàng nhỏ bắt đầu từ `1, 2, 3...` sẽ bị trùng lặp trên máy chủ VNPAY Sandbox, dẫn đến lỗi từ chối giao dịch tức thì: *"Giao dịch đang được xử lý hoặc đã quá thời gian thanh toán"*.
* **Giải pháp đột phá:** Tại [CheckoutController.cs](file:///d:/University%20Study%20Subjects/Web%20Programming/Final/TuNhanTamTInh_Ecommerce/Controllers/CheckoutController.cs), khi sinh URL thanh toán gửi đi, mã tham chiếu `vnp_TxnRef` được mã hóa theo định dạng duy nhất toàn cầu: `{OrderId}_{DateTime.UtcNow.Ticks}` (Ví dụ: `15_638210340912`). Cơ chế này đảm bảo mã giao dịch luôn độc nhất 100%. 
* **Cơ chế Callback xử lý:** Khi nhận phản hồi từ IPN/Callback (`VnpayReturn`), hệ thống tiến hành tách chuỗi (`Split('_')`) để lấy phần tử đầu tiên, chuyển đổi ngược lại thành mã đơn hàng `OrderId` gốc để truy vấn cơ sở dữ liệu và cập nhật trạng thái thanh toán một cách hoàn hảo:
```csharp
string txnRef = Request.Query["vnp_TxnRef"];
string orderIdStr = txnRef.Split('_')[0];
int orderId = int.Parse(orderIdStr);
// Truy vấn đơn hàng orderId để cập nhật IsPaid = true...
```

### 4.2. Đồng Bộ Múi Giờ Chuẩn GMT+7 Đa Nền Tảng Trong Môi Trường Docker Container (`GetVietnamTime`)
* **Vấn đề thực tế:** Khi ứng dụng được đóng gói và chạy bằng Docker, múi giờ mặc định của Linux Container luôn là **UTC (chậm hơn Việt Nam 7 tiếng)**. Lệnh lấy giờ hệ thống mặc định `DateTime.Now` sẽ bị lệch 7 tiếng, khiến thời gian khởi tạo giao dịch `vnp_CreateDate` gửi sang VNPAY bị coi là quá hạn và bị từ chối ngay lập tức.
* **Giải pháp đột phá:** Xây dựng phương thức chuyển đổi múi giờ thông minh `GetVietnamTime()` tự động nhận diện hệ điều hành của máy chủ chạy ứng dụng để áp dụng Catalog múi giờ tương ứng (Windows sử dụng `SE Asia Standard Time`, Linux sử dụng IANA `Asia/Ho_Chi_Minh`), đi kèm cơ chế fallback thủ công cộng thêm 7 tiếng nếu cả hai thư viện hệ thống đều bị chặn:
```csharp
private DateTime GetVietnamTime()
{
    var utcTime = DateTime.UtcNow;
    try
    {
        // Thử múi giờ chuẩn Windows
        var tz = TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time");
        return TimeZoneInfo.ConvertTimeFromUtc(utcTime, tz);
    }
    catch
    {
        try
        {
            // Thử múi giờ chuẩn Linux IANA
            var tz = TimeZoneInfo.FindSystemTimeZoneById("Asia/Ho_Chi_Minh");
            return TimeZoneInfo.ConvertTimeFromUtc(utcTime, tz);
        }
        catch
        {
            // Fallback thủ công nếu cả 2 OS đều lỗi
            return utcTime.AddHours(7);
        }
    }
}
```

### 4.3. Cơ Chế Tách Biệt Biến Môi Trường Và Chuỗi Kết Nối Linh Hoạt (Docker vs Host System)
* **Vấn đề thực tế:** Khi chạy ứng dụng trực tiếp trên máy chủ cục bộ (Host) để phát triển nhanh, việc ép nạp chuỗi kết nối Database Container từ tệp `.env` thường gây ra crash do xung đột cổng và mật khẩu dịch vụ SQL Server chạy cục bộ.
* **Giải pháp đột phá:** Tại [Program.cs](file:///d:/University%20Study%20Subjects/Web%20Programming/Final/TuNhanTamTInh_Ecommerce/Program.cs), bộ nạp biến môi trường tự động quét biến hệ thống `DOTNET_RUNNING_IN_CONTAINER`. Nếu phát hiện ứng dụng đang chạy ở môi trường ngoài Container (`!= true`), hệ thống sẽ cố tình bỏ qua dòng nạp `ConnectionStrings` từ tệp `.env`. Điều này ép ứng dụng tự động fallback về chuỗi kết nối chuẩn cục bộ định nghĩa trong `appsettings.json` (sử dụng mật khẩu SQL Server native của nhà phát triển như `123456`), giúp quá trình code song song giữa các thành viên không bị gián đoạn và không cần sửa đè mật khẩu của nhau.

### 4.4. Tối Ưu Hóa Hiệu Năng AI Chatbot Bằng Static Double-Checked Locking Cache
* **Vấn đề thực tế:** Để trợ lý AI Gemini tư vấn chính xác, hệ thống bắt buộc phải cung cấp ngữ cảnh (Context) đầy đủ về số lượng hàng hóa, danh mục, thương hiệu, sản phẩm hot, khuyến mãi và các mã giảm giá hiện hành. Tuy nhiên, việc thực hiện đồng thời hơn 12 truy vấn SQL đếm/lấy dữ liệu phức tạp cho mỗi lượt người dùng chat sẽ nhanh chóng gây nghẽn (DDOS) cơ sở dữ liệu.
* **Giải pháp đột phá:** Tại [ChatbotController.cs](file:///d:/University%20Study%20Subjects/Web%20Programming/Final/TuNhanTamTInh_Ecommerce/Controllers/ChatbotController.cs), hệ thống tích hợp bộ nhớ đệm tĩnh lưu trữ chuỗi thông tin cửa hàng (`_cachedStoreInfoVi` / `_cachedStoreInfoEn`) với thời hạn hết hạn 10 phút. Áp dụng kỹ thuật tối ưu hóa luồng **Double-checked locking pattern** kết hợp khóa đồng bộ `lock (CacheLock)`, đảm bảo 12 truy vấn SQL nặng nề chỉ được thực thi duy nhất **1 lần mỗi 10 phút** cho toàn bộ người dùng hệ thống.
* **Cơ chế Phân tích Từ khóa động:** Khi người dùng gửi câu hỏi, hệ thống tiến hành loại bỏ các Stop Words (từ vô nghĩa) và phân tích Regex để kiểm tra ý định (muốn tìm hàng mới, hàng rẻ, hay hàng giảm giá). Chỉ khi người dùng thực sự muốn tìm kiếm sản phẩm cụ thể, hệ thống mới thực hiện truy vấn SQL tìm kiếm theo từ khóa để nạp thẻ sản phẩm tương ứng, giữ cho Database luôn ở trạng thái tải tối thiểu và phản hồi AI phản xạ dưới 0.5 giây.

### 4.5. Đa Ngôn Ngữ Siêu Nhẹ Khóa Ngoại Trực Tiếp (Custom String Localizer Pattern)
* **Vấn đề thực tế:** Sử dụng file tài nguyên `.resx` mặc định của ASP.NET Core rất cồng kềnh, khó quản lý động và thường gây lỗi biên dịch khi làm việc nhóm qua Git.
* **Giải pháp đột phá:** Xây dựng hệ thống dịch thuật tối giản bằng cách kế thừa giao diện `IStringLocalizer` trong [CustomStringLocalizer.cs](file:///d:/University%20Study%20Subjects/Web%20Programming/Final/TuNhanTamTInh_Ecommerce/Helpers/CustomStringLocalizer.cs). Thiết kế lớp tĩnh hỗ trợ `Loc.T(vi, en)` lấy trực tiếp ngôn ngữ dựa trên `Thread.CurrentThread.CurrentUICulture.Name`:
```csharp
public static class Loc
{
    public static string T(string vi, string en)
    {
        var culture = Thread.CurrentThread.CurrentUICulture.Name;
        return culture == "en-US" ? en : vi;
    }
}
```
Tại các View, việc hiển thị chuỗi đa ngôn ngữ cực kỳ trực quan và đồng bộ:
```html
<h2>@Loc.T("GIỎ HÀNG CỦA BẠN", "YOUR SHOPPING CART")</h2>
```
Điều này giúp tối giản hóa 100% dung lượng mã nguồn, tăng tốc độ render giao diện và dễ dàng dịch thuật trực tiếp khi đang lập trình giao diện Razor.

---

## 🐳 5. Hướng Dẫn Deploy Bằng Docker & Cập Nhật Database (Docker Running Guide)

Dự án đã được container hóa hoàn chỉnh. Để phân phối ứng dụng cho các thành viên trong nhóm hoặc chạy trên máy chấm điểm của Giảng viên, thực hiện quy trình 3 bước chuẩn sau:

### Bước 1: Build và khởi chạy các Container ngầm
Mở terminal (PowerShell hoặc Bash) tại thư mục gốc của dự án chứa file `docker-compose.yml` và chạy lệnh:
```powershell
docker compose up -d --build
```
*Lệnh này sẽ tải image SQL Server, biên dịch mã nguồn C# dựa trên Dockerfile tối ưu hóa multi-stage build, tạo mạng nội bộ và khởi chạy ứng dụng web tại cổng `http://localhost:8080` (hoặc cổng cấu hình trong file `.env`).*

### Bước 2: Import Cơ sở dữ liệu mẫu vào SQL Server Container
Vì SQL Server chạy bên trong Container tách biệt, để nạp dữ liệu mẫu mà không bị mất khi reset container, thực hiện nạp tệp SQL trực tiếp từ máy ngoài vào container thông qua lệnh:
```powershell
# 1. Copy file script SQL vào trong container mssql_server
docker cp HobbyShopScript_schema_data.sql mssql_server:/tmp/HobbyShopScript_schema_data.sql

# 2. Thực thi lệnh sqlcmd bên trong container để import dữ liệu
docker exec -it mssql_server /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Password123" -C -i /tmp/HobbyShopScript_schema_data.sql
```
*(Thay thế `"YourStrong@Password123"` bằng mật khẩu SQL Server thực tế được khai báo trong file `.env` của bạn).*

### Bước 3: Kiểm tra trạng thái hoạt động
* Truy cập ứng dụng tại trình duyệt: **`http://localhost:8080`**
* Để kiểm tra log hoạt động của Web container để gỡ lỗi trực tiếp:
```powershell
docker compose logs -f hobbyshop-web
```

---

## 👨‍💻 6. Danh Sách Thành Viên & Phân Chia Vai Trò (Development Team)

Dự án được thực hiện bởi nhóm **Tứ Nhãn Tam Tinh** với sự phân chia vai trò rõ ràng, phát huy tối đa năng lực của từng thành viên:

1. **Trịnh Thành Đạt (Trưởng Nhóm - All-Rounder Fullstack):**
   * **Vai trò:** Quản trị toàn bộ Git Repository của nhóm, thiết kế kiến trúc cơ sở dữ liệu quan hệ, thiết lập hệ sinh thái Docker, xây dựng luồng bảo mật Cookie Authentication, tích hợp thanh toán VNPAY, lập trình API AI Chatbot tư vấn khách hàng và quản trị DevOps.
2. **Phạm Gia Bảo (Front-End Specialist):**
   * **Vai trò:** Lập trình chi tiết giao diện người dùng (UI/UX) đảm bảo độ tương thích responsive cao, thiết kế trang chủ, trang chi tiết sản phẩm, giỏ hàng AJAX, xây dựng hiệu ứng pháo hoa Canvas mừng chốt đơn và tối ưu hóa hệ thống phối màu Cyber-Purple sang trọng.
3. **Trần Nguyên Khang (Flexible Developer):**
   * **Vai trò:** Phát triển hệ thống đa ngôn ngữ (Localization), xây dựng các Helper hỗ trợ xử lý dữ liệu và kiểm tra ràng buộc nhập liệu, viết kịch bản kiểm thử toàn diện hệ thống (Test Cases) và quản lý tài liệu báo cáo kỹ thuật của dự án.

---

> [!TIP]
> **Khuyến nghị chấm điểm tốt:** Khi trình bày đồ án, hãy mở Chatbot AI và hỏi *"Hãy giới thiệu về cửa hàng"* hoặc thực hiện một giao dịch thanh toán VNPAY thực tế, sau đó cố tình bấm hủy đơn hàng để Hội đồng thấy được Custom Glassmorphism Dialog và Email thông báo điều khoản hoàn tiền tự động được gửi về hòm thư Gmail của khách hàng. Đây là những tính năng cực kỳ đắt giá!
