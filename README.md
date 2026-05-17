# 🚀 Hướng Dẫn Phát Triển Dự Án: Hobby Shop E-commerce

Tài liệu này đóng vai trò là kim chỉ nam cho quá trình phát triển dự án trang web thương mại điện tử chuyên bán đồ chơi mô hình (Hobby Shop). Nội dung bao gồm quy chuẩn cấu trúc, hướng dẫn tái sử dụng UI và các mục tiêu tính năng cốt lõi (MVP) cũng như tính năng mở rộng.

---

## 📂 1. Cấu Trúc Thư Mục (Folder Structure)

Dự án tuân theo kiến trúc **ASP.NET Core MVC**. Dưới đây là sơ đồ cấu trúc thư mục thực tế của dự án để bạn dễ hình dung:

```text
TuNhanTamTInh_Ecommerce/
│
├── Controllers/         # Chứa các bộ điều khiển (VD: AccountController.cs, CartController.cs, ProductsController.cs)
├── Models/              # Chứa các Entity models (map với Database) và ViewModels
├── DTOs/                # Data Transfer Objects - Chứa dữ liệu chuyển đổi (VD: ProductUpdateInfoDTO.cs)
├── Helpers/             # Chứa các class hỗ trợ tiện ích dùng chung
│   ├── AutoMapperProfile.cs  # Cấu hình mapping dữ liệu (Entity ↔ DTO)
│   ├── EmailHelper.cs        # Hỗ trợ gửi Email SMTP xác thực tài khoản
│   ├── ProductQueryExtensions.cs # Extension tối ưu truy vấn sản phẩm (LINQ)
│   └── SlugHelper.cs         # Hỗ trợ sinh slug tự động cho sản phẩm/danh mục
├── Views/               # Chứa các file giao diện Razor (.cshtml)
│   ├── Home/            # View tương ứng của HomeController
│   ├── Products/        # View tương ứng của ProductsController
│   │   └── _ViewStart.cshtml     # Layout dành cho CRUD Products (sử dụng _LayoutCRUD)
│   ├── Categories/      # View tương ứng của CategoriesController
│   │   └── _ViewStart.cshtml     # Layout dành cho CRUD Categories (sử dụng _LayoutCRUD)
│   ├── Shared/          # Layout chính (_Layout.cshtml) và các Partial View dùng chung
│   │   ├── _Layout.cshtml        # Layout chính cho trang khách (Frontend)
│   │   ├── _ViewImports.cshtml   # Import namespaces và dependencies
│   │   └── Components/  # Chứa các View Component (VD: CategoryMenu)
│   │       └── CategoryMenu/
│   │           └── Default.cshtml
│   └── _ViewStart.cshtml     # Layout mặc định (phục vụ fallback)
│
├── ViewComponents/      # Chứa class logic (.cs) cho các View Component độc lập
│
├── wwwroot/             # Chứa file tĩnh (Public ra ngoài)
│   ├── css/             # Stylesheets (CSS/SASS)
│   ├── js/              # Javascript files
│   ├── images/          # Hình ảnh
│   │   ├── Categories/  # Ảnh danh mục
│   │   └── Products/    # Ảnh sản phẩm
│   ├── lib/             # Các thư viện bên thứ 3 (Bootstrap, jQuery...)
│   └── (các file HTML template tham khảo như index.html, shop-grid.html...)
│
├── Data/                # Chứa DbContext và cấu hình Entity Framework Core
├── Program.cs           # File cấu hình, khởi chạy ứng dụng và đăng ký các services
├── appsettings.json     # Cấu hình biến môi trường, chuỗi kết nối Database...
├── Dockerfile           # File cấu hình để đóng gói dự án lên Docker
└── HobbyShopScript_schema... # Các file script SQL cấu trúc và dữ liệu mẫu
```

