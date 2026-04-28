# 🚀 Hướng Dẫn Phát Triển Dự Án: Hobby Shop E-commerce

Tài liệu này đóng vai trò là kim chỉ nam cho quá trình phát triển dự án trang web thương mại điện tử chuyên bán đồ chơi mô hình (Hobby Shop). Nội dung bao gồm quy chuẩn cấu trúc, hướng dẫn tái sử dụng UI và các mục tiêu tính năng cốt lõi (MVP) cũng như tính năng mở rộng.

---

## 📂 1. Cấu Trúc Thư Mục (Folder Structure)

Dự án tuân theo kiến trúc **ASP.NET Core MVC**. Dưới đây là sơ đồ cấu trúc thư mục thực tế của dự án để bạn dễ hình dung:

```text
TuNhanTamTInh_Ecommerce/
│
├── Controllers/         # Chứa các lớp điều khiển (VD: HomeController.cs)
├── Models/              # Chứa các Entity models (map với Database) và ViewModels
├── Views/               # Chứa các file giao diện Razor (.cshtml)
│   ├── Home/            # View tương ứng của HomeController
│   ├── Shared/          # Layout chính (_Layout.cshtml) và các Partial View dùng chung
│   ├── _ViewImports.cshtml
│   └── _ViewStart.cshtml
│
├── ViewComponents/      # (Hoặc ViewComponent/) Chứa class logic (.cs) cho các View Component độc lập
│
├── wwwroot/             # Chứa file tĩnh (Public ra ngoài)
│   ├── css/             # Stylesheets (CSS/SASS)
│   ├── js/              # Javascript files
│   ├── images/          # Hình ảnh (hoặc thư mục img)
│   ├── lib/             # Các thư viện bên thứ 3 (Bootstrap, jQuery...)
│   └── (các file HTML template tham khảo như index.html, shop-grid.html...)
│
├── Data/                # Chứa DbContext và cấu hình cấu trúc Entity Framework Core
├── Helpers/             # Chứa các class hỗ trợ tiện ích dùng chung
│
├── AutoMapperProfile.cs # Cấu hình mapping dữ liệu (ví dụ: chuyển Entity thành ViewModel)
├── Program.cs           # File cấu hình, khởi chạy ứng dụng và đăng ký các services
├── appsettings.json     # Cấu hình biến môi trường, chuỗi kết nối Database...
├── Dockerfile           # File cấu hình để đóng gói dự án lên Docker
└── HobbyShopScript_schema... # Các file script SQL cấu trúc và dữ liệu mẫu
```

**Chi tiết vai trò của các thành phần chính:**
- **`Controllers/`**: Nơi tiếp nhận Request từ URL, gọi tới Database/Service để xử lý logic, và quyết định trả về View nào.
- **`Models/`**: Dùng để định nghĩa các cấu trúc bảng (Entity) trong Database và các lớp gói dữ liệu giao tiếp với View (ViewModel).
- **`Views/`**: Chuyên chứa HTML kết hợp mã C# (Razor Syntax). Các file `.cshtml` được chia theo từng Controller.
- **`ViewComponents/`**: Cực kỳ quan trọng để tách và tái sử dụng các khối giao diện động (ví dụ: Menu chính, Giỏ hàng thu nhỏ). File `.cs` xử lý logic đặt ở đây, còn giao diện `.cshtml` của nó được đặt trong `Views/Shared/Components/`.
- **`wwwroot/`**: Bất kỳ file nào (CSS, JS, Hình ảnh, Font) muốn truy cập được trực tiếp từ trình duyệt đều phải đặt vào đây.
- **`Helpers/`**: Nơi khai báo các hàm tiện ích dùng nhiều lần như định dạng tiền tệ, mã hóa mật khẩu, hay các hàm Extension xử lý Session/Cookie.

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
   - Hiện tại (80%): Đang dùng layout template cũ. 
   - **Mục tiêu:** Cải tiến UI/UX sang thiết kế độc quyền, phù hợp với một "Hobby Shop" (hiển thị banner sự kiện, series nổi bật như Gundam, Figure). Kết nối backend để hiển thị sản phẩm mới nhất, sản phẩm hot.
2. **Menu Hàng Hóa (Category Menu):**
   - Phân cấp danh mục (Ví dụ: Mô hình lắp ráp -> Gundam -> High Grade).
   - **Lưu ý:** Bắt buộc dùng **View Component** để render để không phải truy vấn lại dữ liệu ở mọi Controller.
3. **Trang Danh Sách Hàng Hóa (Product List):**
   - Hiển thị danh sách sản phẩm theo danh mục.
   - Hỗ trợ phân trang (Pagination).
