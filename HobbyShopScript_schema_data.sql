USE Ecommerce_Hobby_Shop
GO

-----------------------------------------------------------
-- 1. TÀI KHOẢN & PHÂN QUYỀN
-----------------------------------------------------------
INSERT INTO [dbo].[Roles] (RoleID, RoleName) VALUES 
(0, N'Khách hàng'), 
(1, N'Quản trị viên');
GO

INSERT INTO [dbo].[Accounts] (AccountID, Password, FullName, Email, PhoneNumber, Address, Gender, IsActive, RoleID) VALUES
(N'admin', N'admin123', N'Quản trị viên hệ thống', N'admin@hobbyshop.com', N'0123456789', N'Biên Hòa, Đồng Nai', 1, 1, 1),
(N'customer1', N'cust123', N'Nguyễn Văn A', N'nva@gmail.com', N'0987654321', N'TP. Hồ Chí Minh', 1, 1, 0),
(N'customer2', N'cust123', N'Trần Thị B', N'ttb@gmail.com', N'0912345678', N'Đà Nẵng', 0, 1, 0);
GO

-----------------------------------------------------------
-- 2. DANH MỤC, SERIES, NHÀ CUNG CẤP
-----------------------------------------------------------
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] (CategoryID, CategoryName, CategorySlug, Image) VALUES 
(1, N'Mô hình xe', N'cars', N'~/images/Categories/cars.png'),
(2, N'Gundam', N'gundam', N'~/images/Categories/gundam.png'),
(3, N'Figure', N'figure', N'~/images/Categories/figure.png'),
(4, N'Dụng cụ', N'tools', N'~/images/Categories/tools.png'),
(5, N'Khác', N'others', N'~/images/Categories/others.png');
SET IDENTITY_INSERT [dbo].[Categories] OFF;
GO

SET IDENTITY_INSERT [dbo].[Series] ON;
INSERT INTO [dbo].[Series] (SeriesID, SeriesName, Description) VALUES
(1, N'High Grade (HG)', N'Mô hình lắp ráp tỷ lệ 1/144.'),
(2, N'Master Grade (MG)', N'Mô hình lắp ráp tỷ lệ 1/100 có chi tiết khung xương.'),
(3, N'Perfect Grade (PG)', N'Mô hình lắp ráp tỷ lệ 1/60 cao cấp và siêu chi tiết.'),
(4, N'Real Grade (RG)', N'Mô hình lắp ráp tỷ lệ 1/144 có khung xương độ chi tiết cao.'),
(5, N'Master Grade Extreme (MGEX)', N'Mô hình lắp ráp tỷ lệ 1/100 phiên bản cực kỳ cao cấp.'),
(6, N'1/64 Scale Cars', N'Mô hình xe kim loại cỡ nhỏ.'),
(7, N'1/18 Scale Cars', N'Mô hình tĩnh tĩnh cỡ lớn (Diecast / Resin) chi tiết cao.'),
(8, N'Action & Chibi', N'Mô hình nhân vật cử động linh hoạt và Nendoroid.'),
(9, N'Scale Figure', N'Mô hình tĩnh tỷ lệ chất lượng cao.'),
(10, N'Hobby Tools', N'Dụng cụ chuyên dụng để lắp ráp và sơn mô hình.');
SET IDENTITY_INSERT [dbo].[Series] OFF;
GO

INSERT INTO [dbo].[Suppliers] (SupplierID, CompanyName, Logo) VALUES
(N'BANDAI', N'Bandai Namco', N'~/images/Suppliers/Bandai.webp'),
(N'SNAA', N'SNAA', N'~/images/Suppliers/SNAA.webp'),
(N'AUTOART', N'AUTOart Models', N'~/images/Suppliers/AutoArt.webp'),
(N'SPARK', N'Spark Models', N'~/images/Suppliers/Spark.webp'),
(N'MINIGT', N'Mini GT', N'~/images/Suppliers/MiniGT.webp'),
(N'GSC', N'Good Smile Company', N'~/images/Suppliers/GSC.webp'),
(N'ALTER', N'Alter', N'~/images/Suppliers/Alter.webp'),
(N'TAMIYA', N'Tamiya', N'~/images/Suppliers/Tamiya.webp'),
(N'MRHOBBY', N'Mr. Hobby', N'~/images/Suppliers/MrHobby.webp'),
(N'DSPIAE', N'DSPIAE', N'~/images/Suppliers/DSPIAE.webp'),
(N'MAXFACTORY', N'Max Factory', N'~/images/Suppliers/Max-Factory.webp'),
(N'ANIPLEX', N'Aniplex', N'~/images/Suppliers/Aniplex.webp'),
(N'APEXTOYS', N'Apex-Toys', N'~/images/Suppliers/Apex-Toys.png'),
(N'ESTREAM', N'eStream / Shibuya Scramble', N'~/images/Suppliers/Estream.webp'),
(N'ESPADA', N'Espada Art', N'~/images/Suppliers/Espada.webp'),
(N'UNION', N'Union Creative', N'~/images/Suppliers/Union-Creative.webp'),
(N'KADOKAWA', N'Kadokawa', N'~/images/Suppliers/Kadokawa.webp'),
(N'FLARE', N'Flare', N'~/images/Suppliers/Flare.webp'),
(N'MIHOYO', N'miHoYo', N'~/images/Suppliers/miHoYo.webp'),
(N'KOTO', N'Kotobukiya', N'~/images/Suppliers/Kotobukiya.webp'),
(N'FREEING', N'FREEing', N'~/images/Suppliers/FREEing.webp'),
(N'OTHER', N'Khác (Other)', N'~/images/Suppliers/Other.png');
GO