**Chi tiết vai trò của các thành phần chính:**
- **`Controllers/`**: Nơi tiếp nhận Request từ URL, gọi tới Database/Service để xử lý logic, và quyết định trả về View nào.
- **`Models/`**: Dùng để định nghĩa các cấu trúc bảng (Entity) trong Database và các lớp gói dữ liệu giao tiếp với View (ViewModel).
- **`DTOs/`**: Chứa các lớp dữ liệu trung gian (Data Transfer Objects) dùng cho form **Create/Edit** nhằm giảm thiểu rủi ro **overposting**. Ví dụ: `ProductUpdateInfoDTO.cs` chỉ chứa các field người dùng được phép nhập.
- **`Helpers/`**: Nơi khai báo các hàm tiện ích dùng nhiều lần như `SlugHelper.GenerateSlug()` để sinh slug từ tên sản phẩm, định dạng tiền tệ, mã hóa mật khẩu, hay các hàm Extension xử lý Session/Cookie, xác thực email, và cấu hình AutoMapper.
- **`Views/`**: Chuyên chứa HTML kết hợp mã C# (Razor Syntax). Các file `.cshtml` được chia theo từng Controller.
  - **`_ViewStart.cshtml` trong từng Controller folder**: Thiết lập layout mặc định cho các view của controller đó.
- **`ViewComponents/`**: Cực kỳ quan trọng để tách và tái sử dụng các khối giao diện động (ví dụ: Menu chính, Giỏ hàng thu nhỏ). File `.cs` xử lý logic đặt ở đây, còn giao diện `.cshtml` của nó được đặt trong `Views/Shared/Components/`.
- **`wwwroot/`**: Bất kỳ file nào (CSS, JS, Hình ảnh, Font) muốn truy cập được trực tiếp từ trình duyệt đều phải đặt vào đây.

---

## 🧩 2. Partial View và View Component (Tái sử dụng UI)

Để code không bị lặp lại (DRY) và file Layout/View không quá dài, một số phần của website **bắt buộc** phải tách ra.

### 2.1. Phân Biệt & Khi Nào Nên Dùng

| Tiêu chí | Partial View | View Component |
| :--- | :--- | :--- |
| **Bản chất** | Là một mảng HTML/Razor đơn giản. | Là một "Mini-Controller", có class xử lý logic riêng và View riêng. |
| **Dữ liệu** | Nhận dữ liệu (Model) trực tiếp từ View cha truyền vào. | Tự gọi Database/Service để lấy dữ liệu độc lập với View cha. |
| **Khi nào dùng?** | - Card Sản phẩm (Product Card).<br>- Phân trang (Pagination).<br>- Các khối HTML tĩnh (Footer). | - Menu Danh mục Hàng hóa.<br>- Giỏ hàng Mini (Mini Cart) trên Header.<br>- Danh sách sản phẩm nổi bật/mới nhất. |

### 2.2. Hướng Dẫn Thiết Lập View Component (Ví Dụ: Menu Hàng Hóa)

**Bước 1: Tạo class logic backend**
Tạo file `ViewComponents/CategoryMenuViewComponent.cs`:
```csharp
using Microsoft.AspNetCore.Mvc;
// ... (inject db context)
public class CategoryMenuViewComponent : ViewComponent
{
    public async Task<IViewComponentResult> InvokeAsync()
    {
        var categories = /* Lấy danh sách danh mục từ DB */;
        return View(categories); // Mặc định sẽ gọi file Default.cshtml
    }
}
```

**Bước 2: Tạo giao diện (View)**
Tạo file tại đường dẫn chính xác: `Views/Shared/Components/CategoryMenu/Default.cshtml`
```html
@model IEnumerable<Category>
<ul class="menu">
    @foreach(var item in Model) {
        <li><a href="...">@item.Name</a></li>
    }
</ul>
```

**Bước 3: Gọi ra ở View cha (ví dụ `_Layout.cshtml`)**
```html
@await Component.InvokeAsync("CategoryMenu")
```

### 2.3. Hướng Dẫn Thiết Lập Partial View (Ví Dụ: Product Card)

**Bước 1: Tạo file `.cshtml`**
Tạo file `Views/Shared/_ProductCard.cshtml`:
```html
@model ProductViewModel
<div class="card">
    <img src="@Model.ImageUrl" />
    <h3>@Model.Name</h3>
    <p>@Model.Price VNĐ</p>
</div>
```

**Bước 2: Gọi trong View chứa danh sách (ví dụ `Index.cshtml`)**
```html
@foreach (var product in Model)
{
    <partial name="_ProductCard" model="product" />
}
```

---