4. **Chi Tiết Hàng Hóa (Product Detail):**
   - Hiển thị đầy đủ thông tin: Ảnh (có thể là slide nhiều ảnh), Tên, Giá, Series, Tỉ lệ (Scale), Tình trạng kho, Mô tả chi tiết.
5. **Thêm Vào Giỏ Hàng (Add to Cart):**
   - Xử lý thêm sản phẩm vào giỏ (Sử dụng AJAX để không phải load lại toàn bộ trang).
   - Hiển thị thông báo (Toast notification) khi thêm thành công.
6. **Thông Tin Giỏ Hàng (Cart Detail):**
   - Trang xem chi tiết các món hàng đã chọn.
   - Cho phép cập nhật số lượng, xóa sản phẩm khỏi giỏ hàng.
   - Tính tổng tiền tạm tính.
7. **Login / Register (Đăng Nhập / Đăng Ký):**
   - **Đánh giá Hướng Tiếp Cận:** Dự án này sẽ theo hướng **Cho phép khách vãng lai (Guest) sử dụng giỏ hàng**.
   - **Lý do:** Đối với E-commerce hiện đại, việc bắt ép tạo tài khoản ngay từ đầu tạo rào cản rất lớn, làm giảm tỉ lệ chuyển đổi (Conversion Rate). Việc lưu giỏ hàng vào Session (hoặc Cookie) cho khách vãng lai mang lại trải nghiệm tốt nhất.
   - **Luồng xử lý (Flow):**
     1. Khách vãng lai xem sản phẩm -> Bỏ vào giỏ hàng (lưu Session).
     2. Khách vào trang Giỏ hàng -> Nhấn "Tiến hành Thanh toán".
     3. Hệ thống kiểm tra: Nếu chưa đăng nhập -> Chuyển hướng sang trang Đăng nhập/Đăng ký.
     4. Sau khi đăng nhập thành công -> Tự động hợp nhất (Merge) giỏ hàng trong Session vào giỏ hàng của Database (nếu cần) và cho phép tiếp tục tới bước thanh toán.

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
6. **Bộ Lọc Tìm Kiếm Nâng Cao & Sắp Xếp (Tận dụng `shop-grid.html`):**
   - **Thanh trượt giá (Price Slider):** Template đã có sẵn thanh kéo UI, chỉ cần truyền tham số về Controller để truy vấn.
   - **Bộ lọc Size / Color ➡️ Tỉ lệ / Dòng:** Tận dụng tag Color/Size có sẵn để đổi chữ thành lọc theo Tỉ lệ (Scale: 1/144, 1/100) hoặc Hãng sản xuất.
   - **Sắp xếp (Sort By):** Dùng dropdown "Sort By" có sẵn để sắp xếp theo Giá hoặc Mới nhất.
7. **Hệ Thống Blog / Tin Tức & Review (Tận dụng `blog.html`):** Layout cực đẹp đã có sẵn. Rất thích hợp làm chức năng đăng bài Review đập hộp (Unboxing), thông báo hàng mới để kéo tương tác.
8. **Mã Giảm Giá / Khuyến Mãi (Tận dụng `shoping-cart.html`):** Trong giỏ hàng có sẵn khối **"Discount Codes - Apply Coupon"**. Chỉ cần thêm bảng `Coupon` để xử lý logic trừ tiền/giảm phần trăm.
9. **Sản Phẩm Gợi Ý Cùng Loại (Tận dụng `shop-details.html`):** Dùng carousel "Related Product" ở cuối trang chi tiết để hiển thị các sản phẩm cùng Series bằng truy vấn LINQ đơn giản.
10. **Trang Liên Hệ & Bản Đồ (Tận dụng `contact.html`):** Có sẵn form liên hệ và chỗ nhúng Google Maps. Dùng để lưu lời nhắn của khách vào Database (bảng `ContactMessages`).

### 💡 Ưu Tiên 3: Nhóm Điểm Cộng Phụ (Nên Làm Nếu Dư Thời Gian)
11. **Danh Sách Yêu Thích (Wishlist):** Cho phép người dùng đánh dấu/lưu lại các mô hình họ thích để mua sau.
12. **Đánh Giá & Nhận Xét (Reviews & Ratings):** User có thể rate sao và bình luận kèm ảnh thật sau khi mua mô hình thành công.
13. **Tìm Kiếm Gợi Ý Trực Tiếp (Live Search AJAX):** Khi gõ tên trên thanh tìm kiếm, danh sách sản phẩm gợi ý sẽ xổ xuống ngay lập tức mà không cần chuyển trang.
