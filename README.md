# 🚀 Hướng Dẫn Phát Triển Dự Án: Hobby Shop E-commerce

Tài liệu này đóng vai trò là kim chỉ nam cho quá trình phát triển dự án trang web thương mại điện tử chuyên bán đồ chơi mô hình (Hobby Shop). Nội dung bao gồm quy chuẩn cấu trúc, hướng dẫn tái sử dụng UI và các mục tiêu tính năng cốt lõi (MVP) cũng như tính năng mở rộng.

---

## 📂 1. Cấu Trúc Thư Mục (Folder Structure)

Dự án tuân theo kiến trúc **ASP.NET Core MVC**. Dưới đây là sơ đồ cấu trúc thư mục thực tế của dự án để bạn dễ hình dung:

```text
TuNhanTamTInh_Ecommerce/
│
├── Controllers/         # Chứa các lớp điều khiển (VD: HomeController.cs, ProductsController.cs)
├── Models/              # Chứa các Entity models (map với Database) và ViewModels
├── DTOs/                # Data Transfer Objects - Dùng cho form Create/Edit (VD: ProductCreateInfo.cs)
├── Helpers/             # Chứa các class hỗ trợ tiện ích dùng chung (VD: SlugHelper.cs)
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
├── AutoMapperProfile.cs # Cấu hình mapping dữ liệu (ví dụ: Entity → DTO)
├── Program.cs           # File cấu hình, khởi chạy ứng dụng và đăng ký các services
├── appsettings.json     # Cấu hình biến môi trường, chuỗi kết nối Database...
├── Dockerfile           # File cấu hình để đóng gói dự án lên Docker
└── HobbyShopScript_schema... # Các file script SQL cấu trúc và dữ liệu mẫu
```

**Chi tiết vai trò của các thành phần chính:**
- **`Controllers/`**: Nơi tiếp nhận Request từ URL, gọi tới Database/Service để xử lý logic, và quyết định trả về View nào.
- **`Models/`**: Dùng để định nghĩa các cấu trúc bảng (Entity) trong Database và các lớp gói dữ liệu giao tiếp với View (ViewModel).
- **`DTOs/`**: Chứa các lớp dữ liệu trung gian (Data Transfer Objects) dùng cho form **Create/Edit** nhằm giảm thiểu rủi ro **overposting**. Ví dụ: `ProductCreateInfo.cs` chỉ chứa các field người dùng được phép nhập, không chứa các field hệ thống như `ProductId`, `ViewCount`.
- **`Helpers/`**: Nơi khai báo các hàm tiện ích dùng nhiều lần như `SlugHelper.GenerateSlug()` để sinh slug từ tên sản phẩm, định dạng tiền tệ, mã hóa mật khẩu, hay các hàm Extension xử lý Session/Cookie.
- **`Views/`**: Chuyên chứa HTML kết hợp mã C# (Razor Syntax). Các file `.cshtml` được chia theo từng Controller.
  - **`_ViewStart.cshtml` trong từng Controller folder**: Thiết lập layout mặc định cho các view của controller đó.
- **`ViewComponents/`**: Cực kỳ quan trọng để tách và tái sử dụng các khối giao diện động (ví dụ: Menu chính, Giỏ hàng thu nhỏ). File `.cs` xử lý logic đặt ở đây, còn giao diện `.cshtml` của nó được đặt trong `Views/Shared/Components/`.
- **`wwwroot/`**: Bất kỳ file nào (CSS, JS, Hình ảnh, Font) muốn truy cập được trực tiếp từ trình duyệt đều phải đặt vào đây.
- **`AutoMapperProfile.cs`**: Chứa cấu hình Map giữa các thực thể (Entity) và DTOs, giúp việc chuyển đổi dữ liệu trở nên đơn giản và dễ dàng bảo trì.

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

Để đạt được Minimum Viable Product (MVP), dự án cần hoàn thiện các chức năng sau theo thứ tự:

1. **Layout Trang Chủ (Homepage):** 
   - **Trạng thái:** Hoàn thành 100%.
   - **Chi tiết:** Đã tích hợp giao diện đồng bộ (màu chủ đạo `#560bad`), kết nối backend qua các ViewComponent (`ProductLatestProducts`) để hiển thị sản phẩm mới nhất, sản phẩm hot theo từng Tab.