## 🎯 3. Các Module Chính & Mục Tiêu MVP (Core)

Để đạt được Minimum Viable Product (MVP) và hoàn thành tốt đồ án, dự án được triển khai theo tiến độ sau:

1. **Layout Trang Chủ (Homepage):** 
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Đã tích hợp giao diện đồng bộ (màu chủ đạo `#560bad`), kết nối backend qua các ViewComponent (`ProductLatestProducts`) để hiển thị sản phẩm mới nhất, sản phẩm hot theo từng Tab.
2. **Menu Hàng Hóa (Category Menu):**
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Phân cấp danh mục thông minh bằng cách quét liên kết ảo qua bảng Products, giữ nguyên schema Database mà vẫn có Menu xổ ngang cực mượt.
3. **Trang Danh Sách Hàng Hóa (Product List):**
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Hiển thị thẻ sản phẩm (Tags Sale, click vào text), hỗ trợ bộ lọc theo khoảng giá, danh mục, phân trang.
4. **Chi Tiết Hàng Hóa (Product Detail):**
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Tối ưu hóa layout ảnh, slider thumbnail đều đặn, hiển thị linh hoạt lưới 4 sản phẩm liên quan.
5. **Thêm Vào Giỏ Hàng (Add to Cart):**
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Đã tích hợp hoàn thiện backend [CartController.cs] với các hành động AJAX (`AddToCart`, `GetCartPreview`). Giúp thêm sản phẩm nhanh mà không cần tải lại trang, kèm thông báo SweetAlert2/Toast mượt mà.
6. **Thông Tin Giỏ Hàng (Cart Detail):**
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Đã phát triển trang [Views/Cart/Index.cshtml] hiển thị chi tiết các món hàng. Hỗ trợ AJAX cập nhật số lượng (`UpdateQuantity`) kiểm tra tồn kho theo thời gian thực và xóa sản phẩm (`DeleteCartItem`).
7. **Login / Register (Đăng Nhập / Đăng Ký):**
   - **Trạng thái:** ✅ Hoàn thành 100%.
   - **Chi tiết:** Hệ thống xác thực bằng Cookie hoạt động mượt mà tại [AccountController.cs]. Hỗ trợ đăng ký, đăng nhập, quên mật khẩu (gửi email reset), đổi mật khẩu và trang cá nhân Profile hoàn chỉnh.
8. **Thanh Toán & Đặt Đơn Hàng (Checkout & Order):**
   - **Trạng thái:** ❌ Chưa phát triển (Đang đề xuất).
   - **Chi tiết:** Cần tạo bộ điều khiển `CheckoutController.cs` và view `Views/Checkout/Index.cshtml` để cho phép người dùng nhập thông tin nhận hàng, lựa chọn phương thức thanh toán, áp dụng mã giảm giá và lưu hóa đơn vào bảng `Orders` và `OrderDetails`.

---

## 🌟 4. Các Tính Năng Đề Xuất Nâng Cao (Sắp xếp theo thứ tự ưu tiên "ăn điểm")

Để biến trang web thành một trang thương mại điện tử Hobby Shop chuyên nghiệp và **đạt điểm số tối đa cho đồ án**, dưới đây là danh sách tổng hợp các tính năng được đề xuất và sắp xếp theo mức độ ưu tiên:

### 🔥 Ưu Tiên 1: Nhóm Kỹ Thuật Nâng Cao & Core E-commerce (Điểm Giỏi)
Đây là các tính năng chứng minh năng lực kỹ thuật và hiểu biết sâu về luồng hệ thống thương mại điện tử thực tế:
1. **Thanh Toán Trực Tuyến (VNPay Sandbox):** Tích hợp cổng thanh toán VNPay Sandbox. Đây là "vũ khí" cực mạnh để lấy điểm tuyệt đối cho đồ án môn Web.
2. **Quản Lý Đơn Hàng & Tracking (Khách hàng & Admin):** 
   - **Khách hàng:** Trang Profile cá nhân cho phép xem lịch sử đơn hàng, xem chi tiết và tracking trạng thái giao nhận đơn (Chờ xử lý, Đang giao, Đã giao, Đã hủy).
   - **Admin:** Giao diện quản lý toàn bộ đơn hàng của hệ thống, cho phép thay đổi trạng thái và điền mã vận đơn thực tế.