-----------------------------------------------------------
-- 3. SẢN PHẨM & HÌNH ẢNH
-----------------------------------------------------------
SET IDENTITY_INSERT [dbo].[Products] ON;
INSERT INTO [dbo].[Products] (ProductID, ProductName, ProductSlug, CategoryID, SeriesID, SupplierID, UnitPrice, Description, Discount, ViewCount, StockQuantity) VALUES
(1, N'Aston Martin AMR24 #14 Fernando Alonso', N'aston-martin-amr24-14-fernando-alonso', 1, 7, N'SPARK', 4500000, N'Mô hình xe F1 tỷ lệ 1/18 Aston Martin AMR24 #14 do Fernando Alonso cầm lái tại giải đua Công thức 1. Tái tạo chân thực các khe tản nhiệt và bộ khí động học phức tạp.', 0, 250, 48),
(2, N'Aston Martin DBS Stratus White', N'aston-martin-dbs-stratus-white', 1, 7, N'AUTOART', 3500000, N'Siêu xe thể thao Aston Martin DBS màu trắng Stratus White tỷ lệ 1/18. Trang bị động cơ V12 chi tiết, nội thất bọc da mô phỏng cực kỳ sắc sảo.', 0, 182, 13),
(3, N'Aston Martin Valkyrie Racing Green', N'aston-martin-valkyrie-racing-green', 1, 7, N'AUTOART', 6200000, N'Hypercar Aston Martin Valkyrie màu xanh Racing Green tỷ lệ 1/18. Thân vỏ làm từ Resin cao cấp, tái tạo hoàn hảo các luồng khí động học bên dưới gầm xe.', 0, 293, 5),
(4, N'BMW M4 CSL Frozen Brooklyn Grey', N'bmw-m4-csl-frozen-brooklyn-grey', 1, 7, N'OTHER', 3200000, N'Mẫu xe hiệu suất cao BMW M4 CSL màu xám nhám Frozen Brooklyn Grey tỷ lệ 1/18. Lưới tản nhiệt mũi to đặc trưng và các điểm nhấn carbon đỏ.', 0, 6, 28),
(5, N'BMW M4 GT3 EVO #90 Team AAI', N'bmw-m4-gt3-evo-90-team-aai', 1, 7, N'SPARK', 4800000, N'Xe đua chuyên dụng BMW M4 GT3 EVO số 90 của đội Team AAI. Phủ kín decal tài trợ, trang bị cánh gió khổng lồ đuôi xe.', 0, 223, 15),
(6, N'BMW M5 Isle of Man Green', N'bmw-m5-isle-of-man-green', 1, 7, N'OTHER', 3100000, N'Mẫu sedan hiệu năng cao BMW M5 màu xanh lục Isle of Man Green. Nước sơn bóng loáng, nội thất chi tiết với các nút bấm trên vô lăng.', 0, 439, 27),
(7, N'Bugatti Bolide Red', N'bugatti-bolide-red', 1, 7, N'OTHER', 7500000, N'Quái thú đường đua Bugatti Bolide tỷ lệ 1/18 màu đỏ đen. Thiết kế mâm xe tản nhiệt hình chữ X ấn tượng.', 0, 35, 19),
(8, N'Bugatti Chiron Super Sport Gold', N'bugatti-chiron-super-sport-gold', 1, 7, N'AUTOART', 6800000, N'Bugatti Chiron Super Sport phiên bản màu vàng Gold đặc biệt. Động cơ W16 phô diễn chi tiết bên dưới nắp kính phía sau.', 0, 483, 8),
(9, N'Bugatti Divo White', N'bugatti-divo-white', 1, 7, N'OTHER', 6500000, N'Siêu phẩm hypercar giới hạn Bugatti Divo màu trắng với các đường viền xanh dương. Hệ thống đèn hậu đa khối 3D cực kỳ đẹp mắt.', 0, 262, 35),
(10, N'Ford GT #85 Le Mans 2019', N'ford-gt-85-le-mans-2019', 1, 7, N'AUTOART', 4200000, N'Ford GT xe đua số 85 từng tham gia giải Le Mans 24h 2019 hạng LM GTE-Am. Livery Keating Motorsports rực rỡ.', 0, 419, 49),
(11, N'Ford Mustang GTD America 25', N'ford-mustang-gtd-america-25', 1, 7, N'SPARK', 3900000, N'Phiên bản đường phố đỉnh cao nhất của Mustang - GTD. Thiết kế khí động học siêu hầm hố, cánh gió treo ngược độc đáo.', 0, 122, 5),
(12, N'Ford Puma Rally1 #13 M-Sport', N'ford-puma-rally1-13-m-sport', 1, 7, N'SPARK', 4100000, N'Xe đua Rally chuyên nghiệp Ford Puma Rally1 số 13 đội M-Sport mùa giải 2024. Phủ lấm tấm bùn đất cực thực tế.', 0, 451, 11),
(13, N'Honda Civic Type R Ultimate Edition', N'honda-civic-type-r-ultimate-edition', 1, 7, N'AUTOART', 2500000, N'Huyền thoại đường phố Honda Civic Type R. Màu sơn trắng Championship White, mâm đen và cùm phanh Brembo đỏ nổi bật.', 0, 470, 15),
(14, N'Honda NS-X Prototype Ayrton Senna', N'honda-ns-x-prototype-ayrton-senna', 1, 7, N'AUTOART', 5500000, N'Honda NS-X Prototype màu trắng huyền thoại đi kèm mô hình figure tay đua Ayrton Senna. Khắc họa chính xác lịch sử thử nghiệm xe.', 0, 252, 28),
(15, N'Honda S2000 (AP2) CR Grand Prix White', N'honda-s2000-ap2-cr-grand-prix-white', 1, 7, N'AUTOART', 2800000, N'Xe thể thao mui trần Honda S2000 bản Club Racer màu trắng. Tái hiện lại bộ mâm 5 chấu và cánh gió đuôi đặc trưng.', 0, 86, 37),
(16, N'Lamborghini Aventador SVJ 63', N'lamborghini-aventador-svj-63', 1, 7, N'AUTOART', 5800000, N'Siêu bò Lamborghini Aventador SVJ bản giới hạn 63 màu trắng Bianco Asopo. Mâm xe trung tâm, ống xả trên cao.', 0, 217, 24),
(17, N'Lamborghini Huracan GT3 EVO2 #63', N'lamborghini-huracan-gt3-evo2-63', 1, 7, N'SPARK', 5100000, N'Xe đua Huracán GT3 EVO2 đội Iron Lynx tham gia Daytona 24h. Cụm đèn pha LED lục giác và cánh chia gió cực gắt.', 0, 251, 42),
(18, N'Lamborghini Revuelto Giallo', N'lamborghini-revuelto-giallo', 1, 7, N'AUTOART', 5400000, N'Mẫu xe kế nhiệm Aventador: Lamborghini Revuelto màu vàng Giallo rực rỡ. Động cơ V12 hybrid phô ra qua khoang sau.', 0, 301, 50),
(19, N'Mazda AZ-1 Liberty Walk', N'mazda-az-1-liberty-walk', 1, 7, N'OTHER', 2100000, N'Mẫu Kei-car thể thao Mazda AZ-1 mang gói độ thân rộng Liberty Walk LB40. Chi tiết ốc vít trên vòm bánh xe rất chân thực.', 0, 189, 9),
(20, N'Mazda Miata MX-5 (NA) Sunburst Yellow', N'mazda-miata-mx-5-na-sunburst-yellow', 1, 7, N'AUTOART', 1800000, N'Chiếc Miata thế hệ đầu (NA) màu vàng Sunburst. Đặc trưng với cụm đèn pha mắt ếch pop-up siêu đáng yêu.', 0, 382, 44),
(21, N'Mazda RX-7 RE-Amemiya Silver', N'mazda-rx-7-re-amemiya-silver', 1, 7, N'OTHER', 2900000, N'Huyền thoại JDM Mazda RX-7 mang gói độ lừng danh RE-Amemiya. Màu bạc kim loại bóng bẩy, thân rộng khí động học.', 0, 122, 50),
(22, N'McLaren 720S GT3 Evo Pfaff Motorsports', N'mclaren-720s-gt3-evo-pfaff-motorsports', 1, 7, N'AUTOART', 4900000, N'Xe đua McLaren 720S GT3 Evo mang họa tiết sọc ca-rô nổi tiếng của Pfaff Motorsports. Đậm chất xe đua IMSA.', 0, 73, 52),
(23, N'McLaren F1 Yquem', N'mclaren-f1-yquem', 1, 7, N'SPARK', 8500000, N'Chiếc McLaren F1 màu cam Yquem cực độc đáo. Ghế lái nằm chính giữa trung tâm xe đặc trưng, các chi tiết khoang máy lót vàng mỏng.', 0, 479, 39),
(24, N'McLaren MCL38 #81 Oscar Piastri', N'mclaren-mcl38-81-oscar-piastri', 1, 7, N'SPARK', 4600000, N'Xe công thức 1 McLaren MCL38 do Oscar Piastri điều khiển đem về chiến thắng Hungarian GP 2024.', 0, 170, 46),
(25, N'Nissan GT-R NISMO GT3 #23', N'nissan-gt-r-nismo-gt3-23', 1, 7, N'AUTOART', 4300000, N'Nissan GT-R xe đua FIA GT3 số 23 đội KCMG từng tham dự Macau Grand Prix. Tái hiện các khe hút gió và tem tài trợ dán quanh xe.', 0, 367, 22),
(26, N'Nissan Skyline GT-R (R34) V-Spec II', N'nissan-skyline-gt-r-r34-v-spec-ii', 1, 7, N'AUTOART', 3800000, N'Ông hoàng đường phố Nissan Skyline GT-R R34 bản V-Spec II màu xanh Bayside Blue. Mâm xe đồng thau 6 chấu kép.', 0, 47, 52),
(27, N'Nissan Z Pandem Seiran Blue', N'nissan-z-pandem-seiran-blue', 1, 7, N'OTHER', 2600000, N'Mẫu Nissan Z thế hệ mới độ thân rộng Pandem hầm hố. Màu xanh dương Seiran kết hợp mâm xe deep-dish viền crôm.', 0, 176, 9),
(28, N'Pagani Huayra Roadster Black', N'pagani-huayra-roadster-black', 1, 7, N'AUTOART', 6900000, N'Pagani Huayra Roadster mui trần, màu sợi carbon đen toàn thân. Nội thất da đỏ lộng lẫy và khoang động cơ đậm chất nghệ thuật.', 0, 498, 47),
(29, N'Pagani Zonda F Rosso Dubai', N'pagani-zonda-f-rosso-dubai', 1, 7, N'AUTOART', 7100000, N'Pagani Zonda F phiên bản màu đỏ bóng pha sợi carbon Rosso Dubai. Ống xả 4 nòng titan đặc trưng của Pagani.', 0, 417, 23),
(30, N'Pagani Zonda F Silver', N'pagani-zonda-f-silver', 1, 7, N'AUTOART', 7100000, N'Siêu xe Pagani Zonda F màu bạc mâm bạc nguyên bản. Phản chiếu ánh sáng lấp lánh ở mọi góc độ.', 0, 438, 10),
(31, N'Porsche 911 (992) GT3 RS Guards Red', N'porsche-911-992-gt3-rs-guards-red', 1, 7, N'AUTOART', 4500000, N'Quái thú track-day Porsche 911 GT3 RS (thế hệ 992) màu đỏ Guards Red. Gói Weissach Package mâm magie và cánh gió siêu lớn tích hợp DRS.', 0, 276, 5),
(32, N'Porsche 911 GT3 R #77 AO Racing', N'porsche-911-gt3-r-77-ao-racing', 1, 7, N'SPARK', 5200000, N'Xe đua Porsche 911 GT3 R mang livery "Rexy" khủng long T-Rex xanh lá nổi đình đám của đội AO Racing.', 0, 247, 52),
(33, N'Porsche 911 (991) GT2 RS Miami Blue', N'porsche-911-991-gt2-rs-miami-blue', 1, 7, N'AUTOART', 4800000, N'Cỗ máy tốc độ 911 GT2 RS (thế hệ 991) màu xanh dương Miami Blue. Trang bị gói Weissach Package với nắp capo sợi carbon.', 0, 58, 32),
(34, N'Toyota GR86 LB Nation Black/Gold', N'toyota-gr86-lb-nation-blackgold', 1, 7, N'OTHER', 2400000, N'Toyota GR86 độ thân rộng Liberty Walk mang màu đen chỉ vàng cuốn hút. Hệ thống treo hạ gầm sát đất.', 0, 369, 8),
(35, N'Toyota GR Supra HKS Renaissance Red', N'toyota-gr-supra-hks-renaissance-red', 1, 7, N'OTHER', 2700000, N'Toyota GR Supra được HKS tinh chỉnh mang màu đỏ Renaissance Red rực rỡ, trang bị mâm xe thể thao và cánh gió đuôi liền.', 0, 201, 12),
(36, N'Toyota Supra (A80) Top Secret Gold', N'toyota-supra-a80-top-secret-gold', 1, 7, N'OTHER', 3300000, N'Huyền thoại Toyota Supra A80 với gói độ V12 Top Secret màu vàng. Từng chạm ngưỡng tốc độ 300km/h trên cao tốc.', 0, 441, 8),
(37, N'XVX-016 Gundam Aerial HG 1/144', N'xvx-016-gundam-aerial-hg-1144', 2, 1, N'BANDAI', 350000, N'Mô hình lắp ráp XVX-016 Gundam Aerial tỷ lệ 1/144 HG từ series The Witch from Mercury. Trang bị khiên Escutcheon có thể tách thành 11 mũi GUND-Bits điều khiển từ xa. Cử động cực kì linh hoạt ở các khớp háng và vai.', 0, 329, 44),
(38, N'XVX-016RN Gundam Aerial Rebuild HG 1/144', N'xvx-016rn-gundam-aerial-rebuild-hg-1144', 2, 1, N'BANDAI', 450000, N'Mô hình XVX-016RN Gundam Aerial Rebuild 1/144 HG. Bản nâng cấp hỏa lực với khẩu súng Beam Rifle cỡ lớn có thể kết hợp cùng GUND-Bits tạo thành vũ khí hủy diệt diện rộng. Các chi tiết khung trong được cải tiến.', 0, 110, 32),
(39, N'MBF-P02 Gundam Astray Red Frame PG 1/60', N'mbf-p02-gundam-astray-red-frame-pg-160', 2, 3, N'BANDAI', 4500000, N'MBF-P02 Gundam Astray Red Frame tỷ lệ 1/60 Perfect Grade cực lớn (cao ~30cm). Nổi bật với hệ khung xương màu đỏ siêu chi tiết, các ngón tay cử động được độc lập. Đi kèm thanh Katana "Gerbera Straight" mạ crôm bóng loáng sắc nét.', 0, 144, 13),
(40, N'ASW-G-08 Gundam Barbatos Lupus FM 1/100', N'asw-g-08-gundam-barbatos-lupus-fm-1100', 2, 2, N'BANDAI', 850000, N'Mô hình ASW-G-08 Gundam Barbatos Lupus tỷ lệ 1/100 (Full Mechanics). Sở hữu bộ khung Gundam Frame chi tiết ở ngực và chân. Vũ khí đi kèm là thanh Sword Mace cực kỳ hầm hố, tái hiện hoàn hảo ác quỷ đến từ Tekkadan.', 0, 323, 26),
(41, N'Divine Invoker Percival (Deluxe Edition) 1/100', N'divine-invoker-percival-deluxe-edition-1100', 2, 2, N'BANDAI', 1200000, N'Mô hình mecha thứ 3rd-party Divine Invoker Percival bản Deluxe tỷ lệ 1/100. Kèm vô số trang bị, phễu funnel, đao kiếm và part hiệu ứng ánh sáng. Khung xương chắc chắn chịu lực tốt.', 0, 3, 10),
(42, N'RX-0 Full Armor Unicorn Gundam RG 1/144', N'rx-0-full-armor-unicorn-gundam-rg-1144', 2, 4, N'BANDAI', 1600000, N'RX-0 Full Armor Unicorn Gundam 1/144 Real Grade. Trang bị khung xương Advanced MS Joint cho phép biến hình qua lại giữa Unicorn Mode và Destroy Mode. Kho vũ khí khổng lồ gắn đầy trên lưng và khiên tay.', 0, 101, 31),
(43, N'Firelord Awakening Armament 1/100', N'firelord-awakening-armament-1100', 2, 2, N'BANDAI', 1100000, N'Mô hình mecha Firelord Awakening Armament tỷ lệ 1/100. Kiểu dáng sắc sảo, đi kèm một thanh cự kiếm năng lượng và hệ thống cánh hỏa tiễn phía sau lưng. Decal nước dạ quang tinh tế.', 0, 5, 38),
(44, N'ZGMF-X56S/α Force Impulse Gundam Spec II RG 1/144', N'zgmf-x56s-force-impulse-gundam-spec-ii-rg-1144', 2, 4, N'BANDAI', 850000, N'ZGMF-X56S/α Force Impulse Gundam Spec II 1/144 RG (Màu mới từ movie SEED Freedom). Hệ thống tách lắp Core Splendor, Chest Flyer và Leg Flyer hoạt động trơn tru mà không làm mất đi độ vững chắc của khớp.', 0, 338, 43),
(45, N'ZGMF-X20A Strike Freedom Gundam MGEX 1/100', N'zgmf-x20a-strike-freedom-gundam-mgex-1100', 2, 5, N'BANDAI', 3800000, N'ZGMF-X20A Strike Freedom Gundam 1/100 MGEX (Master Grade Extreme). Đỉnh cao của Bandai với hệ khung xương được kết hợp từ 3 lớp mạ vàng (Gold Coating) khác nhau. Biên độ cử động đạt mức hoàn hảo để pose dáng bắn súng liên thanh.', 0, 199, 27),
(46, N'GF13-017NJ II God Gundam RG 1/144', N'gf13-017nj-ii-god-gundam-rg-1144', 2, 4, N'BANDAI', 850000, N'GF13-017NJ II God Gundam 1/144 RG từ G Gundam. Được mệnh danh là "ông vua tạo dáng" với các khớp vai và háng mới, cho phép thực hiện tư thế vắt chéo chân hoặc tung cú đấm Bakunetsu God Finger đặc trưng.', 0, 497, 47),
(47, N'gMS-Ω GQuuuuuuX HG 1/144', N'gms-gquuuuuux-hg-1144', 2, 1, N'BANDAI', 500000, N'Mô hình gMS-Ω GQuuuuuuX tỷ lệ 1/144 HG (từ vũ trụ Gundam GQuuuuuuX). Mang thiết kế hình dáng rất dị biệt cùng khoang lái hở độc đáo, các dải cảm biến uốn lượn trải dọc cơ thể.', 0, 320, 30),
(48, N'RX-78-2 Gundam [Beyond Global] HG 1/144', N'rx-78-2-gundam-beyond-global-hg-1144', 2, 1, N'BANDAI', 450000, N'RX-78-2 Gundam bản Beyond Global kỷ niệm 40 năm. Tái cấu trúc hoàn toàn tỷ lệ cơ thể với phần đùi thon gọn và tay dài, mang lại vẻ thanh thoát và khả năng cử động siêu việt.', 0, 459, 20),
(49, N'RX-78-2 Gundam PG Unleashed 1/60', N'rx-78-2-gundam-pg-unleashed-160', 2, 3, N'BANDAI', 5000000, N'Mô hình 1/60 PG Unleashed RX-78-2. Trải nghiệm lắp ráp chia làm 5 giai đoạn từ khung xương đến lớp giáp ngoài. Hệ thống đèn LED đổi màu cực sáng ở mắt, ngực và beam saber. Đóng mở giáp toàn thân.', 0, 191, 5),
(50, N'RX-93 v Gundam (Nu Gundam) 1/60', N'rx-93-v-gundam-nu-gundam-160', 2, 3, N'BANDAI', 6500000, N'Mô hình RX-93 v Gundam siêu lớn (1/60). Trang bị đầy đủ 6 ống Fin Funnel gắn trên lưng, chi tiết áo giáp được phân mảng màu phức tạp, kèm theo hệ thống giá đỡ cực kì chắc chắn.', 0, 247, 22),
(51, N'XXXG-00W0 Wing Gundam Zero EW Ver.Ka MG 1/100', N'xxxg-00w0-wing-gundam-zero-ew-verka-mg-1100', 2, 2, N'BANDAI', 1500000, N'XXXG-00W0 Wing Gundam Zero Custom (Endless Waltz) Ver.Ka 1/100 MG. Đôi cánh thiên thần được thiết kế lại bởi Hajime Katoki với khả năng mở rộng như giấu vũ khí. Biến hình thành dạng Neo-Bird Mode.', 0, 422, 30),
(52, N'MSZ-006 Zeta Gundam RG 1/144', N'msz-006-zeta-gundam-rg-1144', 2, 4, N'BANDAI', 750000, N'MSZ-006 Zeta Gundam 1/144 RG. Một kỳ quan kỹ thuật của Bandai ở tỷ lệ nhỏ khi cho phép biến hình hoàn toàn sang phi thuyền Waverider mà không cần tháo rời bất kì part nào.', 0, 65, 5),
(53, N'Action Figure Eren Yeager', N'action-figure-eren-yeager', 3, 8, N'BANDAI', 1600000, N'- Loại mô hình: Action Figure.
- Chiều cao: Khoảng 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Hệ thống khớp siêu linh hoạt.
- Phụ kiện: Các bộ phận thay thế và part hiệu ứng.', 0, 23, 20),
(54, N'Nendoroid Gawr Gura', N'nendoroid-gawr-gura', 3, 8, N'GSC', 1600000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Thiết kế mũ cá mập có thể tháo rời. Khớp nối chắc chắn.
- Phụ kiện: Đinh ba, thú cưng Bloop, các khuôn mặt thay thế (cười, há miệng cá mập).', 0, 15, 45),
(55, N'Figma Levi Ackerman', N'figma-levi-ackerman', 3, 8, N'MAXFACTORY', 1800000, N'- Loại mô hình: Action Figure (Figma).
- Tỷ lệ: Cao khoảng 14-15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Cấu trúc khớp nối figma độc quyền giúp giữ dáng rất cứng cáp.
- Phụ kiện: Bộ thiết bị cơ động 3D chi tiết, áo choàng, tay và mặt thay thế.', 0, 147, 8),
(56, N'Nendoroid Link (Breath of the Wild)', N'nendoroid-link-breath-of-the-wild', 3, 8, N'GSC', 1300000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Cử động linh hoạt ở các khớp vai, háng. Sơn nhám mờ đẹp mắt.
- Phụ kiện: Cung tên, mũi tên cổ đại, khiên Hylian, thanh gươm Master Sword.', 0, 309, 11),
(57, N'S.H.Figuarts Luffy (Onigashima)', N'shfiguarts-luffy-onigashima', 3, 8, N'BANDAI', 1100000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 14.5cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Biên độ cử động cực lớn nhờ khớp vai dạng bướm và khớp hông cải tiến. Có thể tạo dáng hành động dễ dàng.
- Phụ kiện: Các bàn tay thay thế, khuôn mặt biểu cảm khác nhau.', 0, 296, 33),
(58, N'Chibi Makima (Chainsaw Man)', N'chibi-makima-chainsaw-man', 3, 8, N'MAXFACTORY', 2600000, N'- Loại mô hình: Action Figure Chibi.
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Sơn hoàn thiện sắc nét, thể hiện đúng phong thái điềm tĩnh của nhân vật.
- Phụ kiện: 3 biểu cảm khuôn mặt, tay tạo dáng hình khẩu súng.', 0, 43, 11),
(59, N'Nendoroid Naruto Uzumaki', N'nendoroid-naruto-uzumaki', 3, 8, N'GSC', 1100000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Thiết kế tỷ lệ đầu to dễ thương nhưng vẫn rất năng động.
- Phụ kiện: Bàn tay thay thế, khuôn mặt, phi tiêu kunai và part hiệu ứng Rasengan.', 0, 208, 39),
(60, N'Nendoroid Power (Chainsaw Man)', N'nendoroid-power-chainsaw-man', 3, 8, N'GSC', 1500000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Mô phỏng hoàn hảo các chi tiết sừng trên đầu. Khớp cổ linh hoạt.
- Phụ kiện: Búa máu khổng lồ, mèo Meowy, tay và mặt thay thế.', 0, 497, 42),
(61, N'S.H.Figuarts Kyojuro Rengoku', N'shfiguarts-kyojuro-rengoku', 3, 8, N'ANIPLEX', 2500000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Áo choàng có khớp nối rời, hỗ trợ tạo hiệu ứng gió bay.
- Phụ kiện: Nhật luân kiếm (Nichirin Sword), mặt thay thế, các part bàn tay.', 0, 388, 48),
(62, N'S.H.Figuarts Spider-Man (No Way Home)', N'shfiguarts-spider-man-no-way-home', 3, 8, N'BANDAI', 2400000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Cấu trúc khớp cơ thể siêu linh hoạt, tối ưu cho các tư thế đu người, nhện bò sát sàn.
- Phụ kiện: Sợi tơ nhện (ngắn/dài), mắt thay thế, bàn tay tạo dáng.', 0, 422, 31),
(63, N'S.H.Figuarts Sasuke Uchiha', N'shfiguarts-sasuke-uchiha', 3, 8, N'MAXFACTORY', 1700000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 14.5cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Trang phục được đúc mềm giúp không cản trở biên độ khớp gối.
- Phụ kiện: Kiếm Kusanagi (trong bao và rút ra), mặt Sharingan/Rinnegan, part hiệu ứng Chidori.', 0, 254, 24),
(64, N'Nendoroid Yor Forger', N'nendoroid-yor-forger', 3, 8, N'GSC', 1500000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Sơn kim loại nổi bật trên các phụ kiện ám khí.
- Phụ kiện: Trâm ám sát màu vàng, các khuôn mặt đỏ mặt/chiến đấu.', 0, 58, 45),
(65, N'Scale Figure 1/4 2B (YoRHa No.2 Type B)', N'scale-figure-14-2b-yorha-no2-type-b', 3, 9, N'FLARE', 7000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/4 (Chiều cao siêu khủng).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Không có khớp nối, tập trung vào độ sắc nét và điêu khắc trang phục chi tiết. Thanh kiếm Virtuous Contract được chế tác tỉ mỉ với vân kim loại.', 0, 34, 24),
(66, N'Scale Figure 1/7 Albedo (So-Bin Ver)', N'scale-figure-17-albedo-so-bin-ver', 3, 9, N'UNION', 5500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26-28cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Đôi cánh thiên thần sa ngã được đổ khuôn với độ chi tiết lông vũ cực cao. Nước sơn tạo hiệu ứng đổ bóng sâu.', 0, 454, 36),
(67, N'Scale Figure 1/7 Ganyu (Plenilune Gaze)', N'scale-figure-17-ganyu-plenilune-gaze', 3, 9, N'APEXTOYS', 4500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Trang phục và lụa quấn được sơn hiệu ứng bán trong suốt. Sa bàn (Base) đi kèm họa tiết hoa văn cực kì tinh tế.', 0, 128, 48),
(68, N'Scale Figure 1/7 Kurumi Tokisaki (Zafkiel)', N'scale-figure-17-kurumi-tokisaki-zafkiel', 3, 9, N'KADOKAWA', 6000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 25cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Chi tiết nếp gấp bèo nhún trên bộ váy Astral Dress được khắc họa sống động. Phụ kiện súng trường và súng ngắn sơn giả kim.', 0, 111, 16),
(69, N'Scale Figure 1/7 Makima (Chainsaw Man)', N'scale-figure-17-makima-chainsaw-man', 3, 9, N'ESTREAM', 8500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 24-25cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Tỷ lệ cơ thể cực chuẩn, trang phục được chế tác phức tạp đi kèm với các mảnh vỡ sa bàn dưới chân tạo hiệu ứng đẫm máu cực đẹp.', 0, 94, 20),
(70, N'Scale Figure 1/7 Milim Nava', N'scale-figure-17-milim-nava', 3, 9, N'ESPADA', 7000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 23cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Màu sơn neon rực rỡ, chi tiết tóc 2 chùm sắc nhọn và hiệu ứng base sống động.', 0, 70, 23),
(71, N'Scale Figure 1/7 Ningguang (Gold Leaf Panel)', N'scale-figure-17-ningguang-gold-leaf-panel', 3, 9, N'MIHOYO', 7500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 28cm bao gồm diorama).
- Chất liệu: Nhựa PVC, ABS, Acrylic.
- Điểm nổi bật: Khối lượng cực nặng với sa bàn (diorama) hoành tráng đi kèm bối cảnh đồ sộ, ống điếu và hiệu ứng ánh sáng.', 0, 5, 9),
(72, N'Scale Figure 1/7 Raiden Shogun (Statue)', N'scale-figure-17-raiden-shogun-statue', 3, 9, N'APEXTOYS', 10000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 28-30cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Khắc họa chi tiết hoa văn trên áo Kimono. Part thanh kiếm Musou no Hitotachi làm bằng nhựa trong suốt ánh điện tím.', 0, 176, 7),
(73, N'Scale Figure 1/7 Rem (Crystal Dress Ver)', N'scale-figure-17-rem-crystal-dress-ver', 3, 9, N'ESTREAM', 12000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 23cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Chiếc váy pha lê lấp lánh phản quang vô cùng rực rỡ, cùng hàng tá hiệu ứng ánh sáng xung quanh tạo cảm giác bùng nổ.', 0, 497, 44),
(74, N'Scale Figure 1/7 Saber Alter Kimono ver', N'scale-figure-17-saber-alter-kimono-ver', 3, 9, N'ALTER', 9500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 25cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Áo Kimono lụa đen huyền bí, phong cách ma mị nhưng đậm chất quý tộc. Họa tiết trên tà áo được in sắc nét.', 0, 83, 47),
(75, N'Bunny Girl Senpai 1/4 Mai Sakurajima', N'bunny-girl-senpai-14-mai-sakurajima', 3, 9, N'FREEING', 8500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/4 (Chiều cao khủng 40cm).
- Chất liệu: Nhựa PVC, ABS, Vải.
- Điểm nổi bật: Vớ lưới được làm bằng chất liệu vải lưới thật sự căng ôm sát, đem đến trải nghiệm vô cùng cao cấp.', 0, 211, 6),
(76, N'Scale Figure 1/7 Yae Miko (Astute Amusement)', N'scale-figure-17-yae-miko-astute-amusement', 3, 9, N'KOTO', 5000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26-27cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Trang phục đền thần Miko lộng lẫy, nhiều phụ kiện tinh xảo (trâm cài, lục lạc, quyền trượng).', 0, 69, 25),
(77, N'Bộ sơn Acrysion Starter Set (6 màu)', N'b-sn-acrysion-starter-set-6-mu', 4, 10, N'MRHOBBY', 300000, N'Bộ sơn Acrylic Acrysion cơ bản (6 màu) của Mr.Hobby. Ưu điểm: thân thiện với môi trường, ít mùi độc hại, an toàn khi sử dụng trong nhà không thoáng khí, độ bám dính cực tốt trên nền nhựa.', 0, 437, 12),
(78, N'Kềm cắt nhựa 1 lưỡi DSPIAE ST-A 3.0 Single Blade Nipper', N'km-ct-nha-1-li-dspiae-st-a-30-single-blade-nipper', 4, 10, N'DSPIAE', 650000, N'Kềm cắt nhựa 1 lưỡi siêu bén của hãng DSPIAE. Lưỡi kềm được rèn nhiệt luyện sắc ngọt, giúp cắt part nhựa sát chân gate mà không làm trắng nhựa hay để lại vết sẹo (nub mark). Thiết kế tay cầm chắc chắn chống mỏi.', 0, 382, 26),
(79, N'Kềm cắt nhựa cơ bản Tamiya 74093 Entry Nipper', N'km-ct-nha-c-bn-tamiya-74093-entry-nipper', 4, 10, N'TAMIYA', 150000, N'Kềm cắt nhựa cơ bản (Entry Nipper) phù hợp cho người mới bắt đầu. Lưỡi kềm dày dặn, cứng cáp, chịu lực tốt, lý tưởng để cắt ròng (runner) các chi tiết lớn trước khi xử lý tinh bằng kềm 1 lưỡi.', 0, 89, 18),
(80, N'Bút tăng độ cứng khớp Tamiya 87182 Joint Strength Pen', N'bt-tng-cng-khp-tamiya-87182-joint-strength-pen', 4, 10, N'TAMIYA', 120000, N'Dung dịch chuyên dụng dạng bút giúp phục hồi các khớp mô hình bị lỏng lẻo sau thời gian dài tạo dáng. Chỉ cần bôi một lớp mỏng vào phần chốt bi (ball joint) và chờ khô, khớp sẽ cứng cáp lại như mới.', 0, 272, 16),
(81, N'Bút kẻ lằn chìm Tamiya Panel Line Marker', N'bt-k-ln-chm-tamiya-panel-line-marker', 4, 10, N'TAMIYA', 60000, N'Bút kẻ lằn chìm ngòi siêu nhỏ. Giúp làm nổi bật các rãnh, chi tiết cơ khí trên áo giáp mô hình Gundam. Nét mực ra đều, dễ dàng xóa phần lem bằng gôm/tẩy.', 0, 475, 26),
(82, N'Băng keo che sơn Tamiya Masking Tape 18mm', N'bng-keo-che-sn-tamiya-masking-tape-18mm', 4, 10, N'TAMIYA', 80000, N'Băng keo chuyên dụng trong kỹ thuật sơn mô hình (Masking). Có độ dẻo dai bám dính tốt trên các mặt cong và đặc biệt không để lại vệt keo thừa khi lột ra. Ngăn sơn rỉ sang các mảng màu khác.', 0, 117, 13),
(83, N'Dung dịch dán decal nước Mr.Hobby Mark Setter (MS232)', N'dung-dch-dn-decal-nc-mrhobby-mark-setter-ms232', 4, 10, N'MRHOBBY', 85000, N'Dung dịch dán decal nước Mark Setter của Mr.Hobby. Chứa thành phần keo nhẹ giúp decal nước bám dính chắc chắn hơn vào bề mặt nhựa, chống hiện tượng bong tróc sau khi khô.', 0, 456, 49),
(84, N'Dung dịch làm mềm decal nước Mr.Hobby Mark Softer (MS231)', N'dung-dch-lm-mm-decal-nc-mrhobby-mark-softer-ms231', 4, 10, N'MRHOBBY', 85000, N'Dung dịch làm mềm decal nước Mark Softer. Thẩm thấu vào decal giúp chúng mềm ra, ôm sát hoàn hảo vào các bề mặt gồ ghề, lồi lõm hoặc khe nếp gấp sâu của mô hình.', 0, 143, 48),
(85, N'Keo dán nhựa chảy siêu lỏng Mr.Hobby Mr.Cement SP (MC129)', N'keo-dn-nha-chy-siu-lng-mrhobby-mrcement-sp-mc129', 4, 10, N'MRHOBBY', 90000, N'Keo dán nhựa chảy siêu lỏng (Thin Cement). Hoạt động bằng cơ chế làm chảy và hàn dính 2 mép nhựa PS/ABS lại với nhau. Keo khô siêu tốc, giúp các vết nối dính chặt mà không để lại lớp keo cộm.', 0, 444, 31),
(86, N'Bộ kẹp sơn 20 que và đế cắm Tamiya Spray Work Painting Stand', N'b-kp-sn-20-que-v-cm-tamiya-spray-work-painting-stand', 4, 10, N'TAMIYA', 150000, N'Bộ phụ kiện hỗ trợ quá trình phun sơn bằng súng phun (Airbrush) hoặc sơn lon. Gồm 20 kẹp sấu đính que cứng cáp giúp giữ chi tiết không chạm tay, kèm 1 đế xốp tổ ong để cắm que phơi khô.', 0, 150, 22),
(87, N'Mực kẻ lằn chìm Tamiya Panel Line Accent Color (Black) 40ml', N'mc-k-ln-chm-tamiya-panel-line-accent-color-black-40ml', 4, 10, N'TAMIYA', 120000, N'Lọ dung dịch mực kẻ lằn chìm pha sẵn siêu loãng của Tamiya. Đi kèm cọ cắm dưới nắp, chỉ cần chấm nhẹ vào rãnh panel, mực sẽ tự động mao dẫn chạy dọc theo khe rãnh cực kì đẹp.', 0, 442, 37),
(88, N'Bộ dụng cụ cơ bản 7 món Tamiya Basic Tool Set (74016)', N'b-dng-c-c-bn-7-mn-tamiya-basic-tool-set-74016', 4, 10, N'TAMIYA', 200000, N'Bộ công cụ nhập môn bao gồm 7 món cơ bản: Kềm cắt nhựa, nhíp nhọn mũi cong/thẳng gắp decal, dao rọc giấy cán nhôm, bộ dũa nhỏ 3 cây. Giải pháp tiết kiệm nhưng đáp ứng đủ nhu cầu lắp ráp thô.', 0, 112, 24);
SET IDENTITY_INSERT [dbo].[Products] OFF;
GO

SET IDENTITY_INSERT [dbo].[ProductImages] ON;
INSERT INTO [dbo].[ProductImages] (ImageID, ProductID, ImageURL, IsPrimary) VALUES
(1, 1, N'~/images/Cars/AstonMartinAMR24_1.jpg', 1),
(2, 1, N'~/images/Cars/AstonMartinAMR24_2.jpg', 0),
(3, 1, N'~/images/Cars/AstonMartinAMR24_3.jpg', 0),
(4, 2, N'~/images/Cars/AstonMartinDBS_1.jpg', 1),
(5, 2, N'~/images/Cars/AstonMartinDBS_2.jpg', 0),
(6, 2, N'~/images/Cars/AstonMartinDBS_3.jpg', 0),
(7, 3, N'~/images/Cars/AstonMartinValkyrie_1.jpg', 1),
(8, 3, N'~/images/Cars/AstonMartinValkyrie_2.jpg', 0),
(9, 3, N'~/images/Cars/AstonMartinValkyrie_3.jpg', 0),
(10, 4, N'~/images/Cars/BMWM4CSL_1.jpg', 1),
(11, 4, N'~/images/Cars/BMWM4CSL_2.jpg', 0),
(12, 4, N'~/images/Cars/BMWM4CSL_3.jpg', 0),
(13, 5, N'~/images/Cars/BMWM4GT3EVO_1.jpg', 1),
(14, 5, N'~/images/Cars/BMWM4GT3EVO_2.jpg', 0),
(15, 5, N'~/images/Cars/BMWM4GT3EVO_3.jpg', 0),
(16, 6, N'~/images/Cars/BMWM5_1.jpg', 1),
(17, 6, N'~/images/Cars/BMWM5_2.jpg', 0),
(18, 6, N'~/images/Cars/BMWM5_3.jpg', 0),
(19, 7, N'~/images/Cars/BugattiBolide_1.jpg', 1),
(20, 7, N'~/images/Cars/BugattiBolide_2.jpg', 0),
(21, 7, N'~/images/Cars/BugattiBolide_3.jpg', 0),
(22, 8, N'~/images/Cars/BugattiChiron_1.jpg', 1),
(23, 8, N'~/images/Cars/BugattiChiron_2.jpg', 0),
(24, 8, N'~/images/Cars/BugattiChiron_3.jpg', 0),
(25, 9, N'~/images/Cars/BugattiDivo_1.jpg', 1),
(26, 9, N'~/images/Cars/BugattiDivo_2.jpg', 0),
(27, 9, N'~/images/Cars/BugattiDivo_3.jpg', 0),
(28, 10, N'~/images/Cars/FordGT_1.jpg', 1),
(29, 10, N'~/images/Cars/FordGT_2.jpg', 0),
(30, 10, N'~/images/Cars/FordGT_3.jpg', 0),
(31, 11, N'~/images/Cars/FordMustangGTD_1.jpg', 1),
(32, 11, N'~/images/Cars/FordMustangGTD_2.jpg', 0),
(33, 11, N'~/images/Cars/FordMustangGTD_3.jpg', 0),
(34, 12, N'~/images/Cars/FordPumaRally1_1.jpg', 1),
(35, 12, N'~/images/Cars/FordPumaRally1_2.jpg', 0),
(36, 12, N'~/images/Cars/FordPumaRally1_3.jpg', 0),
(37, 13, N'~/images/Cars/HondaCivicTypeR_1.jpg', 1),
(38, 13, N'~/images/Cars/HondaCivicTypeR_2.jpg', 0),
(39, 13, N'~/images/Cars/HondaCivicTypeR_3.jpg', 0),
(40, 14, N'~/images/Cars/HondaNSX_1.jpg', 1),
(41, 14, N'~/images/Cars/HondaNSX_2.jpg', 0),
(42, 14, N'~/images/Cars/HondaNSX_3.jpg', 0),
(43, 15, N'~/images/Cars/HondaS2000_1.jpg', 1),
(44, 15, N'~/images/Cars/HondaS2000_2.jpg', 0),
(45, 15, N'~/images/Cars/HondaS2000_3.jpg', 0),
(46, 16, N'~/images/Cars/LamborghiniAventadorSVJ_1.jpg', 1),
(47, 16, N'~/images/Cars/LamborghiniAventadorSVJ_2.jpg', 0),
(48, 16, N'~/images/Cars/LamborghiniAventadorSVJ_3.jpg', 0),
(49, 17, N'~/images/Cars/LamborghiniHuracanGT3EVO2_1.jpg', 1),
(50, 17, N'~/images/Cars/LamborghiniHuracanGT3EVO2_2.jpg', 0),
(51, 17, N'~/images/Cars/LamborghiniHuracanGT3EVO2_3.jpg', 0),
(52, 18, N'~/images/Cars/LamborghiniRevuelto_1.jpg', 1),
(53, 18, N'~/images/Cars/LamborghiniRevuelto_2.jpg', 0),
(54, 18, N'~/images/Cars/LamborghiniRevuelto_3.jpg', 0),
(55, 19, N'~/images/Cars/MazdaAZ1_1.jpg', 1),
(56, 19, N'~/images/Cars/MazdaAZ1_2.jpg', 0),
(57, 19, N'~/images/Cars/MazdaAZ1_3.jpg', 0),
(58, 20, N'~/images/Cars/MazdaMiata_1.jpg', 1),
(59, 20, N'~/images/Cars/MazdaMiata_2.jpg', 0),
(60, 20, N'~/images/Cars/MazdaMiata_3.jpg', 0),
(61, 21, N'~/images/Cars/MazdaRX7_1.jpg', 1),
(62, 21, N'~/images/Cars/MazdaRX7_2.jpg', 0),
(63, 21, N'~/images/Cars/MazdaRX7_3.jpg', 0),
(64, 22, N'~/images/Cars/McLaren720SGT3Evo_1.jpg', 1),
(65, 22, N'~/images/Cars/McLaren720SGT3Evo_2.jpg', 0),
(66, 22, N'~/images/Cars/McLaren720SGT3Evo_3.jpg', 0),
(67, 23, N'~/images/Cars/McLarenF1_1.jpg', 1),
(68, 23, N'~/images/Cars/McLarenF1_2.jpg', 0),
(69, 23, N'~/images/Cars/McLarenF1_3.jpg', 0),
(70, 24, N'~/images/Cars/McLarenMCL38_1.jpg', 1),
(71, 24, N'~/images/Cars/McLarenMCL38_2.jpg', 0),
(72, 24, N'~/images/Cars/McLarenMCL38_3.jpg', 0),
(73, 25, N'~/images/Cars/NissanGTRNISMOGT3_1.jpg', 1),
(74, 25, N'~/images/Cars/NissanGTRNISMOGT3_2.jpg', 0),
(75, 25, N'~/images/Cars/NissanGTRNISMOGT3_3.jpg', 0),
(76, 26, N'~/images/Cars/NissanSkylineGTRR34_1.jpg', 1),
(77, 26, N'~/images/Cars/NissanSkylineGTRR34_2.jpg', 0),
(78, 26, N'~/images/Cars/NissanSkylineGTRR34_3.jpg', 0),
(79, 27, N'~/images/Cars/NissanZPandem_1.jpg', 1),
(80, 27, N'~/images/Cars/NissanZPandem_2.jpg', 0),
(81, 27, N'~/images/Cars/NissanZPandem_3.jpg', 0),
(82, 28, N'~/images/Cars/PaganiHuayraRoadster_1.jpg', 1),
(83, 28, N'~/images/Cars/PaganiHuayraRoadster_2.jpg', 0),
(84, 28, N'~/images/Cars/PaganiHuayraRoadster_3.jpg', 0),
(85, 29, N'~/images/Cars/PaganiZondaFRosso_1.jpg', 1),
(86, 29, N'~/images/Cars/PaganiZondaFRosso_2.jpg', 0),
(87, 29, N'~/images/Cars/PaganiZondaFRosso_3.jpg', 0),
(88, 30, N'~/images/Cars/PaganiZondaFSilver_1.jpg', 1),
(89, 30, N'~/images/Cars/PaganiZondaFSilver_2.jpg', 0),
(90, 30, N'~/images/Cars/PaganiZondaFSilver_3.jpg', 0),
(91, 31, N'~/images/Cars/Porsche911GT3RS_1.jpg', 1),
(92, 31, N'~/images/Cars/Porsche911GT3RS_2.jpg', 0),
(93, 31, N'~/images/Cars/Porsche911GT3RS_3.jpg', 0),
(94, 32, N'~/images/Cars/Porsche911GT3R_1.jpg', 1),
(95, 32, N'~/images/Cars/Porsche911GT3R_2.JPG', 0),
(96, 32, N'~/images/Cars/Porsche911GT3R_3.JPG', 0),
(97, 33, N'~/images/Cars/Porsche991GT2RS_1.jpg', 1),
(98, 33, N'~/images/Cars/Porsche991GT2RS_2.jpg', 0),
(99, 33, N'~/images/Cars/Porsche991GT2RS_3.jpg', 0),
(100, 34, N'~/images/Cars/ToyotaGR86_1.jpg', 1),
(101, 34, N'~/images/Cars/ToyotaGR86_2.jpg', 0),
(102, 34, N'~/images/Cars/ToyotaGR86_3.jpg', 0),
(103, 35, N'~/images/Cars/ToyotaGRSupra_1.jpg', 1),
(104, 35, N'~/images/Cars/ToyotaGRSupra_2.jpg', 0),
(105, 35, N'~/images/Cars/ToyotaGRSupra_3.jpg', 0),
(106, 36, N'~/images/Cars/ToyotaSupraA80_1.jpg', 1),
(107, 36, N'~/images/Cars/ToyotaSupraA80_2.jpg', 0),
(108, 36, N'~/images/Cars/ToyotaSupraA80_3.jpg', 0),
(109, 37, N'~/images/Gundam/Aerial-HG-0.jpg', 1),
(110, 37, N'~/images/Gundam/Aerial-HG-1.webp', 0),
(111, 37, N'~/images/Gundam/Aerial-HG-2.webp', 0),
(112, 37, N'~/images/Gundam/Aerial-HG-3.webp', 0),
(113, 38, N'~/images/Gundam/AerialRB-HG-0.jpg', 1),
(114, 38, N'~/images/Gundam/AerialRB-HG-1.jpg', 0),
(115, 38, N'~/images/Gundam/AerialRB-HG-2.jpg', 0),
(116, 38, N'~/images/Gundam/AerialRB-HG-3.jpg', 0),
(117, 39, N'~/images/Gundam/Astray-Red-Frame-PG-0.jpg', 1),
(118, 39, N'~/images/Gundam/Astray-Red-Frame-PG-1.jpg', 0),
(119, 39, N'~/images/Gundam/Astray-Red-Frame-PG-2.jpg', 0),
(120, 40, N'~/images/Gundam/Barbatos-Lupus-MG-0.webp', 1),
(121, 40, N'~/images/Gundam/Barbatos-Lupus-MG-1.webp', 0),
(122, 40, N'~/images/Gundam/Barbatos-Lupus-MG-2.webp', 0),
(123, 40, N'~/images/Gundam/Barbatos-Lupus-MG-3.webp', 0),
(124, 41, N'~/images/Gundam/Divine-Invoker-Percival-Deluxe-0.jpg', 1),
(125, 41, N'~/images/Gundam/Divine-Invoker-Percival-Deluxe-1.jpg', 0),
(126, 41, N'~/images/Gundam/Divine-Invoker-Percival-Deluxe-2.jpg', 0),
(127, 41, N'~/images/Gundam/Divine-Invoker-Percival-Deluxe-3.jpg', 0),
(128, 41, N'~/images/Gundam/Divine-Invoker-Percival-Deluxe-4.jpg', 0),
(129, 41, N'~/images/Gundam/Divine-Invoker-Percival-Deluxe-5.jpg', 0),
(130, 42, N'~/images/Gundam/FA-Unicorn-RG-0.jpg', 1),
(131, 42, N'~/images/Gundam/FA-Unicorn-RG-1.jpg', 0),
(132, 42, N'~/images/Gundam/FA-Unicorn-RG-2.jpg', 0),
(133, 42, N'~/images/Gundam/FA-Unicorn-RG-3.jpg', 0),
(134, 42, N'~/images/Gundam/FA-Unicorn-RG-4.jpg', 0),
(135, 43, N'~/images/Gundam/Firelord-Awakening-Armament-0.jpg', 1),
(136, 43, N'~/images/Gundam/Firelord-Awakening-Armament-1.jpg', 0),
(137, 43, N'~/images/Gundam/Firelord-Awakening-Armament-2.jpg', 0),
(138, 43, N'~/images/Gundam/Firelord-Awakening-Armament-3.jpg', 0),
(139, 44, N'~/images/Gundam/Force-Impuse-Spec2-RG-0.jpg', 1),
(140, 44, N'~/images/Gundam/Force-Impuse-Spec2-RG-1.jpg', 0),
(141, 44, N'~/images/Gundam/Force-Impuse-Spec2-RG-2.jpg', 0),
(142, 44, N'~/images/Gundam/Force-Impuse-Spec2-RG-3.jpg', 0),
(143, 45, N'~/images/Gundam/Freedom-Strike-MGEX-0.jpg', 1),
(144, 45, N'~/images/Gundam/Freedom-Strike-MGEX-1.jpg', 0),
(145, 45, N'~/images/Gundam/Freedom-Strike-MGEX-2.jpg', 0),
(146, 45, N'~/images/Gundam/Freedom-Strike-MGEX-3.jpg', 0),
(147, 46, N'~/images/Gundam/God-RG-0.jpg', 1),
(148, 46, N'~/images/Gundam/God-RG-1.webp', 0),
(149, 46, N'~/images/Gundam/God-RG-2.webp', 0),
(150, 46, N'~/images/Gundam/God-RG-3.webp', 0),
(151, 46, N'~/images/Gundam/God-RG-4.webp', 0),
(152, 47, N'~/images/Gundam/Gquuuuuux-HG-0.webp', 1),
(153, 47, N'~/images/Gundam/Gquuuuuux-HG-1.webp', 0),
(154, 47, N'~/images/Gundam/Gquuuuuux-HG-2.webp', 0),
(155, 47, N'~/images/Gundam/Gquuuuuux-HG-3.webp', 0),
(156, 48, N'~/images/Gundam/RX78-2-Beyond-Global-HG-0.jpg', 1),
(157, 48, N'~/images/Gundam/RX78-2-Beyond-Global-HG-1.webp', 0),
(158, 48, N'~/images/Gundam/RX78-2-Beyond-Global-HG-2.webp', 0),
(159, 48, N'~/images/Gundam/RX78-2-Beyond-Global-HG-3.webp', 0),
(160, 48, N'~/images/Gundam/RX78-2-Beyond-Global-HG-4.webp', 0),
(161, 49, N'~/images/Gundam/RX78-2-PG-0.jpg', 1),
(162, 49, N'~/images/Gundam/RX78-2-PG-1.jpg', 0),
(163, 49, N'~/images/Gundam/RX78-2-PG-2.jpg', 0),
(164, 49, N'~/images/Gundam/RX78-2-PG-3.jpg', 0),
(165, 49, N'~/images/Gundam/RX78-2-PG-4.jpg', 0),
(166, 50, N'~/images/Gundam/RX93-Nu-V-PG-0.jpg', 1),
(167, 50, N'~/images/Gundam/RX93-Nu-V-PG-1.webp', 0),
(168, 50, N'~/images/Gundam/RX93-Nu-V-PG-2.webp', 0),
(169, 50, N'~/images/Gundam/RX93-Nu-V-PG-3.webp', 0),
(170, 50, N'~/images/Gundam/RX93-Nu-V-PG-4.webp', 0),
(171, 50, N'~/images/Gundam/RX93-Nu-V-PG-5.webp', 0),
(172, 51, N'~/images/Gundam/Wing-Zero-VerKa-MG-0.jpg', 1),
(173, 51, N'~/images/Gundam/Wing-Zero-VerKa-MG-1.jpg', 0),
(174, 51, N'~/images/Gundam/Wing-Zero-VerKa-MG-2.jpg', 0),
(175, 51, N'~/images/Gundam/Wing-Zero-VerKa-MG-3.jpg', 0),
(176, 52, N'~/images/Gundam/Zeta-RG-0.webp', 1),
(177, 52, N'~/images/Gundam/Zeta-RG-1.webp', 0),
(178, 52, N'~/images/Gundam/Zeta-RG-2.webp', 0),
(179, 52, N'~/images/Gundam/Zeta-RG-3.webp', 0),
(180, 52, N'~/images/Gundam/Zeta-RG-4.webp', 0),
(181, 53, N'~/images/Figure/ActionAndChibi/Eren_Main.jpg', 1),
(182, 53, N'~/images/Figure/ActionAndChibi/Eren_Sub_1.jpg', 1),
(183, 53, N'~/images/Figure/ActionAndChibi/Eren_Sub_2.jpg', 0),
(184, 53, N'~/images/Figure/ActionAndChibi/Eren_Sub_3.jpg', 0),
(185, 53, N'~/images/Figure/ActionAndChibi/Eren_Sub_4.jpg', 0),
(186, 54, N'~/images/Figure/ActionAndChibi/GawrGura_Main.jpg', 1),
(187, 54, N'~/images/Figure/ActionAndChibi/GawrGura_Sub_1.jpg', 1),
(188, 54, N'~/images/Figure/ActionAndChibi/GawrGura_Sub_2.jpg', 0),
(189, 54, N'~/images/Figure/ActionAndChibi/GawrGura_Sub_3.jpg', 0),
(190, 54, N'~/images/Figure/ActionAndChibi/GawrGura_Sub_4.jpg', 0),
(191, 55, N'~/images/Figure/ActionAndChibi/Levi_Main.jpg', 1),
(192, 55, N'~/images/Figure/ActionAndChibi/Levi_Sub_1.jpg', 1),
(193, 55, N'~/images/Figure/ActionAndChibi/Levi_Sub_2.jpg', 0),
(194, 55, N'~/images/Figure/ActionAndChibi/Levi_Sub_3.jpg', 0),
(195, 55, N'~/images/Figure/ActionAndChibi/Levi_Sub_4.jpg', 0),
(196, 56, N'~/images/Figure/ActionAndChibi/Link_Main.jpg', 1),
(197, 56, N'~/images/Figure/ActionAndChibi/Link_Sub_1.jpg', 1),
(198, 56, N'~/images/Figure/ActionAndChibi/Link_Sub_2.jpg', 0),
(199, 56, N'~/images/Figure/ActionAndChibi/Link_Sub_3.jpg', 0),
(200, 56, N'~/images/Figure/ActionAndChibi/Link_Sub_4.jpg', 0),
(201, 57, N'~/images/Figure/ActionAndChibi/Luffy_Main.jpg', 1),
(202, 57, N'~/images/Figure/ActionAndChibi/Luffy_Sub_1.jpg', 1),
(203, 57, N'~/images/Figure/ActionAndChibi/Luffy_Sub_2.jpg', 0),
(204, 57, N'~/images/Figure/ActionAndChibi/Luffy_Sub_3.jpg', 0),
(205, 57, N'~/images/Figure/ActionAndChibi/Luffy_Sub_4.jpg', 0),
(206, 58, N'~/images/Figure/ActionAndChibi/Makima_Main.jpg', 1),
(207, 58, N'~/images/Figure/ActionAndChibi/Makima_Sub_1.jpg', 1),
(208, 58, N'~/images/Figure/ActionAndChibi/Makima_Sub_2.jpg', 0),
(209, 58, N'~/images/Figure/ActionAndChibi/Makima_Sub_3.jpg', 0),
(210, 58, N'~/images/Figure/ActionAndChibi/Makima_Sub_4.jpg', 0),
(211, 59, N'~/images/Figure/ActionAndChibi/Naruto_Main.jpg', 1),
(212, 59, N'~/images/Figure/ActionAndChibi/Naruto_Sub_1.jpg', 1),
(213, 59, N'~/images/Figure/ActionAndChibi/Naruto_Sub_2.jpg', 0),
(214, 59, N'~/images/Figure/ActionAndChibi/Naruto_Sub_3.jpg', 0),
(215, 59, N'~/images/Figure/ActionAndChibi/Naruto_Sub_4.jpg', 0),
(216, 60, N'~/images/Figure/ActionAndChibi/Power_Main.jpg', 1),
(217, 60, N'~/images/Figure/ActionAndChibi/Power_Sub_1.jpg', 1),
(218, 60, N'~/images/Figure/ActionAndChibi/Power_Sub_2.jpg', 0),
(219, 60, N'~/images/Figure/ActionAndChibi/Power_Sub_3.jpg', 0),
(220, 60, N'~/images/Figure/ActionAndChibi/Power_Sub_4.jpg', 0),
(221, 61, N'~/images/Figure/ActionAndChibi/Rengoku_Main.jpg', 1),
(222, 61, N'~/images/Figure/ActionAndChibi/Rengoku_Sub_1.jpg', 1),
(223, 61, N'~/images/Figure/ActionAndChibi/Rengoku_Sub_2.jpg', 0),
(224, 61, N'~/images/Figure/ActionAndChibi/Rengoku_Sub_3.jpg', 0),
(225, 61, N'~/images/Figure/ActionAndChibi/Rengoku_Sub_4.jpg', 0),
(226, 62, N'~/images/Figure/ActionAndChibi/Spiderman_Main.jpg', 1),
(227, 62, N'~/images/Figure/ActionAndChibi/Spiderman_Sub_1.jpg', 1),
(228, 62, N'~/images/Figure/ActionAndChibi/Spiderman_Sub_2.jpg', 0),
(229, 62, N'~/images/Figure/ActionAndChibi/Spiderman_Sub_3.jpg', 0),
(230, 62, N'~/images/Figure/ActionAndChibi/Spiderman_Sub_4.jpg', 0),
(231, 63, N'~/images/Figure/ActionAndChibi/UchihaSasuke_Main.jpg', 1),
(232, 63, N'~/images/Figure/ActionAndChibi/UchihaSasuke_Sub_1.jpg', 1),
(233, 63, N'~/images/Figure/ActionAndChibi/UchihaSasuke_Sub_2.jpg', 0),
(234, 63, N'~/images/Figure/ActionAndChibi/UchihaSasuke_Sub_3.jpg', 0),
(235, 63, N'~/images/Figure/ActionAndChibi/UchihaSasuke_Sub_4.jpg', 0),
(236, 64, N'~/images/Figure/ActionAndChibi/YorForger_Main.jpg', 1),
(237, 64, N'~/images/Figure/ActionAndChibi/YorForger_Sub_1.jpg', 1),
(238, 64, N'~/images/Figure/ActionAndChibi/YorForger_Sub_2.jpg', 0),
(239, 64, N'~/images/Figure/ActionAndChibi/YorForger_Sub_3.jpg', 0),
(240, 64, N'~/images/Figure/ActionAndChibi/YorForger_Sub_4.jpg', 0),
(241, 65, N'~/images/Figure/ScaleFigure/2B_Main.jpg', 1),
(242, 65, N'~/images/Figure/ScaleFigure/2B_Sub_1.jpg', 1),
(243, 65, N'~/images/Figure/ScaleFigure/2B_Sub_2.jpg', 0),
(244, 65, N'~/images/Figure/ScaleFigure/2B_Sub_3.jpg', 0),
(245, 65, N'~/images/Figure/ScaleFigure/2B_Sub_4.jpg', 0),
(246, 66, N'~/images/Figure/ScaleFigure/Albedo_Main.jpg', 1),
(247, 66, N'~/images/Figure/ScaleFigure/Albedo_Sub_1.jpg', 1),
(248, 66, N'~/images/Figure/ScaleFigure/Albedo_Sub_2.jpg', 0),
(249, 66, N'~/images/Figure/ScaleFigure/Albedo_Sub_3.jpg', 0),
(250, 66, N'~/images/Figure/ScaleFigure/Albedo_Sub_4.jpg', 0),
(251, 67, N'~/images/Figure/ScaleFigure/Ganyu_Main.jpg', 1),
(252, 67, N'~/images/Figure/ScaleFigure/Ganyu_Sub_1.jpg', 1),
(253, 67, N'~/images/Figure/ScaleFigure/Ganyu_Sub_3.jpg', 0),
(254, 67, N'~/images/Figure/ScaleFigure/Ganyu_Sub_4.jpg', 0),
(255, 67, N'~/images/Figure/ScaleFigure/Ganyu_Sub_5.jpg', 0),
(256, 68, N'~/images/Figure/ScaleFigure/Kurumi_Main.jpg', 1),
(257, 68, N'~/images/Figure/ScaleFigure/Kurumi_Sub_1.jpg', 1),
(258, 68, N'~/images/Figure/ScaleFigure/Kurumi_Sub_2.jpg', 0),
(259, 68, N'~/images/Figure/ScaleFigure/Kurumi_Sub_3.jpg', 0),
(260, 68, N'~/images/Figure/ScaleFigure/Kurumi_Sub_4.jpg', 0),
(261, 69, N'~/images/Figure/ScaleFigure/Makima_Main.jpg', 1),
(262, 69, N'~/images/Figure/ScaleFigure/Makima_Sub_1.jpg', 1),
(263, 69, N'~/images/Figure/ScaleFigure/Makima_Sub_2.jpg', 0),
(264, 69, N'~/images/Figure/ScaleFigure/Makima_Sub_3.jpg', 0),
(265, 69, N'~/images/Figure/ScaleFigure/Makima_Sub_4.jpg', 0),
(266, 70, N'~/images/Figure/ScaleFigure/MilimNava_Main.jpg', 1),
(267, 70, N'~/images/Figure/ScaleFigure/MilimNava_Sub_1.jpg', 1),
(268, 70, N'~/images/Figure/ScaleFigure/MilimNava_Sub_2.jpg', 0),
(269, 70, N'~/images/Figure/ScaleFigure/MilimNava_Sub_3.jpg', 0),
(270, 70, N'~/images/Figure/ScaleFigure/MilimNava_Sub_4.jpg', 0),
(271, 71, N'~/images/Figure/ScaleFigure/Ningguang_Main.jpg', 1),
(272, 71, N'~/images/Figure/ScaleFigure/Ningguang_Sub_1.jpg', 1),
(273, 71, N'~/images/Figure/ScaleFigure/Ningguang_Sub_2.jpg', 0),
(274, 71, N'~/images/Figure/ScaleFigure/Ningguang_Sub_3.jpg', 0),
(275, 71, N'~/images/Figure/ScaleFigure/Ningguang_Sub_4.jpg', 0),
(276, 72, N'~/images/Figure/ScaleFigure/Raiden_Main.webp', 1),
(277, 72, N'~/images/Figure/ScaleFigure/Raiden_Sub_1.webp', 1),
(278, 72, N'~/images/Figure/ScaleFigure/Raiden_Sub_2.webp', 0),
(279, 72, N'~/images/Figure/ScaleFigure/Raiden_Sub_3.webp', 0),
(280, 72, N'~/images/Figure/ScaleFigure/Raiden_Sub_4.jpg', 0),
(281, 73, N'~/images/Figure/ScaleFigure/Rem_Main.jpg', 1),
(282, 73, N'~/images/Figure/ScaleFigure/Rem_Sub_1.jpg', 1),
(283, 73, N'~/images/Figure/ScaleFigure/Rem_Sub_2.jpg', 0),
(284, 73, N'~/images/Figure/ScaleFigure/Rem_Sub_3.jpg', 0),
(285, 73, N'~/images/Figure/ScaleFigure/Rem_Sub_4.jpg', 0),
(286, 74, N'~/images/Figure/ScaleFigure/Saber_Main.jpg', 1),
(287, 74, N'~/images/Figure/ScaleFigure/Saber_Sub_1.jpg', 1),
(288, 74, N'~/images/Figure/ScaleFigure/Saber_Sub_2.jpg', 0),
(289, 74, N'~/images/Figure/ScaleFigure/Saber_Sub_3.jpg', 0),
(290, 74, N'~/images/Figure/ScaleFigure/Saber_Sub_4.jpg', 0),
(291, 75, N'~/images/Figure/ScaleFigure/Sakurajima_Main.jpg', 1),
(292, 75, N'~/images/Figure/ScaleFigure/Sakurajima_Sub_1.jpg', 1),
(293, 75, N'~/images/Figure/ScaleFigure/Sakurajima_Sub_2.jpg', 0),
(294, 75, N'~/images/Figure/ScaleFigure/Sakurajima_Sub_3.jpg', 0),
(295, 75, N'~/images/Figure/ScaleFigure/Sakurajima_Sub_4.jpg', 0),
(296, 76, N'~/images/Figure/ScaleFigure/YaeMiko_Main.jpg', 1),
(297, 76, N'~/images/Figure/ScaleFigure/YaeMiko_Sub_1.jpg', 1),
(298, 76, N'~/images/Figure/ScaleFigure/YaeMiko_Sub_2.jpg', 0),
(299, 77, N'~/images/Tools/Acrysion-Starter-Set-0.webp', 1),
(300, 77, N'~/images/Tools/Acrysion-Starter-Set-1.webp', 0),
(301, 78, N'~/images/Tools/DSPIAE-Single-Blade-Nipper-0.webp', 1),
(302, 78, N'~/images/Tools/DSPIAE-Single-Blade-Nipper-1.webp', 0),
(303, 78, N'~/images/Tools/DSPIAE-Single-Blade-Nipper-2.webp', 0),
(304, 78, N'~/images/Tools/DSPIAE-Single-Blade-Nipper-3.webp', 0),
(305, 78, N'~/images/Tools/DSPIAE-Single-Blade-Nipper-4.webp', 0),
(306, 79, N'~/images/Tools/Entry-Nipper-0.jpg', 1),
(307, 79, N'~/images/Tools/Entry-Nipper-1.jpg', 0),
(308, 79, N'~/images/Tools/Entry-Nipper-2.jpg', 0),
(309, 80, N'~/images/Tools/Join-Strength-Pen-0.jpg', 1),
(310, 80, N'~/images/Tools/Join-Strength-Pen-1.jpg', 0),
(311, 80, N'~/images/Tools/Join-Strength-Pen-2.jpg', 0),
(312, 81, N'~/images/Tools/Lining-Marker-0.jpg', 1),
(313, 81, N'~/images/Tools/Lining-Marker-1.jpg', 0),
(314, 81, N'~/images/Tools/Lining-Marker-2.jpg', 0),
(315, 81, N'~/images/Tools/Lining-Marker-3.jpg', 0),
(316, 82, N'~/images/Tools/Masking-Tape-0.jpg', 1),
(317, 82, N'~/images/Tools/Masking-Tape-1.jpg', 0),
(318, 82, N'~/images/Tools/Masking-Tape-2.jpg', 0),
(319, 82, N'~/images/Tools/Masking-Tape-3.jpg', 0),
(320, 82, N'~/images/Tools/Masking-Tape-4.jpg', 0),
(321, 83, N'~/images/Tools/MrHobby-Mark-Setter-0.jpg', 1),
(322, 84, N'~/images/Tools/MrHobby-Mark-Softer-0.jpg', 1),
(323, 85, N'~/images/Tools/MrHobby-MrCement-0.jpg', 1),
(324, 86, N'~/images/Tools/Spraying-Clamp-Set20-0.jpg', 1),
(325, 86, N'~/images/Tools/Spraying-Clamp-Set20-1.jpg', 0),
(326, 86, N'~/images/Tools/Spraying-Clamp-Set20-2.jpg', 0),
(327, 86, N'~/images/Tools/Spraying-Clamp-Set20-3.jpg', 0),
(328, 87, N'~/images/Tools/Tamiya-Panel-Line-Accent-Color-0.jpg', 1),
(329, 87, N'~/images/Tools/Tamiya-Panel-Line-Accent-Color-1.jpg', 0),
(330, 87, N'~/images/Tools/Tamiya-Panel-Line-Accent-Color-2.jpg', 0),
(331, 87, N'~/images/Tools/Tamiya-Panel-Line-Accent-Color-3.jpg', 0),
(332, 88, N'~/images/Tools/Tool-7-mon-0.jpg', 1),
(333, 88, N'~/images/Tools/Tool-7-mon-1.png', 0);
SET IDENTITY_INSERT [dbo].[ProductImages] OFF;
GO


-----------------------------------------------------------
-- 4. REVIEWS & OTHER DATA
-----------------------------------------------------------
INSERT INTO [dbo].[Reviews] (ProductID, AccountID, Rating, Comment) VALUES
(1, N'customer1', 5, N'Chất lượng mô hình rất tuyệt vời! Shop đóng gói cẩn thận.'),
(2, N'customer2', 4, N'Sản phẩm đẹp nhưng giao hàng hơi chậm một chút.'),
(3, N'customer1', 5, N'Hoàn thiện cực kỳ sắc nét, màu sơn đẹp và chuẩn xác.');
GO

INSERT INTO [dbo].[Vouchers] (VoucherCode, DiscountPercent, DiscountAmount, UsageLimit, ExpiryDate) VALUES
(N'WELCOME10', 10, NULL, 100, '2030-12-31'),
(N'SALE50K', NULL, 50000, 50, '2030-12-31');
GO

INSERT INTO [dbo].[Statuses] (StatusID, StatusName) VALUES
(0, N'Chờ xử lý'),
(1, N'Đang chuẩn bị hàng'),
(2, N'Đang giao hàng'),
(3, N'Đã giao thành công'),
(4, N'Đã hủy');
GO

INSERT INTO [dbo].[Orders] (AccountID, FullName, Address, PhoneNumber, PaymentMethod, ShippingFee, StatusID) VALUES
(N'customer1', N'Nguyễn Văn A', N'Hà Nội', N'0987654321', N'COD', 30000, 0);
GO

INSERT INTO [dbo].[OrderDetails] (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES
(1, 1, 4500000, 1, 0),
(1, 2, 3500000, 1, 0);
GO


UPDATE [dbo].[Products] 
SET [Discount] = 0.2 
WHERE [ProductID] IN (1, 16, 37, 45);
GO

-----------------------------------------------------------
-- RANDOMIZE CreatedAt DATES (Giả lập dữ liệu trong quá khứ)
-----------------------------------------------------------
-- Lùi ngẫu nhiên từ 1 đến 365 ngày so với ngày hiện tại
UPDATE [dbo].[Products] SET [CreatedAt] = DATEADD(day, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
UPDATE [dbo].[Accounts] SET [CreatedAt] = DATEADD(day, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
UPDATE [dbo].[Vouchers] SET [CreatedAt] = DATEADD(day, -ABS(CHECKSUM(NEWID()) % 365), GETDATE());
GO