2. **Menu Hàng Hóa (Category Menu):**
   - **Trạng thái:** Hoàn thành 100%.
   - **Chi tiết:** Phân cấp danh mục cực kỳ thông minh (Ví dụ: Mô hình lắp ráp -> Gundam -> High Grade) bằng cách tự động quét liên kết ảo qua bảng Products, giữ nguyên schema Database mà vẫn có Menu xổ ngang cực mượt.
3. **Trang Danh Sách Hàng Hóa (Product List):**
   - **Trạng thái:** Hoàn thành 100%.
   - **Chi tiết:** Hiển thị thẻ sản phẩm (Tags Sale, click vào text), hỗ trợ bộ lọc theo khoảng giá, danh mục, phân trang.
4. **Chi Tiết Hàng Hóa (Product Detail):**
   - **Trạng thái:** Hoàn thành 100%.
   - **Chi tiết:** Fix lỗi layout ảnh (object-fit), slider thumbnail đều tăm tắp, hiển thị linh hoạt lưới 4 sản phẩm liên quan.
5. **Thêm Vào Giỏ Hàng (Add to Cart):**
   - Đang phát triển. Xử lý thêm sản phẩm vào giỏ (Sử dụng AJAX để không phải load lại toàn bộ trang).
   - Hiển thị thông báo (Toast notification) khi thêm thành công.
6. **Thông Tin Giỏ Hàng (Cart Detail):**
   - Đang phát triển. Trang xem chi tiết các món hàng đã chọn.
   - Cho phép cập nhật số lượng, xóa sản phẩm khỏi giỏ hàng, tính tổng tiền tạm tính.
7. **Login / Register (Đăng Nhập / Đăng Ký):**
   - **Đánh giá Hướng Tiếp Cận:** Dự án này sẽ theo hướng **Cho phép khách vãng lai (Guest) sử dụng giỏ hàng**.
   - **Lý do:** Đối với E-commerce hiện đại, việc bắt ép tạo tài khoản ngay từ đầu tạo rào cản rất lớn, làm giảm tỉ lệ chuyển đổi. Chúng ta sử dụng **Cookie kết hợp CookieId** để lưu vết giỏ hàng thay vì dùng Session (Sử dụng Session tốn RAM server và làm chậm web).
   - **Xác thực Email (Email Verification):** Vì Database có thuộc tính `IsActive` cho tài khoản, hệ thống sẽ yêu cầu người dùng xác thực Email khi đăng ký. Tài khoản chỉ được cấp quyền mua hàng khi `IsActive = true`.
   - **Luồng xử lý (Flow):**
     1. Khách vãng lai xem sản phẩm -> Bỏ vào giỏ hàng (lưu qua CookieId).
     2. Khách vào trang Giỏ hàng -> Nhấn "Tiến hành Thanh toán".
     3. Hệ thống kiểm tra: Nếu chưa đăng nhập -> Chuyển hướng sang trang Đăng nhập/Đăng ký.
     4. Đăng ký tài khoản mới -> Hệ thống gửi Email chứa mã/link kích hoạt -> Khách click link để `IsActive = true`.
     5. Sau khi đăng nhập thành công -> Tự động hợp nhất (Merge) giỏ hàng từ CookieId của khách vãng lai vào giỏ hàng gắn với AccountID trong Database và cho phép thanh toán.

---

## 🌟 4. Các Tính Năng Đề Xuất Nâng Cao (Sắp xếp theo thứ tự ưu tiên "ăn điểm")

Để biến trang web thành một trang thương mại điện tử Hobby Shop chuyên nghiệp và **đạt điểm số tối đa cho đồ án**, dưới đây là danh sách tổng hợp các tính năng được đề xuất và sắp xếp theo mức độ ưu tiên (từ nhóm ghi điểm kỹ thuật mạnh nhất, đến nhóm tận dụng giao diện có sẵn để mở rộng chức năng):