3. **Phân vùng Quản trị (Admin Area):** Chuyển các hành động CRUD (quản lý sản phẩm, danh mục, tài khoản, đơn hàng) vào một **Area** riêng biệt (`Areas/Admin`) thay vì viết chung trong Controllers chính để tăng tính bảo mật và chuyên nghiệp cho kiến trúc mã nguồn.
4. **Hệ Thống Tiền Đặt Hàng (Pre-Order):** Rất đặc thù của Hobby Shop (do các mô hình thường công bố và cho đặt trước 3-6 tháng). Cần thêm trạng thái "Đặt hàng trước" cho các sản phẩm chưa phát hành.

### 🎨 Ưu Tiên 2: Nhóm Tận Dụng Template Có Sẵn (Tối Ưu Trải Nghiệm - Dễ Làm)
Nhóm này giúp trang web trông đồ sộ, nhiều chức năng nhưng lại cực kỳ dễ triển khai vì **template Ogani trong `wwwroot/` đã cung cấp sẵn giao diện (UI) 100%**:
5. **Trang Blog / Tin tức & Review (Tận dụng `blog.html` và `blog-details.html`):** Rất thích hợp làm chức năng đăng bài Review đập hộp (Unboxing), thông báo hàng mới để kéo tương tác.
6. **Mã Giảm Giá / Khuyến Mãi (Tận dụng `shoping-cart.html`):** Trong giỏ hàng đã có khối nhập mã giảm giá. Cần thêm API xử lý logic kiểm tra bảng `Vouchers` (kiểm tra hạn dùng, lượt dùng còn lại) để áp dụng giảm giá.
7. **Trang Yêu Thích (Wishlist):** backend đã có sẵn các API `ToggleFavorite` và bảng `Favorites` trong DB. Chỉ cần tạo trang `Views/Account/Wishlist.cshtml` hiển thị các mô hình người dùng đã lưu thích.
8. **Trang Liên Hệ & Bản Đồ (Tận dụng `contact.html`):** Có sẵn form liên hệ và chỗ nhúng Google Maps. Dùng để lưu lời nhắn của khách vào Database (bảng `Questions` hoặc bảng liên hệ riêng).

---

## 📂 5. Báo Cáo Quét Dự Án & Đề Xuất Lộ Trình Phát Triển Chi Tiết (Project Scan & Recommendations)

Qua việc quét toàn bộ cấu trúc dự án thực tế, dưới đây là **phân tích chi tiết các file và tính năng còn thiếu** cùng hướng dẫn triển khai để bạn có thể hoàn thành xuất sắc đồ án của mình:

### 1️⃣ Hoàn thiện Luồng Thanh toán & Đặt hàng (Checkout & Order) - **ĐỘ ƯU TIÊN: KHẨN CẤP**
*Hiện tại nút "TIẾN HÀNH THANH TOÁN" trong giỏ hàng đang trỏ đến `Checkout/Index` nhưng Controller này chưa tồn tại.*

* **Cần tạo mới:**
  1. **Controller:** [CheckoutController.cs]
     * Thêm hành động `Index` (GET) để hiển thị form thanh toán. Đọc thông tin từ giỏ hàng hiện tại của user để hiển thị tóm tắt đơn hàng.
     * Thêm hành động `PlaceOrder` (POST) để lưu thông tin đặt hàng vào bảng `Orders` và các mặt hàng vào bảng `OrderDetails`. Sau đó, tiến hành xóa sạch `CartItems` của user đó và cập nhật số lượng tồn kho sản phẩm trong bảng `Products`.
  2. **View:** `Views/Checkout/Index.cshtml`
     * Thiết kế form điền: Họ tên, Địa chỉ giao hàng, Số điện thoại, Phương thức thanh toán (COD hoặc VNPay).
     * Tận dụng thiết kế từ file mẫu `wwwroot/checkout.html` để đồng bộ UI cực kỳ premium.
  3. **Mapping:** Đăng ký mapping trong [Helpers/AutoMapperProfile.cs] nếu cần thiết để chuyển giao giữa ViewModel và Model Entity.