### 🔥 Ưu Tiên 1: Nhóm Kỹ Thuật Nâng Cao & Core E-commerce (Điểm Giỏi)
Đây là các tính năng chứng minh năng lực kỹ thuật và hiểu biết sâu về luồng hệ thống thương mại điện tử thực tế:
1. **Thanh Toán Trực Tuyến (Payment Gateway):** Tích hợp cổng thanh toán thật như VNPay, Momo, hoặc Stripe. Đây là "vũ khí" cực mạnh để lấy điểm cao đồ án môn Web.
2. **Đăng Nhập Mạng Xã Hội (Google/Facebook OAuth):** Cho phép người dùng đăng nhập/đăng ký nhanh bằng tài khoản **Google** hoặc **Facebook**. ASP.NET Core Identity hỗ trợ rất tốt External Login, giúp hệ thống trông vô cùng chuyên nghiệp.
3. **Quản Lý Đơn Hàng & Tracking (Cho Khách Hàng):** Trang Profile của user cho phép xem lịch sử đơn hàng, tracking trạng thái đơn (Đang xử lý, Đang giao, Đã giao thành công).
4. **Hệ Thống Pre-Order (Đặt hàng trước):** Rất đặc thù của Hobby Shop (vì mô hình thường công bố trước vài tháng). Thêm trạng thái sản phẩm là "Pre-order" kèm "Ngày phát hành dự kiến", cho phép user thanh toán đặt cọc.
5. **Quản Lý Kho Hàng Tồn (Inventory Management):** Tự động trừ số lượng tồn kho khi đơn hàng được thanh toán/xác nhận thành công. Khóa nút "Thêm vào giỏ" nếu sản phẩm đã hết hàng.

### 🎨 Ưu Tiên 2: Nhóm Tận Dụng Template Có Sẵn (Tối Ưu Trải Nghiệm - Dễ Làm)
Nhóm này giúp trang web trông đồ sộ, nhiều chức năng nhưng lại cực kỳ dễ triển khai vì **template Ogani trong `wwwroot/` đã cung cấp sẵn giao diện (UI) 100%**:
6. **✅ [ĐÃ HOÀN THÀNH] Bộ Lọc Tìm Kiếm Nâng Cao & Sắp Xếp:**
   - **Thanh trượt giá (Price Slider):** Đã kết hợp mượt mà `minPrice`, `maxPrice` với LINQ.
   - **Bộ lọc / Phân loại:** Đã lọc thành công theo danh mục (`categoryId`) và series (`seriesId`).
   - **Sắp xếp (Sort By):** Xử lý hoàn thiện các tùy chọn giá tăng/giảm, xem nhiều, mua nhiều.
7. **Hệ Thống Blog / Tin Tức & Review (Tận dụng `blog.html`):** Layout cực đẹp đã có sẵn. Rất thích hợp làm chức năng đăng bài Review đập hộp (Unboxing), thông báo hàng mới để kéo tương tác.
8. **Mã Giảm Giá / Khuyến Mãi (Tận dụng `shoping-cart.html`):** Trong giỏ hàng có sẵn khối **"Discount Codes - Apply Coupon"**. Chỉ cần thêm bảng `Coupon` để xử lý logic trừ tiền/giảm phần trăm.
9. **✅ [ĐÃ HOÀN THÀNH] Sản Phẩm Gợi Ý Cùng Loại:** Đã áp dụng thành công trên trang Chi tiết sản phẩm. Dùng carousel "Related Product" ở cuối trang để hiển thị 4 sản phẩm cùng Category hoặc Series một cách cực kỳ bắt mắt.
10. **Trang Liên Hệ & Bản Đồ (Tận dụng `contact.html`):** Có sẵn form liên hệ và chỗ nhúng Google Maps. Dùng để lưu lời nhắn của khách vào Database (bảng `ContactMessages`).

### 💡 Ưu Tiên 3: Nhóm Điểm Cộng Phụ (Nên Làm Nếu Dư Thời Gian)
11. **Danh Sách Yêu Thích (Wishlist):** Cho phép người dùng đánh dấu/lưu lại các mô hình họ thích để mua sau (Sử dụng Cookie/Session tương tự Giỏ hàng nếu chưa đăng nhập).
12. **Đánh Giá & Nhận Xét (Reviews & Ratings):** User có thể rate sao và bình luận kèm ảnh thật sau khi mua mô hình thành công.
13. **Tìm Kiếm Gợi Ý Trực Tiếp (Live Search AJAX):** Khi gõ tên trên thanh tìm kiếm của Header, danh sách sản phẩm gợi ý sẽ xổ xuống ngay lập tức mà không cần chuyển trang.
14. **So Sánh Sản Phẩm (Compare):** Đặt 2 hoặc 3 mô hình cạnh nhau để so sánh tỉ lệ, giá cả, và thông số chi tiết.