### 2️⃣ backend Xử lý Voucher / Mã Giảm Giá - **ĐỘ ƯU TIÊN: CAO**
*Trong giao diện giỏ hàng đã có ô nhập Coupon nhưng chưa có xử lý logic.*

* **Hướng triển khai:**
  * Viết một API AJAX trong [CartController.cs] (ví dụ: `ApplyVoucher(string voucherCode)`).
  * API sẽ kiểm tra sự tồn tại của mã trong bảng `Vouchers` (kiểm tra `IsActive = true`, ngày hết hạn `ExpiryDate`, và lượt sử dụng `UsedCount < UsageLimit`).
  * Trả về số tiền giảm giá và cập nhật lại Tổng cộng (`grandTotal`) trên giao diện giỏ hàng bằng AJAX.

### 3️⃣ Tích Hợp Cổng Thanh Toán VNPay Sandbox - **ĐỘ ƯU TIÊN: TỐI ƯU ĐIỂM SỐ**
*Tính năng này giúp đồ án của bạn vượt trội hơn 90% các nhóm khác.*

* **Hướng triển khai:**
  * Tạo một class Helper chuyên tính toán và sinh URL thanh toán VNPay (tham khảo tài liệu VNPay Developer).
  * Khi người dùng chọn phương thức thanh toán là "VNPay" tại trang Checkout và nhấn đặt hàng:
    1. Tạo đơn hàng với trạng thái `StatusID = 0` (Chờ thanh toán).
    2. Chuyển hướng người dùng sang trang thanh toán của VNPay.
    3. Tạo Action `PaymentCallback` trong [CheckoutController.cs] để nhận phản hồi từ VNPay. Nếu thành công, cập nhật trạng thái đơn hàng thành `StatusID = 1` (Đã thanh toán) và chuyển hướng tới trang thành công. Nếu thất bại, báo lỗi và giữ lại giỏ hàng cho khách thử lại.

### 4️⃣ Trang Lịch Sử Đơn Hàng & Theo Dõi Đơn (Order Tracking) - **ĐỘ ƯU TIÊN: TRUNG BÌNH**
*Hiện tại tài khoản đã có trang Profile nhưng chưa có phần xem đơn hàng.*

* **Hướng triển khai:**
  * Tạo view `Views/Account/MyOrders.cshtml` hoặc tích hợp tab "Đơn hàng của tôi" vào trang [Views/Account/Profile.cshtml]
  * Sử dụng database view `v_OrderDetailsWithProduct` để hiển thị trực quan các mặt hàng đã mua kèm hình ảnh đại diện, giá tiền, số lượng, trạng thái đơn hàng hiện tại (`StatusName`) và mã vận đơn tracking.

### 5️⃣ Module Tin Tức & Review Đập Hộp (Blog & Articles) - **ĐỘ ƯU TIÊN: THẨM MỸ**
*Tận dụng giao diện Blog cực đẹp của Ogani để làm website thêm phong phú nội dung.*

* **Hướng triển khai:**
  * Tạo `BlogController.cs` để quản lý các bài viết tin tức hoặc bài viết review mô hình mới.
  * Tải dữ liệu từ bảng `WebPages` hoặc tạo bảng mới `Blogs` trong SQL Server để quản lý nội dung bài viết.
  * Tạo các View tương ứng sử dụng template của `wwwroot/blog.html` và `wwwroot/blog-details.html`.

### 6️⃣ Kiến trúc chuyên nghiệp với Admin Area - **ĐỘ ƯU TIÊN: ĐIỂM 10 BẢO MẬT**
*Hiện tại các trang CRUD Admin đang viết chung với Controller của khách hàng.*

* **Hướng triển khai:**
  * Tạo cấu trúc thư mục mới: `Areas/Admin/Controllers/` và `Areas/Admin/Views/`.
  * Di chuyển các hành động quản trị viên (`AdminIndex`, `Create`, `Edit`, `Delete`) của `ProductsController` và `CategoriesController` sang `Areas/Admin/Controllers`.
  * Điều này giúp phân tách hoàn toàn mã nguồn phía Admin và phía Client, nâng tầm chất lượng kiến trúc phần mềm cho đồ án tốt nghiệp hoặc đồ án cuối kỳ.
