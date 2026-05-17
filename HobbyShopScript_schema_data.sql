USE Ecommerce_Hobby_Shop
GO

-----------------------------------------------------------
-- 1. TÀI KHOẢN & PHÂN QUYỀN
-----------------------------------------------------------
INSERT INTO [dbo].[Roles] (RoleID, RoleName, RoleName_EN) VALUES 
(0, N'Quản trị viên', N'Administrator'), 
(1, N'Khách hàng', N'Customer');
GO

INSERT INTO [dbo].[Accounts] (AccountID, Password, FullName, Email, PhoneNumber, Address, Gender, IsActive, RoleID) VALUES
(N'admin', N'admin123', N'Admin', N'admin@hobbyshop.com', N'0123456789', N'Biên Hòa, Đồng Nai', 1, 1, 0),
(N'customer1', N'cust123', N'Nguyễn Văn A', N'nva@gmail.com', N'0987654321', N'TP. Hồ Chí Minh', 1, 1, 1),
(N'customer2', N'cust123', N'Trần Thị B', N'ttb@gmail.com', N'0912345678', N'Đà Nẵng', 0, 1, 1);
GO

-----------------------------------------------------------
-- 2. DANH MỤC, SERIES, NHÀ CUNG CẤP
-----------------------------------------------------------
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] (CategoryID, CategoryName, CategoryName_EN, CategorySlug, Image) VALUES 
(1, N'MiniGT', N'MiniGT', N'cars', N'~/images/Categories/cars.png'),
(2, N'Gundam', N'Gundam', N'gundam', N'~/images/Categories/gundam.png'),
(3, N'Figure', N'Figure', N'figure', N'~/images/Categories/figure.png'),
(4, N'Dụng cụ', N'Hobby Tools', N'tools', N'~/images/Categories/tools.png'),
(5, N'Khác', N'Others', N'others', N'~/images/Categories/others.png');
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
INSERT INTO [dbo].[Products] (ProductID, ProductName, ProductName_EN, ProductSlug, CategoryID, SeriesID, SupplierID, UnitPrice, Description, Description_EN, Discount, ViewCount, StockQuantity) VALUES
(1, N'Aston Martin AMR24 #14 Fernando Alonso', N'Aston Martin AMR24 #14 Fernando Alonso', N'aston-martin-amr24-14-fernando-alonso', 1, 7, N'SPARK', 4500000, N'Mô hình xe F1 tỷ lệ 1/18 Aston Martin AMR24 #14 do Fernando Alonso cầm lái tại giải đua Công thức 1. Tái tạo chân thực các khe tản nhiệt và bộ khí động học phức tạp.', N'1/18 scale F1 model car of Aston Martin AMR24 #14 driven by Fernando Alonso in Formula 1. Highly realistic reproduction of cooling vents and complex aerodynamics.', 0, 1250, 48),
(2, N'Aston Martin DBS Stratus White', N'Aston Martin DBS Stratus White', N'aston-martin-dbs-stratus-white', 1, 7, N'AUTOART', 3500000, N'Siêu xe thể thao Aston Martin DBS màu trắng Stratus White tỷ lệ 1/18. Trang bị động cơ V12 chi tiết, nội thất bọc da mô phỏng cực kỳ sắc sảo.', N'Aston Martin DBS sports car in Stratus White, 1/18 scale. Equipped with detailed V12 engine and extremely sharp simulated leather interior.', 0, 882, 13),
(3, N'Aston Martin Valkyrie Racing Green', N'Aston Martin Valkyrie Racing Green 1/18', N'aston-martin-valkyrie-racing-green', 1, 7, N'AUTOART', 6200000, N'Hypercar Aston Martin Valkyrie màu xanh Racing Green tỷ lệ 1/18. Thân vỏ làm từ Resin cao cấp, tái tạo hoàn hảo các luồng khí động học bên dưới gầm xe.', N'Aston Martin Valkyrie hypercar in Racing Green, 1/18 scale. Made from premium resin, perfectly reproducing aerodynamic flows under the chassis.', 0, 2293, 5),
(4, N'BMW M4 CSL Frozen Brooklyn Grey', N'BMW M4 CSL Frozen Brooklyn Grey', N'bmw-m4-csl-frozen-brooklyn-grey', 1, 7, N'OTHER', 3200000, N'Mẫu xe hiệu suất cao BMW M4 CSL màu xám nhám Frozen Brooklyn Grey tỷ lệ 1/18. Lưới tản nhiệt mũi to đặc trưng và các điểm nhấn carbon đỏ.', N'High-performance BMW M4 CSL in Frozen Brooklyn Grey, 1/18 scale. Features signature large kidney grille and red carbon accents.', 0, 506, 28),
(5, N'BMW M4 GT3 EVO #90 Team AAI', N'BMW M4 GT3 EVO #90 Team AAI', N'bmw-m4-gt3-evo-90-team-aai', 1, 7, N'SPARK', 4800000, N'Xe đua chuyên dụng BMW M4 GT3 EVO số 90 của đội Team AAI. Phủ kín decal tài trợ, trang bị cánh gió khổng lồ đuôi xe.', N'BMW M4 GT3 EVO racing car #90 Team AAI. Fully covered in sponsor decals, equipped with a massive rear wing.', 0, 1223, 15),
(6, N'BMW M5 Isle of Man Green', N'BMW M5 Isle of Man Green', N'bmw-m5-isle-of-man-green', 1, 7, N'OTHER', 3100000, N'Mẫu sedan hiệu năng cao BMW M5 màu xanh lục Isle of Man Green. Nước sơn bóng loáng, nội thất chi tiết với các nút bấm trên vô lăng.', N'High-performance sedan BMW M5 in Isle of Man Green. Glossy paint finish, detailed interior with steering wheel buttons.', 0, 2439, 27),
(7, N'Bugatti Bolide Red', N'Bugatti Bolide Red', N'bugatti-bolide-red', 1, 7, N'OTHER', 7500000, N'Quái thú đường đua Bugatti Bolide tỷ lệ 1/18 màu đỏ đen. Thiết kế mâm xe tản nhiệt hình chữ X ấn tượng.', N'Bugatti Bolide track monster in red and black, 1/18 scale. Features an impressive X-shaped aerodynamic design.', 0, 835, 19),
(8, N'Bugatti Chiron Super Sport Gold', N'Bugatti Chiron Super Sport Gold', N'bugatti-chiron-super-sport-gold', 1, 7, N'AUTOART', 6800000, N'Bugatti Chiron Super Sport phiên bản màu vàng Gold đặc biệt. Động cơ W16 phô diễn chi tiết bên dưới nắp kính phía sau.', N'Special Bugatti Chiron Super Sport Gold Edition. Detailed W16 engine showcased under the rear glass cover.', 0, 1483, 8),
(9, N'Bugatti Divo White', N'Bugatti Divo White', N'bugatti-divo-white', 1, 7, N'OTHER', 6500000, N'Siêu phẩm hypercar giới hạn Bugatti Divo màu trắng với các đường viền xanh dương. Hệ thống đèn hậu đa khối 3D cực kỳ đẹp mắt.', N'Limited edition Bugatti Divo hypercar in white with blue accents. Stunning 3D multi-block taillight system.', 0, 3262, 35),
(10, N'Ford GT #85 Le Mans 2019', N'Ford GT #85 Le Mans 2019', N'ford-gt-85-le-mans-2019', 1, 7, N'AUTOART', 4200000, N'Ford GT xe đua số 85 từng tham gia giải Le Mans 24h 2019 hạng LM GTE-Am. Livery Keating Motorsports rực rỡ.', N'Ford GT racing car #85 from Le Mans 24h 2019 LM GTE-Am. Vivid Keating Motorsports livery.', 0, 1419, 49),
(11, N'Ford Mustang GTD America 25', N'Ford Mustang GTD America 25', N'ford-mustang-gtd-america-25', 1, 7, N'SPARK', 3900000, N'Phiên bản đường phố đỉnh cao nhất của Mustang - GTD. Thiết kế khí động học siêu hầm hố, cánh gió treo ngược độc đáo.', N'The ultimate street-legal Mustang - GTD. Aggressive aerodynamic design, unique swan-neck rear wing.', 0, 522, 5),
(12, N'Ford Puma Rally1 #13 M-Sport', N'Ford Puma Rally1 #13 M-Sport', N'ford-puma-rally1-13-m-sport', 1, 7, N'SPARK', 4100000, N'Xe đua Rally chuyên nghiệp Ford Puma Rally1 số 13 đội M-Sport mùa giải 2024. Phủ lấm tấm bùn đất cực thực tế.', N'Ford Puma Rally1 professional rally car #13 M-Sport 2024 season. Features realistic mud and dirt splatters.', 0, 2451, 11),
(13, N'Honda Civic Type R Ultimate Edition', N'Honda Civic Type R Ultimate Edition', N'honda-civic-type-r-ultimate-edition', 1, 7, N'AUTOART', 2500000, N'Huyền thoại đường phố Honda Civic Type R. Màu sơn trắng Championship White, mâm đen và cùm phanh Brembo đỏ nổi bật.', N'JDM legend Honda Civic Type R. Championship White paint, black rims, and prominent red Brembo brake calipers.', 0, 4470, 15),
(14, N'Honda NS-X Prototype Ayrton Senna', N'Honda NS-X Prototype Ayrton Senna', N'honda-ns-x-prototype-ayrton-senna', 1, 7, N'AUTOART', 5500000, N'Honda NS-X Prototype màu trắng huyền thoại đi kèm mô hình figure tay đua Ayrton Senna. Khắc họa chính xác lịch sử thử nghiệm xe.', N'Legendary Honda NS-X Prototype in white, comes with Ayrton Senna figure. Accurately portrays testing history.', 0, 1252, 28),
(15, N'Honda S2000 (AP2) CR Grand Prix White', N'Honda S2000 (AP2) CR Grand Prix White', N'honda-s2000-ap2-cr-grand-prix-white', 1, 7, N'AUTOART', 2800000, N'Xe thể thao mui trần Honda S2000 bản Club Racer màu trắng. Tái hiện lại bộ mâm 5 chấu và cánh gió đuôi đặc trưng.', N'Honda S2000 AP2 Club Racer roadster in Grand Prix White. Accurately reproduces signature 5-spoke wheels and rear wing.', 0, 886, 37),
(16, N'Lamborghini Aventador SVJ 63', N'Lamborghini Aventador SVJ 63', N'lamborghini-aventador-svj-63', 1, 7, N'AUTOART', 5800000, N'Siêu bò Lamborghini Aventador SVJ bản giới hạn 63 màu trắng Bianco Asopo. Mâm xe trung tâm, ống xả trên cao.', N'Limited edition Lamborghini Aventador SVJ 63 in Bianco Asopo white. Features center-lock wheels and high-mounted exhaust.', 0, 2217, 24),
(17, N'Lamborghini Huracan GT3 EVO2 #63', N'Lamborghini Huracan GT3 EVO2 #63', N'lamborghini-huracan-gt3-evo2-63', 1, 7, N'SPARK', 5100000, N'Xe đua Huracán GT3 EVO2 đội Iron Lynx tham gia Daytona 24h. Cụm đèn pha LED lục giác và cánh chia gió cực gắt.', N'Lamborghini Huracán GT3 EVO2 Iron Lynx Daytona 24h racing car. Features hexagonal LED headlights and aggressive diffusers.', 0, 1251, 42),
(18, N'Lamborghini Revuelto Giallo', N'Lamborghini Revuelto Giallo', N'lamborghini-revuelto-giallo', 1, 7, N'AUTOART', 5400000, N'Mẫu xe kế nhiệm Aventador: Lamborghini Revuelto màu vàng Giallo rực rỡ. Động cơ V12 hybrid phô ra qua khoang sau.', N'Aventador successor: Lamborghini Revuelto in vibrant Giallo yellow. V12 hybrid engine exposed through the rear bay.', 0, 3301, 50),
(19, N'Mazda AZ-1 Liberty Walk', N'Mazda AZ-1 Liberty Walk', N'mazda-az-1-liberty-walk', 1, 7, N'OTHER', 2100000, N'Mẫu Kei-car thể thao Mazda AZ-1 mang gói độ thân rộng Liberty Walk LB40. Chi tiết ốc vít trên vòm bánh xe rất chân thực.', N'Kei-car Mazda AZ-1 featuring Liberty Walk LB40 widebody kit. Highly realistic rivet details on the wheel arches.', 0, 1189, 9),
(20, N'Mazda Miata MX-5 (NA) Sunburst Yellow', N'Mazda Miata MX-5 (NA) Sunburst Yellow', N'mazda-miata-mx-5-na-sunburst-yellow', 1, 7, N'AUTOART', 1800000, N'Chiếc Miata thế hệ đầu (NA) màu vàng Sunburst. Đặc trưng với cụm đèn pha mắt ếch pop-up siêu đáng yêu.', N'First-generation Miata NA in Sunburst Yellow. Characterized by super cute pop-up headlights.', 0, 1582, 44),
(21, N'Mazda RX-7 RE-Amemiya Silver', N'Mazda RX-7 RE-Amemiya Silver', N'mazda-rx-7-re-amemiya-silver', 1, 7, N'OTHER', 2900000, N'Huyền thoại JDM Mazda RX-7 mang gói độ lừng danh RE-Amemiya. Màu bạc kim loại bóng bẩy, thân rộng khí động học.', N'JDM legend Mazda RX-7 with RE-Amemiya widebody kit. Glossy metallic silver paint, aerodynamic body.', 0, 3122, 50),
(22, N'McLaren 720S GT3 Evo Pfaff Motorsports', N'McLaren 720S GT3 Evo Pfaff Motorsports', N'mclaren-720s-gt3-evo-pfaff-motorsports', 1, 7, N'AUTOART', 4900000, N'Xe đua McLaren 720S GT3 Evo mang họa tiết sọc ca-rô nổi tiếng của Pfaff Motorsports. Đậm chất xe đua IMSA.', N'McLaren 720S GT3 Evo racing car in signature Pfaff Motorsports plaid livery. True IMSA racing spirit.', 0, 1073, 52),
(23, N'McLaren F1 Yquem', N'McLaren F1 Yquem', N'mclaren-f1-yquem', 1, 7, N'SPARK', 8500000, N'Chiếc McLaren F1 màu cam Yquem cực độc đáo. Ghế lái nằm chính giữa trung tâm xe đặc trưng, các chi tiết khoang máy lót vàng mỏng.', N'Extremely unique McLaren F1 in Yquem orange. Signature central driver seat and gold-lined engine bay.', 0, 5479, 39),
(24, N'McLaren MCL38 #81 Oscar Piastri', N'McLaren MCL38 #81 Oscar Piastri', N'mclaren-mcl38-81-oscar-piastri', 1, 7, N'SPARK', 4600000, N'Xe công thức 1 McLaren MCL38 do Oscar Piastri điều khiển đem về chiến thắng Hungarian GP 2024.', N'McLaren MCL38 Formula 1 car driven by Oscar Piastri to victory at the 2024 Hungarian GP.', 0, 2170, 46),
(25, N'Nissan GT-R NISMO GT3 #23', N'Nissan GT-R NISMO GT3 #23', N'nissan-gt-r-nismo-gt3-23', 1, 7, N'AUTOART', 4300000, N'Nissan GT-R xe đua FIA GT3 số 23 đội KCMG từng tham dự Macau Grand Prix. Tái hiện các khe hút gió và tem tài trợ dán quanh xe.', N'Nissan GT-R FIA GT3 #23 KCMG Team for Macau Grand Prix. Features realistic hood vents and sponsor decals.', 0, 1367, 22),
(26, N'Nissan Skyline GT-R (R34) V-Spec II', N'Nissan Skyline GT-R (R34) V-Spec II', N'nissan-skyline-gt-r-r34-v-spec-ii', 1, 7, N'AUTOART', 3800000, N'Ông hoàng đường phố Nissan Skyline GT-R R34 bản V-Spec II màu xanh Bayside Blue. Mâm xe đồng thau 6 chấu kép.', N'JDM king Nissan Skyline GT-R R34 V-Spec II in Bayside Blue. Finished with classic 6-spoke bronze wheels.', 0, 3147, 52),
(27, N'Nissan Z Pandem Seiran Blue', N'Nissan Z Pandem Seiran Blue', N'nissan-z-pandem-seiran-blue', 1, 7, N'OTHER', 2600000, N'Mẫu Nissan Z thế hệ mới độ thân rộng Pandem hầm hố. Màu xanh dương Seiran kết hợp mâm xe deep-dish viền crôm.', N'Next-gen Nissan Z with aggressive Pandem widebody kit. Seiran Blue paint with deep-dish chrome-rimmed wheels.', 0, 1176, 9),
(28, N'Pagani Huayra Roadster Black', N'Pagani Huayra Roadster Black', N'pagani-huayra-roadster-black', 1, 7, N'AUTOART', 6900000, N'Pagani Huayra Roadster mui trần, màu sợi carbon đen toàn thân. Nội thất da đỏ lộng lẫy và khoang động cơ đậm chất nghệ thuật.', N'Pagani Huayra Roadster in full black carbon fiber. Gorgeous red leather interior and artful engine bay.', 0, 4498, 47),
(29, N'Pagani Zonda F Rosso Dubai', N'Pagani Zonda F Rosso Dubai', N'pagani-zonda-f-rosso-dubai', 1, 7, N'AUTOART', 7100000, N'Pagani Zonda F phiên bản màu đỏ bóng pha sợi carbon Rosso Dubai. Ống xả 4 nòng titan đặc trưng của Pagani.', N'Pagani Zonda F in Rosso Dubai red and carbon fiber. Signature quad-exhaust titanium pipes.', 0, 1417, 23),
(30, N'Pagani Zonda F Silver', N'Pagani Zonda F Silver', N'pagani-zonda-f-silver', 1, 7, N'AUTOART', 7100000, N'Siêu xe Pagani Zonda F màu bạc mâm bạc nguyên bản. Phản chiếu ánh sáng lấp lánh ở mọi góc độ.', N'Pagani Zonda F in original metallic silver. Stunning metallic reflections from all angles.', 0, 1438, 10),
(31, N'Porsche 911 (992) GT3 RS Guards Red', N'Porsche 911 (992) GT3 RS Guards Red', N'porsche-911-992-gt3-rs-guards-red', 1, 7, N'AUTOART', 4500000, N'Quái thú track-day Porsche 911 GT3 RS (thế hệ 992) màu đỏ Guards Red. Gói Weissach Package mâm magie và cánh gió siêu lớn tích hợp DRS.', N'Track-day beast Porsche 911 GT3 RS 992 generation in Guards Red. Weissach Package with magnesium wheels and active DRS rear wing.', 0, 5276, 5),
(32, N'Porsche 911 GT3 R #77 AO Racing', N'Porsche 911 GT3 R #77 AO Racing', N'porsche-911-gt3-r-77-ao-racing', 1, 7, N'SPARK', 5200000, N'Xe đua Porsche 911 GT3 R mang livery "Rexy" khủng long T-Rex xanh lá nổi đình đám của đội AO Racing.', N'AO Racing Porsche 911 GT3 R featuring the famous Rexy green T-Rex livery.', 0, 2247, 52),
(33, N'Porsche 911 (991) GT2 RS Miami Blue', N'Porsche 911 (991) GT2 RS Miami Blue', N'porsche-911-991-gt2-rs-miami-blue', 1, 7, N'AUTOART', 4800000, N'Cỗ máy tốc độ 911 GT2 RS (thế hệ 991) màu xanh dương Miami Blue. Trang bị gói Weissach Package với nắp capo sợi carbon.', N'Speed machine Porsche 911 GT2 RS 991 generation in Miami Blue. Equipped with Weissach Package and carbon fiber hood.', 0, 1058, 32),
(34, N'Toyota GR86 LB Nation Black/Gold', N'Toyota GR86 LB Nation Black/Gold', N'toyota-gr86-lb-nation-blackgold', 1, 7, N'OTHER', 2400000, N'Toyota GR86 độ thân rộng Liberty Walk mang màu đen chỉ vàng cuốn hút. Hệ thống treo hạ gầm sát đất.', N'Toyota GR86 Liberty Walk widebody in stunning black and gold livery. Stanced suspension close to the ground.', 0, 2369, 8),
(35, N'Toyota GR Supra HKS Renaissance Red', N'Toyota GR Supra HKS Renaissance Red', N'toyota-gr-supra-hks-renaissance-red', 1, 7, N'OTHER', 2700000, N'Toyota GR Supra được HKS tinh chỉnh mang màu đỏ Renaissance Red rực rỡ, trang bị mâm xe thể thao và cánh gió đuôi liền.', N'Toyota GR Supra tuned by HKS in Renaissance Red. Features sports wheels and integrated ducktail spoiler.', 0, 1201, 12),
(36, N'Toyota Supra (A80) Top Secret Gold', N'Toyota Supra (A80) Top Secret Gold', N'toyota-supra-a80-top-secret-gold', 1, 7, N'OTHER', 3300000, N'Huyền thoại Toyota Supra A80 với gói độ V12 Top Secret màu vàng. Từng chạm ngưỡng tốc độ 300km/h trên cao tốc.', N'Huyền thoại Toyota Supra A80 với gói độ V12 Top Secret màu vàng. Từng chạm ngưỡng tốc độ 300km/h trên cao tốc.', 0, 2441, 8),
(37, N'XVX-016 Gundam Aerial HG 1/144', N'XVX-016 Gundam Aerial HG 1/144', N'xvx-016-gundam-aerial-hg-1144', 2, 1, N'BANDAI', 350000, N'Mô hình lắp ráp XVX-016 Gundam Aerial tỷ lệ 1/144 HG từ series The Witch from Mercury. Trang bị khiên Escutcheon có thể tách thành 11 mũi GUND-Bits điều khiển từ xa. Cử động cực kì linh hoạt ở các khớp háng và vai.', N'Mô hình assembly XVX-016 Gundam Aerial tỷ lệ 1/144 HG từ series The Witch from Mercury. Trang bị khiên Escutcheon có thể tách thành 11 mũi GUND-Bits điều khiển từ xa. Cử động cực kì linh hoạt ở các khớp háng và vai.', 0, 3290, 44),
(38, N'XVX-016RN Gundam Aerial Rebuild HG 1/144', N'XVX-016RN Gundam Aerial Rebuild HG 1/144', N'xvx-016rn-gundam-aerial-rebuild-hg-1144', 2, 1, N'BANDAI', 450000, N'Mô hình XVX-016RN Gundam Aerial Rebuild 1/144 HG. Bản nâng cấp hỏa lực với khẩu súng Beam Rifle cỡ lớn có thể kết hợp cùng GUND-Bits tạo thành vũ khí hủy diệt diện rộng. Các chi tiết khung trong được cải tiến.', N'Mô hình XVX-016RN Gundam Aerial Rebuild 1/144 HG. Bản nâng cấp hỏa lực với khẩu súng Beam Rifle cỡ lớn có thể kết hợp cùng GUND-Bits tạo thành vũ khí hủy diệt diện rộng. Các details khung trong được cải tiến.', 0, 2110, 32),
(39, N'MBF-P02 Gundam Astray Red Frame PG 1/60', N'MBF-P02 Gundam Astray Red Frame PG 1/60', N'mbf-p02-gundam-astray-red-frame-pg-160', 2, 3, N'BANDAI', 4500000, N'MBF-P02 Gundam Astray Red Frame tỷ lệ 1/60 Perfect Grade cực lớn (cao ~30cm). Nổi bật với hệ khung xương màu đỏ siêu chi tiết, các ngón tay cử động được độc lập. Đi kèm thanh Katana "Gerbera Straight" mạ crôm bóng loáng sắc nét.', N'MBF-P02 Gundam Astray Red Frame tỷ lệ 1/60 Perfect Grade cực lớn (cao ~30cm). Nổi bật với hệ inner frame skeleton màu đỏ siêu details, các ngón tay cử động được độc lập. Đi kèm thanh Katana "Gerbera Straight" mạ crôm bóng loáng sắc nét.', 0, 1442, 13),
(40, N'ASW-G-08 Gundam Barbatos Lupus FM 1/100', N'ASW-G-08 Gundam Barbatos Lupus FM 1/100', N'asw-g-08-gundam-barbatos-lupus-fm-1100', 2, 2, N'BANDAI', 850000, N'Mô hình ASW-G-08 Gundam Barbatos Lupus tỷ lệ 1/100 (Full Mechanics). Sở hữu bộ khung Gundam Frame chi tiết ở ngực và chân. Vũ khí đi kèm là thanh Sword Mace cực kỳ hầm hố, tái hiện hoàn hảo ác quỷ đến từ Tekkadan.', N'Mô hình ASW-G-08 Gundam Barbatos Lupus tỷ lệ 1/100 (Full Mechanics). Sở hữu bộ khung Gundam Frame details ở ngực và chân. Vũ khí đi kèm là thanh Sword Mace cực kỳ hầm hố, tái hiện hoàn hảo ác quỷ đến từ Tekkadan.', 0, 3230, 26),
(41, N'Divine Invoker Percival (Deluxe Edition) 1/100', N'Divine Invoker Percival (Deluxe Edition) 1/100', N'divine-invoker-percival-deluxe-edition-1100', 2, 2, N'BANDAI', 1200000, N'Mô hình mecha thứ 3rd-party Divine Invoker Percival bản Deluxe tỷ lệ 1/100. Kèm vô số trang bị, phễu funnel, đao kiếm và part hiệu ứng ánh sáng. Khung xương chắc chắn chịu lực tốt.', N'Mô hình mecha thứ 3rd-party Divine Invoker Percival bản Deluxe tỷ lệ 1/100. Kèm vô số equipped with, phễu funnel, đao kiếm và part hiệu ứng ánh sáng. Inner frame skeleton chắc chắn chịu lực tốt.', 0, 1023, 10),
(42, N'RX-0 Full Armor Unicorn Gundam RG 1/144', N'RX-0 Full Armor Unicorn Gundam RG 1/144', N'rx-0-full-armor-unicorn-gundam-rg-1144', 2, 4, N'BANDAI', 1600000, N'RX-0 Full Armor Unicorn Gundam 1/144 Real Grade. Trang bị khung xương Advanced MS Joint cho phép biến hình qua lại giữa Unicorn Mode và Destroy Mode. Kho vũ khí khổng lồ gắn đầy trên lưng và khiên tay.', N'RX-0 Full Armor Unicorn Gundam 1/144 Real Grade. Trang bị inner frame skeleton Advanced MS Joint cho phép biến hình qua lại giữa Unicorn Mode và Destroy Mode. Kho vũ khí khổng lồ gắn đầy trên lưng và khiên tay.', 0, 2101, 31),
(43, N'Firelord Awakening Armament 1/100', N'Firelord Awakening Armament 1/100', N'firelord-awakening-armament-1100', 2, 2, N'BANDAI', 1100000, N'Mô hình mecha Firelord Awakening Armament tỷ lệ 1/100. Kiểu dáng sắc sảo, đi kèm một thanh cự kiếm năng lượng và hệ thống cánh hỏa tiễn phía sau lưng. Decal nước dạ quang tinh tế.', N'Mô hình mecha Firelord Awakening Armament tỷ lệ 1/100. Kiểu dáng sắc sảo, đi kèm một thanh cự kiếm năng lượng và hệ thống cánh hỏa tiễn phía sau lưng. Decal nước dạ quang tinh tế.', 0, 1056, 38),
(44, N'ZGMF-X56S/α Force Impulse Gundam Spec II RG 1/144', N'ZGMF-X56S/α Force Impulse Gundam Spec II RG 1/144', N'zgmf-x56s-force-impulse-gundam-spec-ii-rg-1144', 2, 4, N'BANDAI', 850000, N'ZGMF-X56S/α Force Impulse Gundam Spec II 1/144 RG (Màu mới từ movie SEED Freedom). Hệ thống tách lắp Core Splendor, Chest Flyer và Leg Flyer hoạt động trơn tru mà không làm mất đi độ vững chắc của khớp.', N'ZGMF-X56S/α Force Impulse Gundam Spec II 1/144 RG (Màu mới từ movie SEED Freedom). Hệ thống tách lắp Core Splendor, Chest Flyer và Leg Flyer hoạt động trơn tru mà không làm mất đi độ vững chắc của khớp.', 0, 1338, 43),
(45, N'ZGMF-X20A Strike Freedom Gundam MGEX 1/100', N'ZGMF-X20A Strike Freedom Gundam MGEX 1/100', N'zgmf-x20a-strike-freedom-gundam-mgex-1100', 2, 5, N'BANDAI', 3800000, N'ZGMF-X20A Strike Freedom Gundam 1/100 MGEX (Master Grade Extreme). Đỉnh cao của Bandai với hệ khung xương được kết hợp từ 3 lớp mạ vàng (Gold Coating) khác nhau. Biên độ cử động đạt mức hoàn hảo để pose dáng bắn súng liên thanh.', N'ZGMF-X20A Strike Freedom Gundam 1/100 MGEX (Master Grade Extreme). Đỉnh cao của Bandai với hệ inner frame skeleton được kết hợp từ 3 lớp mạ vàng (Gold Coating) khác nhau. Biên độ cử động đạt mức hoàn hảo để pose dáng bắn súng liên thanh.', 0, 4199, 27),
(46, N'GF13-017NJ II God Gundam RG 1/144', N'GF13-017NJ II God Gundam RG 1/144', N'gf13-017nj-ii-god-gundam-rg-1144', 2, 4, N'BANDAI', 850000, N'GF13-017NJ II God Gundam 1/144 RG từ G Gundam. Được mệnh danh là "ông vua tạo dáng" với các khớp vai và háng mới, cho phép thực hiện tư thế vắt chéo chân hoặc tung cú đấm Bakunetsu God Finger đặc trưng.', N'GF13-017NJ II God Gundam 1/144 RG từ G Gundam. Được mệnh danh là "ông vua tạo dáng" với các khớp vai và háng mới, cho phép thực hiện tư thế vắt chéo chân hoặc tung cú đấm Bakunetsu God Finger đặc trưng.', 0, 2497, 47),
(47, N'gMS-Ω GQuuuuuuX HG 1/144', N'gMS-Ω GQuuuuuuX HG 1/144', N'gms-gquuuuuux-hg-1144', 2, 1, N'BANDAI', 500000, N'Mô hình gMS-Ω GQuuuuuuX tỷ lệ 1/144 HG (từ vũ trụ Gundam GQuuuuuuX). Mang thiết kế hình dáng rất dị biệt cùng khoang lái hở độc đáo, các dải cảm biến uốn lượn trải dọc cơ thể.', N'Mô hình gMS-Ω GQuuuuuuX tỷ lệ 1/144 HG (từ vũ trụ Gundam GQuuuuuuX). Mang thiết kế hình dáng rất dị biệt cùng khoang lái hở độc đáo, các dải cảm biến uốn lượn trải dọc cơ thể.', 0, 1320, 30),
(48, N'RX-78-2 Gundam [Beyond Global] HG 1/144', N'RX-78-2 Gundam [Beyond Global] HG 1/144', N'rx-78-2-gundam-beyond-global-hg-1144', 2, 1, N'BANDAI', 450000, N'RX-78-2 Gundam bản Beyond Global kỷ niệm 40 năm. Tái cấu trúc hoàn toàn tỷ lệ cơ thể với phần đùi thon gọn và tay dài, mang lại vẻ thanh thoát và khả năng cử động siêu việt.', N'RX-78-2 Gundam bản Beyond Global kỷ niệm 40 năm. Tái cấu trúc hoàn toàn tỷ lệ cơ thể với phần đùi thon gọn và tay dài, mang lại vẻ thanh thoát và khả năng cử động siêu việt.', 0, 2859, 20),
(49, N'RX-78-2 Gundam PG Unleashed 1/60', N'RX-78-2 Gundam PG Unleashed 1/60', N'rx-78-2-gundam-pg-unleashed-160', 2, 3, N'BANDAI', 5000000, N'Mô hình 1/60 PG Unleashed RX-78-2. Trải nghiệm lắp ráp chia làm 5 giai đoạn từ khung xương đến lớp giáp ngoài. Hệ thống đèn LED đổi màu cực sáng ở mắt, ngực và beam saber. Đóng mở giáp toàn thân.', N'Mô hình 1/60 PG Unleashed RX-78-2. Trải nghiệm assembly chia làm 5 giai đoạn từ inner frame skeleton đến lớp giáp ngoài. Hệ thống đèn LED đổi màu cực sáng ở mắt, ngực và beam saber. Đóng mở giáp toàn thân.', 0, 5191, 5),
(50, N'RX-93 v Gundam (Nu Gundam) 1/60', N'RX-93 v Gundam (Nu Gundam) 1/60', N'rx-93-v-gundam-nu-gundam-160', 2, 3, N'BANDAI', 6500000, N'Mô hình RX-93 v Gundam siêu lớn (1/60). Trang bị đầy đủ 6 ống Fin Funnel gắn trên lưng, chi tiết áo giáp được phân mảng màu phức tạp, kèm theo hệ thống giá đỡ cực kì chắc chắn.', N'Mô hình RX-93 v Gundam siêu lớn (1/60). Trang bị đầy đủ 6 ống Fin Funnel gắn trên lưng, details áo giáp được phân mảng màu phức tạp, kèm theo hệ thống giá đỡ cực kì chắc chắn.', 0, 3472, 22),
(51, N'XXXG-00W0 Wing Gundam Zero EW Ver.Ka MG 1/100', N'XXXG-00W0 Wing Gundam Zero EW Ver.Ka MG 1/100', N'xxxg-00w0-wing-gundam-zero-ew-verka-mg-1100', 2, 2, N'BANDAI', 1500000, N'XXXG-00W0 Wing Gundam Zero Custom (Endless Waltz) Ver.Ka 1/100 MG. Đôi cánh thiên thần được thiết kế lại bởi Hajime Katoki với khả năng mở rộng như giấu vũ khí. Biến hình thành dạng Neo-Bird Mode.', N'XXXG-00W0 Wing Gundam Zero Custom (Endless Waltz) Ver.Ka 1/100 MG. Đôi cánh thiên thần được thiết kế lại bởi Hajime Katoki với khả năng mở rộng như giấu vũ khí. Biến hình thành dạng Neo-Bird Mode.', 0, 1422, 30),
(52, N'MSZ-006 Zeta Gundam RG 1/144', N'MSZ-006 Zeta Gundam RG 1/144', N'msz-006-zeta-gundam-rg-1144', 2, 4, N'BANDAI', 750000, N'MSZ-006 Zeta Gundam 1/144 RG. Một kỳ quan kỹ thuật của Bandai ở tỷ lệ nhỏ khi cho phép biến hình hoàn toàn sang phi thuyền Waverider mà không cần tháo rời bất kì part nào.', N'MSZ-006 Zeta Gundam 1/144 RG. Một kỳ quan kỹ thuật của Bandai ở tỷ lệ nhỏ khi cho phép biến hình hoàn toàn sang phi thuyền Waverider mà không cần tháo rời bất kì part nào.', 0, 1650, 0),
(53, N'Action Figure Eren Yeager', N'Action Figure Eren Yeager', N'action-figure-eren-yeager', 3, 8, N'BANDAI', 1600000, N'- Loại mô hình: Action Figure.
- Chiều cao: Khoảng 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Hệ thống khớp siêu linh hoạt.
- Phụ kiện: Các bộ phận thay thế và part hiệu ứng.', N'- Loại mô hình: Action Figure.
- Height: Approx 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Super flexible joint system.
- Accessories: Các bộ phận thay thế và part effect parts.', 0, 1723, 0),
(54, N'Nendoroid Gawr Gura', N'Nendoroid Gawr Gura', N'nendoroid-gawr-gura', 3, 8, N'GSC', 1600000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Thiết kế mũ cá mập có thể tháo rời. Khớp nối chắc chắn.
- Phụ kiện: Đinh ba, thú cưng Bloop, các khuôn mặt thay thế (cười, há miệng cá mập).', N'- Model type: Nendoroid (Chibi Action Figure).
- Height: Approx 10cm.
- Material: Premium PVC, ABS.
- Highlights: Design of mũ cá mập có thể tháo rời. Khớp nối chắc chắn.
- Accessories: Đinh ba, thú cưng Bloop, các faces thay thế (cười, há miệng cá mập).', 0, 2582, 45),
(55, N'Figma Levi Ackerman', N'Figma Levi Ackerman', N'figma-levi-ackerman', 3, 8, N'MAXFACTORY', 1800000, N'- Loại mô hình: Action Figure (Figma).
- Tỷ lệ: Cao khoảng 14-15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Cấu trúc khớp nối figma độc quyền giúp giữ dáng rất cứng cáp.
- Phụ kiện: Bộ thiết bị cơ động 3D chi tiết, áo choàng, tay và mặt thay thế.', N'- Loại mô hình: Action Figure (Figma).
- Tỷ lệ: Cao khoảng 14-15cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Cấu trúc khớp nối figma độc quyền giúp giữ dáng rất cứng cáp.
- Accessories: Bộ thiết bị cơ động 3D detailed, áo choàng, tay và mặt thay thế.', 0, 1147, 8),
(56, N'Nendoroid Link (Breath of the Wild)', N'Nendoroid Link (Breath of the Wild)', N'nendoroid-link-breath-of-the-wild', 3, 8, N'GSC', 1300000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Cử động linh hoạt ở các khớp vai, háng. Sơn nhám mờ đẹp mắt.
- Phụ kiện: Cung tên, mũi tên cổ đại, khiên Hylian, thanh gươm Master Sword.', N'- Model type: Nendoroid (Chibi Action Figure).
- Height: Approx 10cm.
- Material: Premium PVC, ABS.
- Highlights: Cử động linh hoạt ở các khớp vai, háng. Sơn nhám mờ đẹp mắt.
- Accessories: Cung tên, mũi tên cổ đại, khiên Hylian, thanh gươm Master Sword.', 0, 2309, 11),
(57, N'S.H.Figuarts Luffy (Onigashima)', N'S.H.Figuarts Luffy (Onigashima)', N'shfiguarts-luffy-onigashima', 3, 8, N'BANDAI', 1100000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 14.5cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Biên độ cử động cực lớn nhờ khớp vai dạng bướm và khớp hông cải tiến. Có thể tạo dáng hành động dễ dàng.
- Phụ kiện: Các bàn tay thay thế, khuôn mặt biểu cảm khác nhau.', N'- Model type: Action Figure (Poseable).
- Height: Approx 14.5cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Biên độ cử động cực lớn nhờ khớp vai dạng bướm và khớp hông cải tiến. Có thể tạo dáng hành động dễ dàng.
- Accessories: Các bàn tay thay thế, faces expressions khác nhau.', 0, 4296, 33),
(58, N'Chibi Makima (Chainsaw Man)', N'Chibi Makima (Chainsaw Man)', N'chibi-makima-chainsaw-man', 3, 8, N'MAXFACTORY', 2600000, N'- Loại mô hình: Action Figure Chibi.
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Sơn hoàn thiện sắc nét, thể hiện đúng phong thái điềm tĩnh của nhân vật.
- Phụ kiện: 3 biểu cảm khuôn mặt, tay tạo dáng hình khẩu súng.', N'- Loại mô hình: Action Figure Chibi.
- Height: Approx 10cm.
- Material: Premium PVC, ABS.
- Highlights: Sơn hoàn thiện sắc nét, thể hiện đúng phong thái điềm tĩnh của nhân vật.
- Accessories: 3 expressions faces, tay tạo dáng hình khẩu súng.', 0, 1043, 11),
(59, N'Nendoroid Naruto Uzumaki', N'Nendoroid Naruto Uzumaki', N'nendoroid-naruto-uzumaki', 3, 8, N'GSC', 1100000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Thiết kế tỷ lệ đầu to dễ thương nhưng vẫn rất năng động.
- Phụ kiện: Bàn tay thay thế, khuôn mặt, phi tiêu kunai và part hiệu ứng Rasengan.', N'- Model type: Nendoroid (Chibi Action Figure).
- Height: Approx 10cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Design of tỷ lệ đầu to dễ thương nhưng vẫn rất năng động.
- Accessories: Bàn tay thay thế, faces, phi tiêu kunai và part effect parts Rasengan.', 0, 3208, 39),
(60, N'Nendoroid Power (Chainsaw Man)', N'Nendoroid Power (Chainsaw Man)', N'nendoroid-power-chainsaw-man', 3, 8, N'GSC', 1500000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Mô phỏng hoàn hảo các chi tiết sừng trên đầu. Khớp cổ linh hoạt.
- Phụ kiện: Búa máu khổng lồ, mèo Meowy, tay và mặt thay thế.', N'- Model type: Nendoroid (Chibi Action Figure).
- Height: Approx 10cm.
- Material: Premium PVC, ABS.
- Highlights: Mô phỏng hoàn hảo các detailed sừng trên đầu. Khớp cổ linh hoạt.
- Accessories: Búa máu giant, mèo Meowy, tay và mặt thay thế.', 0, 1497, 42),
(61, N'S.H.Figuarts Kyojuro Rengoku', N'S.H.Figuarts Kyojuro Rengoku', N'shfiguarts-kyojuro-rengoku', 3, 8, N'ANIPLEX', 2500000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Áo choàng có khớp nối rời, hỗ trợ tạo hiệu ứng gió bay.
- Phụ kiện: Nhật luân kiếm (Nichirin Sword), mặt thay thế, các part bàn tay.', N'- Model type: Action Figure (Poseable).
- Height: Approx 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Áo choàng có khớp nối rời, hỗ trợ tạo effect parts gió bay.
- Accessories: Nhật luân kiếm (Nichirin Sword), mặt thay thế, các part bàn tay.', 0, 4388, 48),
(62, N'S.H.Figuarts Spider-Man (No Way Home)', N'S.H.Figuarts Spider-Man (No Way Home)', N'shfiguarts-spider-man-no-way-home', 3, 8, N'BANDAI', 2400000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Cấu trúc khớp cơ thể siêu linh hoạt, tối ưu cho các tư thế đu người, nhện bò sát sàn.
- Phụ kiện: Sợi tơ nhện (ngắn/dài), mắt thay thế, bàn tay tạo dáng.', N'- Model type: Action Figure (Poseable).
- Height: Approx 15cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Cấu trúc khớp cơ thể siêu linh hoạt, tối ưu cho các tư thế đu người, nhện bò sát sàn.
- Accessories: Sợi tơ nhện (ngắn/dài), mắt thay thế, bàn tay tạo dáng.', 0, 1422, 31),
(63, N'S.H.Figuarts Sasuke Uchiha', N'S.H.Figuarts Sasuke Uchiha', N'shfiguarts-sasuke-uchiha', 3, 8, N'MAXFACTORY', 1700000, N'- Loại mô hình: Action Figure có khớp.
- Chiều cao: Khoảng 14.5cm.
- Chất liệu: Nhựa PVC, ABS.
- Điểm nổi bật: Trang phục được đúc mềm giúp không cản trở biên độ khớp gối.
- Phụ kiện: Kiếm Kusanagi (trong bao và rút ra), mặt Sharingan/Rinnegan, part hiệu ứng Chidori.', N'- Model type: Action Figure (Poseable).
- Height: Approx 14.5cm.
- Chất liệu: Nhựa PVC, ABS.
- Highlights: Trang phục được đúc mềm giúp không cản trở biên độ khớp gối.
- Accessories: Kiếm Kusanagi (trong bao và rút ra), mặt Sharingan/Rinnegan, part effect parts Chidori.', 0, 2254, 24),
(64, N'Nendoroid Yor Forger', N'Nendoroid Yor Forger', N'nendoroid-yor-forger', 3, 8, N'GSC', 1500000, N'- Loại mô hình: Nendoroid (Action Figure Chibi).
- Chiều cao: Khoảng 10cm.
- Chất liệu: Nhựa PVC & ABS cao cấp.
- Điểm nổi bật: Sơn kim loại nổi bật trên các phụ kiện ám khí.
- Phụ kiện: Trâm ám sát màu vàng, các khuôn mặt đỏ mặt/chiến đấu.', N'- Model type: Nendoroid (Chibi Action Figure).
- Height: Approx 10cm.
- Material: Premium PVC, ABS.
- Highlights: Metallic paint highlights trên các accessories ám khí.
- Accessories: Trâm ám sát màu vàng, các faces đỏ mặt/chiến đấu.', 0, 1058, 45),
(65, N'Scale Figure 1/4 2B (YoRHa No.2 Type B)', N'Scale Figure 1/4 2B (YoRHa No.2 Type B)', N'scale-figure-14-2b-yorha-no2-type-b', 3, 9, N'FLARE', 7000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/4 (Chiều cao siêu khủng).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Không có khớp nối, tập trung vào độ sắc nét và điêu khắc trang phục chi tiết. Thanh kiếm Virtuous Contract được chế tác tỉ mỉ with vân kim loại.', N'- Model type: Scale Figure (Static).
- Scale: 1/4 (Giant height).
- Material: Premium PVC, ABS.
- Highlights: Không có khớp nối, tập trung vào độ sắc nét và điêu khắc costume detailed. Thanh kiếm Virtuous Contract được chế tác tỉ mỉ with vân kim loại.', 0, 2034, 24),
(66, N'Scale Figure 1/7 Albedo (So-Bin Ver)', N'Scale Figure 1/7 Albedo (So-Bin Ver)', N'scale-figure-17-albedo-so-bin-ver', 3, 9, N'UNION', 5500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26-28cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Đôi cánh thiên thần sa ngã được đổ khuôn with độ chi tiết lông vũ cực cao. Nước sơn tạo hiệu ứng đổ bóng sâu.', N'- Model type: Scale Figure (Static).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26-28cm).
- Material: Premium PVC, ABS.
- Highlights: Đôi cánh thiên thần sa ngã được đổ khuôn with độ detailed lông vũ cực cao. Nước sơn tạo effect parts đổ bóng sâu.', 0, 1454, 36),
(67, N'Scale Figure 1/7 Ganyu (Plenilune Gaze)', N'Scale Figure 1/7 Ganyu (Plenilune Gaze)', N'scale-figure-17-ganyu-plenilune-gaze', 3, 9, N'APEXTOYS', 4500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Trang phục và lụa quấn được sơn hiệu ứng bán trong suốt. Sa bàn (Base) đi kèm họa tiết hoa văn cực kì tinh tế.', N'- Model type: Scale Figure (Static).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26cm).
- Material: Premium PVC, ABS.
- Highlights: Trang phục và lụa quấn được sơn effect parts bán trong suốt. Sa bàn (Base) đi kèm họa tiết hoa văn cực kì tinh tế.', 0, 3128, 48),
(68, N'Scale Figure 1/7 Kurumi Tokisaki (Zafkiel)', N'Scale Figure 1/7 Kurumi Tokisaki (Zafkiel)', N'scale-figure-17-kurumi-tokisaki-zafkiel', 3, 9, N'KADOKAWA', 6000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 25cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Chi tiết nếp gấp bèo nhún trên bộ váy Astral Dress được khắc họa sống động. Phụ kiện súng trường và súng ngắn sơn giả kim.', N'- Model type: Scale Figure (Static).
- Scale: 1/7 (Height approx 25cm).
- Material: Premium PVC, ABS.
- Highlights: Detailed nếp gấp bèo nhún trên bộ váy Astral Dress được khắc họa sống động. Phụ kiện súng trường và súng ngắn sơn giả kim.', 0, 2111, 16),
(69, N'Scale Figure 1/7 Makima (Chainsaw Man)', N'Scale Figure 1/7 Makima (Chainsaw Man)', N'scale-figure-17-makima-chainsaw-man', 3, 9, N'ESTREAM', 8500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 24-25cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Tỷ lệ cơ thể cực chuẩn, trang phục được chế tác phức tạp đi kèm with các mảnh vỡ sa bàn dưới chân tạo hiệu ứng đẫm máu cực đẹp.', N'- Model type: Scale Figure (Static).
- Tỷ lệ: 1/7 (Chiều cao khoảng 24-25cm).
- Material: Premium PVC, ABS.
- Highlights: Tỷ lệ cơ thể cực chuẩn, costume được chế tác phức tạp đi kèm with các mảnh vỡ sa bàn dưới chân tạo effect parts đẫm máu cực đẹp.', 0, 1094, 20),
(70, N'Scale Figure 1/7 Milim Nava', N'Scale Figure 1/7 Milim Nava', N'scale-figure-17-milim-nava', 3, 9, N'ESPADA', 7000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 23cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Màu sơn neon rực rỡ, chi tiết tóc 2 chùm sắc nhọn và hiệu ứng base sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Vibrant neon paint finish, sharp twin-tails and dynamic stand.', 0, 870, 23),
(71, N'Scale Figure 1/7 Ningguang (Gold Leaf Panel)', N'Scale Figure 1/7 Ningguang (Gold Leaf Panel)', N'scale-figure-17-ningguang-gold-leaf-panel', 3, 9, N'MIHOYO', 7500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 28cm bao gồm diorama).
- Chất liệu: Nhựa PVC, ABS, Acrylic.
- Điểm nổi bật: Khối lượng cực nặng with sa bàn (diorama) hoành tráng đi kèm bối cảnh đồ sộ, ống điếu và hiệu ứng ánh sáng.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Magnificent diorama background, elegant posture and lighting details.', 0, 1205, 9),
(72, N'Scale Figure 1/7 Raiden Shogun (Statue)', N'Scale Figure 1/7 Raiden Shogun (Statue)', N'scale-figure-17-raiden-shogun-statue', 3, 9, N'APEXTOYS', 10000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 28-30cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Khắc họa chi tiết hoa văn trên áo Kimono. Part thanh kiếm Musou no Hitotachi làm bằng nhựa trong suốt ánh điện tím.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Pulling the Musou no Hitotachi sword, incredible kimono pattern detailing.', 0, 3176, 7),
(73, N'Scale Figure 1/7 Rem (Crystal Dress Ver)', N'Scale Figure 1/7 Rem (Crystal Dress Ver)', N'scale-figure-17-rem-crystal-dress-ver', 3, 9, N'ESTREAM', 12000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 23cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Chiếc váy pha lê lấp lánh phản quang vô cùng rực rỡ, cùng hàng tá hiệu ứng ánh sáng xung quanh tạo cảm giác bùng nổ.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Stunning sparkling crystal dress with reflective blue lighting effect parts.', 0, 5497, 44),
(74, N'Scale Figure 1/7 Saber Alter Kimono ver', N'Scale Figure 1/7 Saber Alter Kimono ver', N'scale-figure-17-saber-alter-kimono-ver', 3, 9, N'ALTER', 9500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 25cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Áo Kimono lụa đen huyền bí, phong cách ma mị nhưng đậm chất quý tộc. Họa tiết trên tà áo được in sắc nét.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Mysterious black silk Kimono with gold noble patterns. Beautiful traditional fan and sword.', 0, 1083, 47),
(75, N'Bunny Girl Senpai 1/4 Mai Sakurajima', N'Bunny Girl Senpai 1/4 Mai Sakurajima', N'bunny-girl-senpai-14-mai-sakurajima', 3, 9, N'FREEING', 8500000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/4 (Chiều cao khủng 40cm).
- Chất liệu: Nhựa PVC, ABS, Vải.
- Điểm nổi bật: Vớ lưới được làm bằng chất liệu vải lưới thật sự căng ôm sát, đem đến trải nghiệm vô cùng cao cấp.', N'Scale: 1/4 Scale Figure. – Material: Premium PVC, ABS, Fabric. – Features: High-end real fabric fishnet stockings stretched perfectly for a premium texture.', 0, 2211, 6),
(76, N'Scale Figure 1/7 Yae Miko (Astute Amusement)', N'Scale Figure 1/7 Yae Miko (Astute Amusement)', N'scale-figure-17-yae-miko-astute-amusement', 3, 9, N'KOTO', 5000000, N'- Loại mô hình: Scale Figure (Mô hình tĩnh).
- Tỷ lệ: 1/7 (Chiều cao khoảng 26-27cm).
- Chất liệu: Nhựa PVC, ABS nguyên sinh.
- Điểm nổi bật: Trang phục đền thần Miko lộng lẫy, nhiều phụ kiện tinh xảo (trâm cài, lục lạc, quyền trượng).', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Gorgeous traditional shrine maiden Miko outfit. Includes kagura bell and sacred wand.', 0, 1069, 25),
(77, N'Bộ sơn Acrysion Starter Set (6 màu)', N'Mr.Hobby Acrysion Starter Set (6 Colors)', N'b-sn-acrysion-starter-set-6-mu', 4, 10, N'MRHOBBY', 300000, N'Bộ sơn Acrylic Acrysion cơ bản (6 màu) của Mr.Hobby. Ưu điểm: thân thiện with môi trường, ít mùi độc hại, an toàn khi sử dụng trong nhà không thoáng khí, độ bám dính cực tốt trên nền nhựa.', N'Mr.Hobby Acrysion starter acrylic paint set (6 colors). Features: environmentally friendly, low odor, safe for indoor use, excellent adhesion on plastic surfaces.', 0, 837, 12),
(78, N'Kềm cắt nhựa 1 lưỡi DSPIAE ST-A 3.0 Single Blade Nipper', N'DSPIAE ST-A 3.0 Single Blade Nipper', N'km-ct-nha-1-li-dspiae-st-a-30-single-blade-nipper', 4, 10, N'DSPIAE', 650000, N'Kềm cắt nhựa 1 lưỡi siêu bén của hãng DSPIAE. Lưỡi kềm được rèn nhiệt luyện sắc ngọt, giúp cắt part nhựa sát chân gate mà không làm trắng nhựa hay để lại vết sẹo (nub mark). Thiết kế tay cầm chắc chắn chống mỏi.', N'DSPIAE ST-A 3.0 professional single-blade plastic nipper. Ultra-sharp heat-treated blade allows flush cuts near gates without stress-whitening plastic.', 0, 1382, 26),
(79, N'Kềm cắt nhựa cơ bản Tamiya 74093 Entry Nipper', N'Tamiya 74093 Entry Nipper', N'km-ct-nha-c-bn-tamiya-74093-entry-nipper', 4, 10, N'TAMIYA', 150000, N'Kềm cắt nhựa cơ bản (Entry Nipper) phù hợp cho người mới bắt đầu. Lưỡi kềm dày dặn, cứng cáp, chịu lực tốt, lý tưởng để cắt ròng (runner) các chi tiết lớn trước khi xử lý tinh bằng kềm 1 lưỡi.', N'Tamiya 74093 entry-level plastic nipper for beginners. Thick, durable blades with excellent strength, ideal for cutting runners before detail cleanup.', 0, 589, 18),
(80, N'Bút tăng độ cứng khớp Tamiya 87182 Joint Strength Pen', N'Tamiya 87182 Joint Strength Pen', N'bt-tng-cng-khp-tamiya-87182-joint-strength-pen', 4, 10, N'TAMIYA', 120000, N'Dung dịch chuyên dụng dạng bút giúp phục hồi các khớp mô hình bị lỏng lẻo sau thời gian dài tạo dáng. Chỉ cần bôi một lớp mỏng vào phần chốt bi (ball joint) and chờ khô, khớp sẽ cứng cáp lại như mới.', N'Tamiya 87182 Joint Strength Pen. Specialized liquid pen to restore loose ball joints on models. Simply apply a thin layer and let dry for tight joints.', 0, 472, 16),
(81, N'Bút kẻ lằn chìm Tamiya Panel Line Marker', N'Tamiya Panel Line Marker', N'bt-k-ln-chm-tamiya-panel-line-marker', 4, 10, N'TAMIYA', 60000, N'Bút kẻ lằn chìm ngòi siêu nhỏ. Giúp làm nổi bật các rãnh, chi tiết cơ khí trên áo giáp mô hình Gundam. Nét mực ra đều, dễ dàng xóa phần lem bằng gôm/tẩy.', N'Tamiya Panel Line Marker with ultra-fine tip. Helps highlight panel lines and mechanical details on Gundam armor. Flow is smooth, easily erased with rubber.', 0, 875, 26),
(82, N'Băng keo che sơn Tamiya Masking Tape 18mm', N'Tamiya Masking Tape 18mm', N'bng-keo-che-sn-tamiya-masking-tape-18mm', 4, 10, N'TAMIYA', 80000, N'Băng keo chuyên dụng trong kỹ thuật sơn mô hình (Masking). Có độ dẻo dai bám dính tốt trên các mặt cong and đặc biệt không để lại vệt keo thừa khi lột ra. Ngăn sơn rỉ sang các mảng màu khác.', N'Tamiya specialized masking tape (18mm) for model painting. Excellent adhesion on curved surfaces and leaves no glue residue when peeled off.', 0, 317, 13),
(83, N'Dung dịch dán decal nước Mr.Hobby Mark Setter (MS232)', N'Mr.Hobby Mark Setter (MS232)', N'dung-dch-dn-decal-nc-mrhobby-mark-setter-ms232', 4, 10, N'MRHOBBY', 85000, N'Dung dịch dán decal nước Mark Setter của Mr.Hobby. Chứa thành phần keo nhẹ giúp decal nước bám dính chắc chắn hơn vào bề mặt nhựa, chống hiện tượng bong tróc sau khi khô.', N'Mr.Hobby Mark Setter decal adhesive solution. Contains a mild adhesive that secures water decals firmly to plastic surfaces, preventing peeling.', 0, 1456, 49),
(84, N'Dung dịch làm mềm decal nước Mr.Hobby Mark Softer (MS231)', N'Mr.Hobby Mark Softer (MS231)', N'dung-dch-lm-mm-decal-nc-mrhobby-mark-softer-ms231', 4, 10, N'MRHOBBY', 85000, N'Dung dịch làm mềm decal nước Mark Softer. Thẩm thấu vào decal giúp chúng mềm ra, ôm sát hoàn hảo vào các bề mặt gồ ghề, lồi lõm hoặc khe nếp gấp sâu của mô hình.', N'Mr.Hobby Mark Softer decal softening solution. Penetrates decals to make them soft, conforming perfectly to curved or textured surfaces.', 0, 543, 48),
(85, N'Keo dán nhựa chảy siêu lỏng Mr.Hobby Mr.Cement SP (MC129)', N'Mr.Hobby Mr.Cement SP (MC129)', N'keo-dn-nha-chy-siu-lng-mrhobby-mrcement-sp-mc129', 4, 10, N'MRHOBBY', 90000, N'Keo dán nhựa chảy siêu lỏng (Thin Cement). Hoạt động bằng cơ chế làm chảy and hàn dính 2 mép nhựa PS/ABS lại with nhau. Keo khô siêu tốc, giúp các vết nối dính chặt mà không để lại lớp keo cộm.', N'Mr.Hobby Mr.Cement SP super thin plastic cement. Melts and welds PS/ABS plastics together. Dries instantly, leaving clean joins with no excess residue.', 0, 844, 31),
(86, N'Bộ kẹp sơn 20 que và đế cắm Tamiya Spray Work Painting Stand', N'Tamiya Spray Work Painting Stand (20 Clips)', N'b-kp-sn-20-que-v-cm-tamiya-spray-work-painting-stand', 4, 10, N'TAMIYA', 150000, N'Bộ phụ kiện hỗ trợ quá trình phun sơn bằng súng phun (Airbrush) hoặc sơn lon. Gồm 20 kẹp sấu đính que cứng cáp giúp giữ chi tiết không chạm tay, kèm 1 đế xốp tổ ong để cắm que phơi khô.', N'Tamiya Spray Work painting stand set. Includes 20 high-quality alligator clips on wooden sticks and 1 honeycomb stand for holding parts while airbrushing.', 0, 450, 22),
(87, N'Mực kẻ lằn chìm Tamiya Panel Line Accent Color (Black) 40ml', N'Tamiya Panel Line Accent Color (Black) 40ml', N'mc-k-ln-chm-tamiya-panel-line-accent-color-black-40ml', 4, 10, N'TAMIYA', 120000, N'Lọ dung dịch mực kẻ lằn chìm pha sẵn siêu loãng của Tamiya. Đi kèm cọ cắm dưới nắp, chỉ cần chấm nhẹ vào rãnh panel, mực sẽ tự động mao dẫn chạy dọc theo khe rãnh cực kì đẹp.', N'Tamiya pre-thinned panel line accent color (Black). Features built-in cap brush, simply touch to panel lines and watch the paint flow beautifully.', 0, 1442, 37),
(88, N'Bộ dụng cụ cơ bản 7 món Tamiya Basic Tool Set (74016)', N'Tamiya Basic Tool Set (74016)', N'b-dng-c-c-bn-7-mn-tamiya-basic-tool-set-74016', 4, 10, N'TAMIYA', 200000, N'Bộ công cụ nhập môn bao gồm 7 món cơ bản: Kềm cắt nhựa, nhíp nhọn mũi cong/thẳng gắp decal, dao rọc giấy cán nhôm, bộ dũa nhỏ 3 cây. Giải pháp tiết kiệm nhưng đáp ứng đủ nhu cầu lắp ráp thô.', N'Tamiya 74016 basic tool set including 7 essential tools: Nipper, curved/straight tweezers, craft knife, and 3 mini files. Perfect for entry-level modelers.', 0, 512, 24),
(89, N'Nendoroid Xiao (Genshin Impact)', N'Nendoroid Xiao (Genshin Impact)', N'nendoroid-xiao-genshin-impact', 3, 8, N'GSC', 1650000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế Dạ Xoa Xiao with biểu cảm lạnh lùng, trang phục chi tiết and phụ kiện mặt nạ đặc trưng.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Design of Dạ Xoa Xiao with expressions lạnh lùng, costume detailed and accessories mặt nạ signature.', 0, 805, 10),
(90, N'Figma Nanami Kento', N'Figma Nanami Kento', N'figma-nanami-kento', 3, 8, N'MAXFACTORY', 1950000, N'Tỉ lệ: Action Figure cao khoảng 15cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Hệ khớp linh hoạt, tái hiện tạo hình Nanami with bộ vest lịch lãm and cà vạt đặc trưng.', N'Scale: Action Figure, height approx 15cm. – Material: Premium PVC, ABS. – Features: Poseable joints, recreates posing Nanami with bộ vest lịch lãm and cà vạt signature.', 0, 420, 10),
(91, N'S.H.Figuarts Spider-Punk', N'S.H.Figuarts Spider-Punk', N'shfiguarts-spider-punk', 3, 8, N'BANDAI', 2300000, N'Tỉ lệ: Action Figure cao khoảng 16cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế Spider-Verse nổi bật with phong cách punk, màu sắc cá tính and khả năng tạo dáng linh hoạt.', N'Scale: Action Figure, height approx 16cm. – Material: Premium PVC, ABS. – Features: Design of Spider-Verse nổi bật with style punk, màu sắc cá tính and high poseability.', 0, 1105, 10),
(92, N'Nendoroid Loid Forger', N'Nendoroid Loid Forger', N'nendoroid-loid-forger', 3, 8, N'GSC', 1350000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tạo hình điệp viên Loid với vest xanh sang trọng cùng nhiều biểu cảm đặc trưng.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Sculpt of điệp viên Loid với vest xanh elegant cùng nhiều expressions signature.', 0, 0, 10),
(93, N'Figma Usada Pekora', N'Figma Usada Pekora', N'figma-usada-pekora', 3, 8, N'MAXFACTORY', 5000000, N'Tỉ lệ: Action Figure cao khoảng 14cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế idol thỏ năng động với tai thỏ linh hoạt và màu sắc tươi sáng.', N'Scale: Action Figure, height approx 14cm. – Material: Premium PVC, ABS. – Features: Design of idol thỏ năng động với tai thỏ linh hoạt và bright colors.', 0, 0, 10),
(94, N'S.H.Figuarts Frieren', N'S.H.Figuarts Frieren', N'shfiguarts-frieren', 3, 8, N'BANDAI', 3000000, N'Tỉ lệ: Action Figure cao khoảng 14cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Trang phục pháp sư chi tiết, đi kèm hiệu ứng phép thuật và khả năng tạo dáng đa dạng.', N'Scale: Action Figure, height approx 14cm. – Material: Premium PVC, ABS. – Features: Trang phục pháp sư detailed, đi kèm effect parts phép thuật và khả năng tạo dáng đa dạng.', 0, 0, 10),
(95, N'Nendoroid Bocchi (Hitori Gotoh)', N'Nendoroid Bocchi (Hitori Gotoh)', N'nendoroid-bocchi-hitori-gotoh', 3, 8, N'GSC', 2000000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Biểu cảm đáng yêu tái hiện Bocchi với phong cách nhút nhát đặc trưng.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Biểu cảm cute recreates Bocchi với style nhút nhát signature.', 0, 0, 10),
(96, N'Figma Jiren (Dragon Ball Super)', N'Figma Jiren (Dragon Ball Super)', N'figma-jiren-dragon-ball-super', 3, 8, N'MAXFACTORY', 2600000, N'Tỉ lệ: Action Figure cao khoảng 17cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Cơ bắp sắc nét, hệ khớp linh hoạt và tạo hình chiến binh mạnh mẽ.', N'Scale: Action Figure, height approx 17cm. – Material: Premium PVC, ABS. – Features: Muscular sculpt, highly poseability joints và posing chiến binh mạnh mẽ.', 0, 0, 10),
(97, N'S.H.Figuarts Gabimaru', N'S.H.Figuarts Gabimaru', N'shfiguarts-gabimaru', 3, 8, N'BANDAI', 1550000, N'Tỉ lệ: Action Figure cao khoảng 15cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế ninja sát thủ với trang phục tối màu và hiệu ứng chiến đấu sống động.', N'Scale: Action Figure, height approx 15cm. – Material: Premium PVC, ABS. – Features: Design of ninja sát thủ với costume tối màu và effect parts chiến đấu sống động.', 0, 0, 10),
(98, N'Nendoroid Furina', N'Nendoroid Furina', N'nendoroid-furina', 3, 8, N'GSC', 2000000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tạo hình Furina sang trọng với phụ kiện vương miện và chi tiết trang phục tinh xảo.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Sculpt of Furina elegant với accessories vương miện và detailed costume tinh xảo.', 0, 0, 10),
(99, N'Figma Lady Maria', N'Figma Lady Maria', N'figma-lady-maria', 3, 8, N'MAXFACTORY', 4000000, N'Tỉ lệ: Action Figure cao khoảng 16cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế phong cách gothic với áo choàng dài và vũ khí đặc trưng của Bloodborne.', N'Scale: Action Figure, height approx 16cm. – Material: Premium PVC, ABS. – Features: Design of style gothic với áo choàng dài và vũ khí signature của Bloodborne.', 0, 0, 10),
(100, N'S.H.Figuarts Chainsaw Man (Samurai Sword)', N'S.H.Figuarts Chainsaw Man (Samurai Sword)', N'shfiguarts-chainsaw-man-samurai-sword', 3, 8, N'BANDAI', 2200000, N'Tỉ lệ: Action Figure cao khoảng 16cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế chiến đấu mạnh mẽ với chi tiết lưỡi cưa và hiệu ứng hành động nổi bật.', N'Scale: Action Figure, height approx 16cm. – Material: Premium PVC, ABS. – Features: Design of chiến đấu mạnh mẽ với detailed lưỡi cưa và effect parts hành động nổi bật.', 0, 0, 10),
(101, N'Nendoroid March 7th', N'Nendoroid March 7th', N'nendoroid-march-7th', 3, 8, N'GSC', 7500000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Phong cách dễ thương với mái tóc hồng nổi bật và nhiều biểu cảm sinh động.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Phong cách dễ thương với hair hồng nổi bật và nhiều expressions sinh động.', 0, 0, 10),
(102, N'Figma Ryuo Sukuna', N'Figma Ryuo Sukuna', N'figma-ryuo-sukuna', 3, 8, N'MAXFACTORY', 2100000, N'Tỉ lệ: Action Figure cao khoảng 18cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tạo hình Sukuna uy lực với hiệu ứng hỏa diễm và chi tiết cơ thể sắc nét.', N'Scale: Action Figure, height approx 18cm. – Material: Premium PVC, ABS. – Features: Sculpt of Sukuna uy lực với effect parts hỏa diễm và detailed cơ thể sắc nét.', 0, 0, 10),
(103, N'Nendoroid Dio Brando', N'Nendoroid Dio Brando', N'nendoroid-dio-brando', 3, 8, N'GSC', 1300000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế Dio với phong thái kiêu ngạo, biểu cảm đặc trưng và màu sắc nổi bật.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Design of Dio với arrogant posture, expressions signature và màu sắc nổi bật.', 0, 0, 10),
(104, N'Nendoroid Hoshimi Miyabi', N'Nendoroid Hoshimi Miyabi', N'nendoroid-hoshimi-miyabi', 3, 8, N'GSC', 3400000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tạo hình anime đáng yêu với chi tiết tóc và phụ kiện được hoàn thiện tỉ mỉ.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Sculpt of anime cute với detailed tóc và accessories được hoàn thiện tỉ mỉ.', 0, 0, 10),
(105, N'Figma Griffith (Femto)', N'Figma Griffith (Femto)', N'figma-griffith-femto', 3, 8, N'MAXFACTORY', 2700000, N'Tỉ lệ: Action Figure cao khoảng 17cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Bộ giáp tối màu chi tiết, áo choàng lớn và phong cách huyền bí đặc trưng.', N'Scale: Action Figure, height approx 17cm. – Material: Premium PVC, ABS. – Features: Bộ giáp tối màu detailed, large cape và style huyền bí signature.', 0, 0, 10),
(106, N'Nendoroid Suisei Hoshimachi', N'Nendoroid Suisei Hoshimachi', N'nendoroid-suisei-hoshimachi', 3, 8, N'GSC', 3600000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế idol dễ thương với mái tóc xanh và trang phục sân khấu nổi bật.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Design of idol dễ thương với hair xanh và costume sân khấu nổi bật.', 0, 0, 10),
(107, N'Nendoroid Albedo Dress Ver. - Overlord', N'Nendoroid Albedo Dress Ver. - Overlord', N'nendoroid-albedo-dress-ver-overlord', 3, 8, N'GSC', 2550000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tạo hình Albedo trong váy trắng sang trọng với đôi cánh và biểu cảm dịu dàng.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Sculpt of Albedo trong váy trắng elegant với wings và expressions dịu dàng.', 0, 0, 10),
(108, N'S.H.Figuarts Mikey (Manjiro Sano)', N'S.H.Figuarts Mikey (Manjiro Sano)', N'shfiguarts-mikey-manjiro-sano', 3, 8, N'BANDAI', 1850000, N'Tỉ lệ: Action Figure cao khoảng 15cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế đồng phục Tokyo Manji với tư thế chiến đấu linh hoạt.', N'Scale: Action Figure, height approx 15cm. – Material: Premium PVC, ABS. – Features: Design of uniform Tokyo Manji với tư thế chiến đấu linh hoạt.', 0, 0, 10),
(109, N'S.H.Figuarts Sanji (Raid Suit)', N'S.H.Figuarts Sanji (Raid Suit)', N'shfiguarts-sanji-raid-suit', 3, 8, N'BANDAI', 1450000, N'Tỉ lệ: Action Figure cao khoảng 16cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Bộ Raid Suit hiện đại cùng hiệu ứng lửa chân đặc trưng của Sanji.', N'Scale: Action Figure, height approx 16cm. – Material: Premium PVC, ABS. – Features: Bộ Raid Suit hiện đại cùng effect parts lửa chân signature của Sanji.', 0, 0, 10),
(110, N'Nendoroid Jiraiya', N'Nendoroid Jiraiya', N'nendoroid-jiraiya', 3, 8, N'GSC', 1350000, N'Tỉ lệ: Chibi Figure cao khoảng 10cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tái hiện Jiraiya với mái tóc trắng đặc trưng và biểu cảm hài hước.', N'Scale: Chibi Figure, height approx 10cm. – Material: Premium PVC, ABS. – Features: Tái hiện Jiraiya với hair trắng signature và expressions hài hước.', 0, 0, 10),
(111, N'S.H.Figuarts Yuji Itadori (Sukuna Ver)', N'S.H.Figuarts Yuji Itadori (Sukuna Ver)', N'shfiguarts-yuji-itadori-sukuna-ver', 3, 8, N'BANDAI', 1500000, N'Tỉ lệ: Action Figure cao khoảng 15cm. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Tạo hình Sukuna mạnh mẽ với biểu cảm dữ dằn và tư thế chiến đấu linh hoạt.', N'Scale: Action Figure, height approx 15cm. – Material: Premium PVC, ABS. – Features: Sculpt of Sukuna mạnh mẽ với expressions dữ dằn và tư thế chiến đấu linh hoạt.', 0, 0, 10),
(112, N'Raiden Shogun (Genshin Impact)', N'Raiden Shogun (Genshin Impact)', N'raiden-shogun-genshin-impact', 3, 9, N'MIHOYO', 12000000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(113, N'Makima (Chainsaw Man)', N'Makima (Chainsaw Man)', N'makima-chainsaw-man', 3, 9, N'OTHER', 7650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Biểu cảm lạnh lùng cùng trang phục công sở đặc trưng.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Biểu cảm lạnh lùng cùng costume công sở signature.', 0, 0, 10),
(114, N'Kafka (Honkai: Star Rail)', N'Kafka (Honkai: Star Rail)', N'kafka-honkai-star-rail', 3, 9, N'MIHOYO', 5550000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(115, N'Anya & YorForger', N'Anya & YorForger', N'anya-yorforger', 3, 9, N'GSC', 4000000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Trang phục sát thủ thanh lịch cùng tạo dáng mềm mại.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Trang phục sát thủ thanh lịch cùng tạo dáng mềm mại.', 0, 0, 10),
(116, N'Hutao (Genshin Impact)', N'Hutao (Genshin Impact)', N'hutao-genshin-impact', 3, 9, N'MIHOYO', 2650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(117, N'Power (Nurse Ver.)', N'Power (Nurse Ver.)', N'power-nurse-ver', 3, 9, N'OTHER', 10650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(118, N'Shenhe (Genshin Impact)', N'Shenhe (Genshin Impact)', N'shenhe-genshin-impact', 3, 9, N'MIHOYO', 7050000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(119, N'Tifa Lockhart (Sporty Ver.)', N'Tifa Lockhart (Sporty Ver.)', N'tifa-lockhart-sporty-ver', 3, 9, N'OTHER', 3550000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(120, N'Frieren (Starlight Journey)', N'Frieren (Starlight Journey)', N'frieren-starlight-journey', 3, 9, N'OTHER', 3650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(121, N'Acheron (Nihility Ver.)', N'Acheron (Nihility Ver.)', N'acheron-nihility-ver', 3, 9, N'OTHER', 8650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(122, N'Kamisato Ayaka', N'Kamisato Ayaka', N'kamisato-ayaka', 3, 9, N'MIHOYO', 2050000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(123, N'Miku (Rose Cage Ver.)', N'Miku (Rose Cage Ver.)', N'miku-rose-cage-ver', 3, 9, N'GSC', 4650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế Hatsune Miku với mái tóc dài đặc trưng và màu sắc nổi bật.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of Hatsune Miku với hair dài signature và màu sắc nổi bật.', 0, 0, 10),
(124, N'Firefly (Honkai: Star Rail)', N'Firefly (Honkai: Star Rail)', N'firefly-honkai-star-rail', 3, 9, N'MIHOYO', 3650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(125, N'Nilou (Lotus Dance)', N'Nilou (Lotus Dance)', N'nilou-lotus-dance', 3, 9, N'OTHER', 5650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(126, N'Eula (Lawrence Clan)', N'Eula (Lawrence Clan)', N'eula-lawrence-clan', 3, 9, N'OTHER', 9750000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(127, N'Shinobu Kochou', N'Shinobu Kochou', N'shinobu-kochou', 3, 9, N'OTHER', 4650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(128, N'Arlecchino (The Knave)', N'Arlecchino (The Knave)', N'arlecchino-the-knave', 3, 9, N'MIHOYO', 10650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(129, N'Violet Evergarden', N'Violet Evergarden', N'violet-evergarden', 3, 9, N'GSC', 5750000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(130, N'Bronya (Silverwing Ver.)', N'Bronya (Silverwing Ver.)', N'bronya-silverwing-ver', 3, 9, N'OTHER', 9550000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(131, N'Shana (Burning-Eyed)', N'Shana (Burning-Eyed)', N'shana-burning-eyed', 3, 9, N'OTHER', 4650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(132, N'Erza Scarlet (Bunny Ver.)', N'Erza Scarlet (Bunny Ver.)', N'erza-scarlet-bunny-ver', 3, 9, N'GSC', 6650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(133, N'Keqing (Dạ Hành Ver.)', N'Keqing (Dạ Hành Ver.)', N'keqing-d-hnh-ver', 3, 9, N'OTHER', 5650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Thiết kế anime chi tiết với màu sắc nổi bật và tạo hình sống động.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Design of anime detailed với outstanding colors and vivid posing.', 0, 0, 10),
(134, N'Asuna (Stacia Ver.)', N'Asuna (Stacia Ver.)', N'asuna-stacia-ver', 3, 9, N'GSC', 3650000, N'Tỉ lệ: Scale Figure 1/7. – Chất liệu: Nhựa PVC, ABS cao cấp. – Đặc điểm: Trang phục chiến đấu nổi bật cùng đường nét mềm mại.', N'Scale: 1/7 Scale Figure. – Material: Premium PVC, ABS. – Features: Trang phục chiến đấu nổi bật cùng đường nét mềm mại.', 0, 0, 10);
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
(333, 88, N'~/images/Tools/Tool-7-mon-1.png', 0),
(334, 89, N'~/images/Figure/ActionAndChibi/01_Xiao (1).jpg', 0),
(335, 89, N'~/images/Figure/ActionAndChibi/01_Xiao (2).jpg', 0),
(336, 89, N'~/images/Figure/ActionAndChibi/01_Xiao (3).jpg', 0),
(337, 89, N'~/images/Figure/ActionAndChibi/01_Xiao (4).jpg', 0),
(338, 89, N'~/images/Figure/ActionAndChibi/01_Xiao (5).jpg', 0),
(339, 89, N'~/images/Figure/ActionAndChibi/01_Xiao_Main.jpg', 1),
(340, 90, N'~/images/Figure/ActionAndChibi/02_KentoNanami (1).jpg', 0),
(341, 90, N'~/images/Figure/ActionAndChibi/02_KentoNanami (2).jpg', 0),
(342, 90, N'~/images/Figure/ActionAndChibi/02_KentoNanami (3).jpg', 0),
(343, 90, N'~/images/Figure/ActionAndChibi/02_KentoNanami (4).jpg', 0),
(344, 90, N'~/images/Figure/ActionAndChibi/02_KentoNanami (5).jpg', 0),
(345, 90, N'~/images/Figure/ActionAndChibi/02_KentoNanami_Main.jpg', 1),
(346, 91, N'~/images/Figure/ActionAndChibi/03_SpiderPunk (1).jpg', 0),
(347, 91, N'~/images/Figure/ActionAndChibi/03_SpiderPunk (2).jpg', 0),
(348, 91, N'~/images/Figure/ActionAndChibi/03_SpiderPunk (3).jpg', 0),
(349, 91, N'~/images/Figure/ActionAndChibi/03_SpiderPunk (4).jpg', 0),
(350, 91, N'~/images/Figure/ActionAndChibi/03_SpiderPunk (5).jpg', 0),
(351, 91, N'~/images/Figure/ActionAndChibi/03_SpiderPunk_Main.jpg', 1),
(352, 92, N'~/images/Figure/ActionAndChibi/04_LoidForger (1).jpg', 0),
(353, 92, N'~/images/Figure/ActionAndChibi/04_LoidForger (2).jpg', 0),
(354, 92, N'~/images/Figure/ActionAndChibi/04_LoidForger (3).jpg', 0),
(355, 92, N'~/images/Figure/ActionAndChibi/04_LoidForger_Main.jpg', 1),
(356, 93, N'~/images/Figure/ActionAndChibi/05_UsadaPekora (1).jpg', 0),
(357, 93, N'~/images/Figure/ActionAndChibi/05_UsadaPekora (2).jpg', 0),
(358, 93, N'~/images/Figure/ActionAndChibi/05_UsadaPekora (3).jpg', 0),
(359, 93, N'~/images/Figure/ActionAndChibi/05_UsadaPekora (4).jpg', 0),
(360, 93, N'~/images/Figure/ActionAndChibi/05_UsadaPekora (5).jpg', 0),
(361, 93, N'~/images/Figure/ActionAndChibi/05_UsadaPekora_Main.jpg', 1),
(362, 94, N'~/images/Figure/ActionAndChibi/06_Frieren (1).jpg', 0),
(363, 94, N'~/images/Figure/ActionAndChibi/06_Frieren (2).jpg', 0),
(364, 94, N'~/images/Figure/ActionAndChibi/06_Frieren (3).jpg', 0),
(365, 94, N'~/images/Figure/ActionAndChibi/06_Frieren (4).jpg', 0),
(366, 94, N'~/images/Figure/ActionAndChibi/06_Frieren (5).jpg', 0),
(367, 94, N'~/images/Figure/ActionAndChibi/06_Frieren_Main.png', 1),
(368, 95, N'~/images/Figure/ActionAndChibi/07_HitoriGotoh (1).webp', 0),
(369, 95, N'~/images/Figure/ActionAndChibi/07_HitoriGotoh (2).webp', 0),
(370, 95, N'~/images/Figure/ActionAndChibi/07_HitoriGotoh (3).webp', 0),
(371, 95, N'~/images/Figure/ActionAndChibi/07_HitoriGotoh (4).webp', 0),
(372, 95, N'~/images/Figure/ActionAndChibi/07_HitoriGotoh_Main.webp', 1),
(373, 96, N'~/images/Figure/ActionAndChibi/08_Jiren (1).jpg', 0),
(374, 96, N'~/images/Figure/ActionAndChibi/08_Jiren (2).jpg', 0),
(375, 96, N'~/images/Figure/ActionAndChibi/08_Jiren (3).jpg', 0),
(376, 96, N'~/images/Figure/ActionAndChibi/08_Jiren (4).jpg', 0),
(377, 96, N'~/images/Figure/ActionAndChibi/08_Jiren (5).jpg', 0),
(378, 96, N'~/images/Figure/ActionAndChibi/08_Jiren_Main.webp', 1),
(379, 97, N'~/images/Figure/ActionAndChibi/09_Gabimaru (1).webp', 0),
(380, 97, N'~/images/Figure/ActionAndChibi/09_Gabimaru (2).webp', 0),
(381, 97, N'~/images/Figure/ActionAndChibi/09_Gabimaru (3).webp', 0),
(382, 97, N'~/images/Figure/ActionAndChibi/09_Gabimaru (4).webp', 0),
(383, 97, N'~/images/Figure/ActionAndChibi/09_Gabimaru (5).webp', 0),
(384, 97, N'~/images/Figure/ActionAndChibi/09_Gabimaru_Main.webp', 1),
(385, 98, N'~/images/Figure/ActionAndChibi/10_Furina (1).jpg', 0),
(386, 98, N'~/images/Figure/ActionAndChibi/10_Furina (1).png', 0),
(387, 98, N'~/images/Figure/ActionAndChibi/10_Furina (2).jpg', 0),
(388, 98, N'~/images/Figure/ActionAndChibi/10_Furina (3).jpg', 0),
(389, 98, N'~/images/Figure/ActionAndChibi/10_Furina (4).jpg', 0),
(390, 98, N'~/images/Figure/ActionAndChibi/10_Furina_Main.jpg', 1),
(391, 99, N'~/images/Figure/ActionAndChibi/11_LadyMaria (1).jpg', 0),
(392, 99, N'~/images/Figure/ActionAndChibi/11_LadyMaria (2).jpg', 0),
(393, 99, N'~/images/Figure/ActionAndChibi/11_LadyMaria (3).jpg', 0),
(394, 99, N'~/images/Figure/ActionAndChibi/11_LadyMaria (4).jpg', 0),
(395, 99, N'~/images/Figure/ActionAndChibi/11_LadyMaria (5).jpg', 0),
(396, 99, N'~/images/Figure/ActionAndChibi/11_LadyMaria_Main.jpg', 1),
(397, 100, N'~/images/Figure/ActionAndChibi/12_KatanaMan (1).jpg', 0),
(398, 100, N'~/images/Figure/ActionAndChibi/12_KatanaMan (2).jpg', 0),
(399, 100, N'~/images/Figure/ActionAndChibi/12_KatanaMan (3).jpg', 0),
(400, 100, N'~/images/Figure/ActionAndChibi/12_KatanaMan (4).jpg', 0),
(401, 100, N'~/images/Figure/ActionAndChibi/12_KatanaMan (5).jpg', 0),
(402, 100, N'~/images/Figure/ActionAndChibi/12_KatanaMan_Main.jpg', 1),
(403, 101, N'~/images/Figure/ActionAndChibi/13_March7th (1).jpg', 0),
(404, 101, N'~/images/Figure/ActionAndChibi/13_March7th (2).jpg', 0),
(405, 101, N'~/images/Figure/ActionAndChibi/13_March7th (3).jpg', 0),
(406, 101, N'~/images/Figure/ActionAndChibi/13_March7th (4).jpg', 0),
(407, 101, N'~/images/Figure/ActionAndChibi/13_March7th (5).jpg', 0),
(408, 101, N'~/images/Figure/ActionAndChibi/13_March7th (6).jpg', 0),
(409, 101, N'~/images/Figure/ActionAndChibi/13_March7th_Main.jpg', 1),
(410, 102, N'~/images/Figure/ActionAndChibi/14_Sukuna (1).jpg', 0),
(411, 102, N'~/images/Figure/ActionAndChibi/14_Sukuna (2).jpg', 0),
(412, 102, N'~/images/Figure/ActionAndChibi/14_Sukuna (3).jpg', 0),
(413, 102, N'~/images/Figure/ActionAndChibi/14_Sukuna (4).jpg', 0),
(414, 102, N'~/images/Figure/ActionAndChibi/14_Sukuna_Main.jpg', 1),
(415, 103, N'~/images/Figure/ActionAndChibi/15_Dio (1).jpg', 0),
(416, 103, N'~/images/Figure/ActionAndChibi/15_Dio (1).webp', 0),
(417, 103, N'~/images/Figure/ActionAndChibi/15_Dio (2).jpg', 0),
(418, 103, N'~/images/Figure/ActionAndChibi/15_Dio (2).webp', 0),
(419, 103, N'~/images/Figure/ActionAndChibi/15_Dio (3).jpg', 0),
(420, 103, N'~/images/Figure/ActionAndChibi/15_Dio_Main.webp', 1),
(421, 104, N'~/images/Figure/ActionAndChibi/16_HoshimiMiyabi (1).jpg', 0),
(422, 104, N'~/images/Figure/ActionAndChibi/16_HoshimiMiyabi (2).jpg', 0),
(423, 104, N'~/images/Figure/ActionAndChibi/16_HoshimiMiyabi (3).jpg', 0),
(424, 104, N'~/images/Figure/ActionAndChibi/16_HoshimiMiyabi (4).jpg', 0),
(425, 104, N'~/images/Figure/ActionAndChibi/16_HoshimiMiyabi (5).jpg', 0),
(426, 104, N'~/images/Figure/ActionAndChibi/16_HoshimiMiyabi_main.jpg', 1),
(427, 105, N'~/images/Figure/ActionAndChibi/17_Femto (1).jpg', 0),
(428, 105, N'~/images/Figure/ActionAndChibi/17_Femto (2).jpg', 0),
(429, 105, N'~/images/Figure/ActionAndChibi/17_Femto (3).jpg', 0),
(430, 105, N'~/images/Figure/ActionAndChibi/17_Femto (4).jpg', 0),
(431, 105, N'~/images/Figure/ActionAndChibi/17_Femto (5).jpg', 0),
(432, 105, N'~/images/Figure/ActionAndChibi/17_Femto_Main.jpg', 1),
(433, 106, N'~/images/Figure/ActionAndChibi/18_HoshimachiSuisei (1).jpg', 0),
(434, 106, N'~/images/Figure/ActionAndChibi/18_HoshimachiSuisei (2).jpg', 0),
(435, 106, N'~/images/Figure/ActionAndChibi/18_HoshimachiSuisei (3).jpg', 0),
(436, 106, N'~/images/Figure/ActionAndChibi/18_HoshimachiSuisei (4).jpg', 0),
(437, 106, N'~/images/Figure/ActionAndChibi/18_HoshimachiSuisei_Main.jpg', 1),
(438, 107, N'~/images/Figure/ActionAndChibi/19_Albedo (1).jpg', 0),
(439, 107, N'~/images/Figure/ActionAndChibi/19_Albedo (2).jpg', 0),
(440, 107, N'~/images/Figure/ActionAndChibi/19_Albedo (3).jpg', 0),
(441, 107, N'~/images/Figure/ActionAndChibi/19_Albedo_Main.png', 1),
(442, 108, N'~/images/Figure/ActionAndChibi/20_Mikey (1).jpg', 0),
(443, 108, N'~/images/Figure/ActionAndChibi/20_Mikey (1).webp', 0),
(444, 108, N'~/images/Figure/ActionAndChibi/20_Mikey (2).webp', 0),
(445, 108, N'~/images/Figure/ActionAndChibi/20_Mikey (3).webp', 0),
(446, 108, N'~/images/Figure/ActionAndChibi/20_Mikey_Main.jpg', 1),
(447, 109, N'~/images/Figure/ActionAndChibi/21_Sanji (1).jpg', 0),
(448, 109, N'~/images/Figure/ActionAndChibi/21_Sanji (2).jpg', 0),
(449, 109, N'~/images/Figure/ActionAndChibi/21_Sanji (3).jpg', 0),
(450, 109, N'~/images/Figure/ActionAndChibi/21_Sanji (4).jpg', 0),
(451, 109, N'~/images/Figure/ActionAndChibi/21_Sanji_Main.jpg', 1),
(452, 110, N'~/images/Figure/ActionAndChibi/22_Jiraiya (1).jpg', 0),
(453, 110, N'~/images/Figure/ActionAndChibi/22_Jiraiya (2).jpg', 0),
(454, 110, N'~/images/Figure/ActionAndChibi/22_Jiraiya (3).jpg', 0),
(455, 110, N'~/images/Figure/ActionAndChibi/22_Jiraiya (4).jpg', 0),
(456, 110, N'~/images/Figure/ActionAndChibi/22_Jiraiya (5).jpg', 0),
(457, 110, N'~/images/Figure/ActionAndChibi/22_Jiraiya_Main.png', 1),
(458, 111, N'~/images/Figure/ActionAndChibi/23_ItadoriYuji (1).jpg', 0),
(459, 111, N'~/images/Figure/ActionAndChibi/23_ItadoriYuji (2).jpg', 0),
(460, 111, N'~/images/Figure/ActionAndChibi/23_ItadoriYuji (3).jpg', 0),
(461, 111, N'~/images/Figure/ActionAndChibi/23_ItadoriYuji_Main.jpg', 1),
(462, 112, N'~/images/Figure/ScaleFigure/01_RaidenShogun (1).jpg', 0),
(463, 112, N'~/images/Figure/ScaleFigure/01_RaidenShogun (2).jpg', 0),
(464, 112, N'~/images/Figure/ScaleFigure/01_RaidenShogun (3).jpg', 0),
(465, 112, N'~/images/Figure/ScaleFigure/01_RaidenShogun (4).jpg', 0),
(466, 112, N'~/images/Figure/ScaleFigure/01_RaidenShogun (5).jpg', 0),
(467, 112, N'~/images/Figure/ScaleFigure/01_RaidenShogun_Main.jpg', 1),
(468, 113, N'~/images/Figure/ScaleFigure/02_Makima (1).jpg', 0),
(469, 113, N'~/images/Figure/ScaleFigure/02_Makima (2).jpg', 0),
(470, 113, N'~/images/Figure/ScaleFigure/02_Makima (3).jpg', 0),
(471, 113, N'~/images/Figure/ScaleFigure/02_Makima (4).jpg', 0),
(472, 113, N'~/images/Figure/ScaleFigure/02_Makima (5).jpg', 0),
(473, 113, N'~/images/Figure/ScaleFigure/02_Makima_Main.jpg', 1),
(474, 114, N'~/images/Figure/ScaleFigure/03_Kafka (1).jpg', 0),
(475, 114, N'~/images/Figure/ScaleFigure/03_Kafka (2).jpg', 0),
(476, 114, N'~/images/Figure/ScaleFigure/03_Kafka (3).jpg', 0),
(477, 114, N'~/images/Figure/ScaleFigure/03_Kafka (4).jpg', 0),
(478, 114, N'~/images/Figure/ScaleFigure/03_Kafka (5).jpg', 0),
(479, 114, N'~/images/Figure/ScaleFigure/03_Kafka_Main.jpg', 1),
(480, 115, N'~/images/Figure/ScaleFigure/04_Anya_YorForger (1).jpg', 0),
(481, 115, N'~/images/Figure/ScaleFigure/04_Anya_YorForger (2).jpg', 0),
(482, 115, N'~/images/Figure/ScaleFigure/04_Anya_YorForger (3).jpg', 0),
(483, 115, N'~/images/Figure/ScaleFigure/04_Anya_YorForger (4).jpg', 0),
(484, 115, N'~/images/Figure/ScaleFigure/04_Anya_YorForger_Main.jpg', 1),
(485, 116, N'~/images/Figure/ScaleFigure/05_Hutao (1).jpg', 0),
(486, 116, N'~/images/Figure/ScaleFigure/05_Hutao (2).jpg', 0),
(487, 116, N'~/images/Figure/ScaleFigure/05_Hutao (3).jpg', 0),
(488, 116, N'~/images/Figure/ScaleFigure/05_Hutao (4).jpg', 0),
(489, 116, N'~/images/Figure/ScaleFigure/05_Hutao_Main.jpg', 1),
(490, 117, N'~/images/Figure/ScaleFigure/06_Power_Makima (1).jpg', 0),
(491, 117, N'~/images/Figure/ScaleFigure/06_Power_Makima (2).jpg', 0),
(492, 117, N'~/images/Figure/ScaleFigure/06_Power_Makima (3).jpg', 0),
(493, 117, N'~/images/Figure/ScaleFigure/06_Power_Makima (4).jpg', 0),
(494, 117, N'~/images/Figure/ScaleFigure/06_Power_Makima_Main.jpg', 1),
(495, 118, N'~/images/Figure/ScaleFigure/07_Shenhe (1).jpg', 0),
(496, 118, N'~/images/Figure/ScaleFigure/07_Shenhe (2).jpg', 0),
(497, 118, N'~/images/Figure/ScaleFigure/07_Shenhe (3).jpg', 0),
(498, 118, N'~/images/Figure/ScaleFigure/07_Shenhe (4).jpg', 0),
(499, 118, N'~/images/Figure/ScaleFigure/07_Shenhe (5).jpg', 0),
(500, 118, N'~/images/Figure/ScaleFigure/07_Shenhe_Main.jpg', 1),
(501, 119, N'~/images/Figure/ScaleFigure/08_Tifa (1).jpg', 0),
(502, 119, N'~/images/Figure/ScaleFigure/08_Tifa (2).jpg', 0),
(503, 119, N'~/images/Figure/ScaleFigure/08_Tifa (3).jpg', 0),
(504, 119, N'~/images/Figure/ScaleFigure/08_Tifa (4).jpg', 0),
(505, 119, N'~/images/Figure/ScaleFigure/08_Tifa (5).jpg', 0),
(506, 119, N'~/images/Figure/ScaleFigure/08_Tifa_Main.jpg', 1),
(507, 120, N'~/images/Figure/ScaleFigure/09_Frieren (1).jpg', 0),
(508, 120, N'~/images/Figure/ScaleFigure/09_Frieren (2).jpg', 0),
(509, 120, N'~/images/Figure/ScaleFigure/09_Frieren (3).jpg', 0),
(510, 120, N'~/images/Figure/ScaleFigure/09_Frieren (4).jpg', 0),
(511, 120, N'~/images/Figure/ScaleFigure/09_Frieren (5).jpg', 0),
(512, 120, N'~/images/Figure/ScaleFigure/09_Frieren_Main.jpg', 1),
(513, 121, N'~/images/Figure/ScaleFigure/10_Acheron (1).jpg', 0),
(514, 121, N'~/images/Figure/ScaleFigure/10_Acheron (2).jpg', 0),
(515, 121, N'~/images/Figure/ScaleFigure/10_Acheron (3).jpg', 0),
(516, 121, N'~/images/Figure/ScaleFigure/10_Acheron (4).jpg', 0),
(517, 121, N'~/images/Figure/ScaleFigure/10_Acheron (5).jpg', 0),
(518, 121, N'~/images/Figure/ScaleFigure/10_Acheron_Main.jpg', 1),
(519, 122, N'~/images/Figure/ScaleFigure/11_KamisatoAyaka (1).jpg', 0),
(520, 122, N'~/images/Figure/ScaleFigure/11_KamisatoAyaka (2).jpg', 0),
(521, 122, N'~/images/Figure/ScaleFigure/11_KamisatoAyaka (3).jpg', 0),
(522, 122, N'~/images/Figure/ScaleFigure/11_KamisatoAyaka (4).jpg', 0),
(523, 122, N'~/images/Figure/ScaleFigure/11_KamisatoAyaka_Main.jpg', 1),
(524, 123, N'~/images/Figure/ScaleFigure/12_Miku (1).jpg', 0),
(525, 123, N'~/images/Figure/ScaleFigure/12_Miku (2).jpg', 0),
(526, 123, N'~/images/Figure/ScaleFigure/12_Miku (3).jpg', 0),
(527, 123, N'~/images/Figure/ScaleFigure/12_Miku (4).jpg', 0),
(528, 123, N'~/images/Figure/ScaleFigure/12_Miku (5).jpg', 0),
(529, 123, N'~/images/Figure/ScaleFigure/12_Miku_Main.jpg', 1),
(530, 124, N'~/images/Figure/ScaleFigure/13_Firefly (1).jpg', 0),
(531, 124, N'~/images/Figure/ScaleFigure/13_Firefly (2).jpg', 0),
(532, 124, N'~/images/Figure/ScaleFigure/13_Firefly (3).jpg', 0),
(533, 124, N'~/images/Figure/ScaleFigure/13_Firefly (4).jpg', 0),
(534, 124, N'~/images/Figure/ScaleFigure/13_Firefly_Main.jpg', 1),
(535, 125, N'~/images/Figure/ScaleFigure/14_Nilou (1).png', 0),
(536, 125, N'~/images/Figure/ScaleFigure/14_Nilou (2).png', 0),
(537, 125, N'~/images/Figure/ScaleFigure/14_Nilou (3).png', 0),
(538, 125, N'~/images/Figure/ScaleFigure/14_Nilou (4).png', 0),
(539, 125, N'~/images/Figure/ScaleFigure/14_Nilou_Main.png', 1),
(540, 126, N'~/images/Figure/ScaleFigure/15_Eula (1).jpg', 0),
(541, 126, N'~/images/Figure/ScaleFigure/15_Eula (2).jpg', 0),
(542, 126, N'~/images/Figure/ScaleFigure/15_Eula (3).jpg', 0),
(543, 126, N'~/images/Figure/ScaleFigure/15_Eula (4).jpg', 0),
(544, 126, N'~/images/Figure/ScaleFigure/15_Eula_Main.jpg', 1),
(545, 127, N'~/images/Figure/ScaleFigure/16_ShinobuKocho (1).png', 0),
(546, 127, N'~/images/Figure/ScaleFigure/16_ShinobuKocho (2).png', 0),
(547, 127, N'~/images/Figure/ScaleFigure/16_ShinobuKocho (3).png', 0),
(548, 127, N'~/images/Figure/ScaleFigure/16_ShinobuKocho_Main.png', 1),
(549, 128, N'~/images/Figure/ScaleFigure/17_Alecchino (1).jpg', 0),
(550, 128, N'~/images/Figure/ScaleFigure/17_Alecchino (1).webp', 0),
(551, 128, N'~/images/Figure/ScaleFigure/17_Alecchino (2).webp', 0),
(552, 128, N'~/images/Figure/ScaleFigure/17_Alecchino_Main.webp', 1),
(553, 129, N'~/images/Figure/ScaleFigure/18_Violet (1).jpg', 0),
(554, 129, N'~/images/Figure/ScaleFigure/18_Violet (2).jpg', 0),
(555, 129, N'~/images/Figure/ScaleFigure/18_Violet (3).jpg', 0),
(556, 129, N'~/images/Figure/ScaleFigure/18_Violet (4).jpg', 0),
(557, 129, N'~/images/Figure/ScaleFigure/18_Violet_Main.jpg', 1),
(558, 130, N'~/images/Figure/ScaleFigure/19_Bronya (1).jpg', 0),
(559, 130, N'~/images/Figure/ScaleFigure/19_Bronya (2).jpg', 0),
(560, 130, N'~/images/Figure/ScaleFigure/19_Bronya (3).jpg', 0),
(561, 130, N'~/images/Figure/ScaleFigure/19_Bronya (4).jpg', 0),
(562, 130, N'~/images/Figure/ScaleFigure/19_Bronya (5).jpg', 0),
(563, 130, N'~/images/Figure/ScaleFigure/19_Bronya_Main.jpg', 1),
(564, 131, N'~/images/Figure/ScaleFigure/20_Shana (1).jpg', 0),
(565, 131, N'~/images/Figure/ScaleFigure/20_Shana (2).jpg', 0),
(566, 131, N'~/images/Figure/ScaleFigure/20_Shana (3).jpg', 0),
(567, 131, N'~/images/Figure/ScaleFigure/20_Shana (4).jpg', 0),
(568, 131, N'~/images/Figure/ScaleFigure/20_Shana (5).jpg', 0),
(569, 131, N'~/images/Figure/ScaleFigure/20_Shana_Main.jpg', 1),
(570, 132, N'~/images/Figure/ScaleFigure/21_Erza (1).jpg', 0),
(571, 132, N'~/images/Figure/ScaleFigure/21_Erza (2).jpg', 0),
(572, 132, N'~/images/Figure/ScaleFigure/21_Erza (3).jpg', 0),
(573, 132, N'~/images/Figure/ScaleFigure/21_Erza (4).jpg', 0),
(574, 132, N'~/images/Figure/ScaleFigure/21_Erza (5).jpg', 0),
(575, 132, N'~/images/Figure/ScaleFigure/21_Erza_Main.jpg', 1),
(576, 133, N'~/images/Figure/ScaleFigure/22_Keqing (1).png', 0),
(577, 133, N'~/images/Figure/ScaleFigure/22_Keqing (1).webp', 0),
(578, 133, N'~/images/Figure/ScaleFigure/22_Keqing (2).png', 0),
(579, 133, N'~/images/Figure/ScaleFigure/22_Keqing (2).webp', 0),
(580, 133, N'~/images/Figure/ScaleFigure/22_Keqing (3).png', 0),
(581, 133, N'~/images/Figure/ScaleFigure/22_Keqing_Main.jpg', 1),
(582, 134, N'~/images/Figure/ScaleFigure/23_Asuna (1).jpg', 0),
(583, 134, N'~/images/Figure/ScaleFigure/23_Asuna (2).jpg', 0),
(584, 134, N'~/images/Figure/ScaleFigure/23_Asuna (3).jpg', 0),
(585, 134, N'~/images/Figure/ScaleFigure/23_Asuna (4).jpg', 0),
(586, 134, N'~/images/Figure/ScaleFigure/23_Asuna_Main.jpg', 1);
SET IDENTITY_INSERT [dbo].[ProductImages] OFF;
GO


-----------------------------------------------------------
-- 4. REVIEWS & OTHER DATA
-----------------------------------------------------------
INSERT INTO [dbo].[Reviews] (ProductID, AccountID, Rating, Comment) VALUES
(1, N'customer1', 5, N'Chất lượng mô hình rất tuyệt vời! Shop đóng gói cẩn thận.'),
(2, N'customer2', 4, N'Sản phẩm đẹp nhưng giao hàng hơi chậm một chút.'),
(3, N'customer1', 5, N'Hoàn thiện cực kỳ sắc nét, màu sơn đẹp và chuẩn xác.'),
(4, N'customer2', 4, N'Khớp nối hơi cứng nhưng tổng thể rất ổn.'),
(5, N'customer1', 5, N'Mô hình quá đẹp, đáng đồng tiền bát gạo!'),
(6, N'customer2', 3, N'Chi tiết hơi nhỏ, khó lắp ráp cho người mới.'),
(7, N'customer1', 5, N'Sơn metallic quá đỉnh, lấp lánh như thật.'),
(8, N'customer2', 4, N'Hàng chính hãng, tem mác đầy đủ.'),
(9, N'customer1', 5, N'Vũ khí đi kèm rất đa dạng, pose dáng cực ngầu.'),
(10, N'customer2', 5, N'Giao hàng nhanh, shop tư vấn nhiệt tình.'),
(11, N'customer1', 4, N'Màu sắc hơi khác so với ảnh một tí nhưng vẫn đẹp.'),
(12, N'customer2', 5, N'Chất lượng nhựa ABS cực tốt, bền bỉ.'),
(13, N'customer1', 3, N'Hộp hơi móp một chút do vận chuyển, mô hình bên trong ổn.'),
(14, N'customer2', 5, N'Thiết kế quá ấn tượng, khớp cử động linh hoạt.'),
(15, N'customer1', 4, N'Giá hơi cao nhưng chất lượng tương xứng.'),
(16, N'customer2', 5, N'Fan Gundam không thể bỏ qua sản phẩm này.'),
(17, N'customer1', 5, N'Decal nước đi kèm rất sắc nét.'),
(18, N'customer2', 4, N'Mô hình to, trưng bày trong tủ rất sang.'),
(19, N'customer1', 5, N'Hệ thống LED hoạt động hoàn hảo.'),
(20, N'customer2', 3, N'Lắp ráp mất nhiều thời gian nhưng kết quả mỹ mãn.'),
(21, N'customer1', 5, N'Mô hình MGEX đầu tiên của tôi, quá tuyệt.'),
(22, N'customer2', 4, N'Chi tiết máy móc bên trong làm rất kỹ.'),
(23, N'customer1', 5, N'Hàng về đúng lúc, shop làm việc chuyên nghiệp.'),
(24, N'customer2', 5, N'Màu vàng mạ rất bóng, không bị trầy xước.'),
(25, N'customer1', 4, N'Nhiều part nhỏ dễ mất, cần cẩn thận khi lắp.'),
(26, N'customer2', 5, N'Độ chi tiết vượt xa mong đợi.'),
(27, N'customer1', 5, N'Hàng hiếm, may mắn mua được ở shop.'),
(28, N'customer2', 3, N'Phần chân hơi yếu khi gắn phụ kiện nặng.'),
(29, N'customer1', 5, N'Mô hình rất cân bằng, tự đứng được không cần giá đỡ.'),
(30, N'customer2', 4, N'Sách hướng dẫn in màu rõ nét, dễ hiểu.'),
(31, N'customer1', 5, N'Quá trình lắp ráp rất thư giãn.'),
(32, N'customer2', 5, N'Shop bọc chống sốc rất dày, yên tâm hoàn toàn.'),
(33, N'customer1', 4, N'Cánh của mô hình rất rộng, chiếm diện tích.'),
(34, N'customer2', 5, N'Màu sơn nhám (matte) nhìn rất sang trọng.'),
(35, N'customer1', 5, N'Sản phẩm kỷ niệm rất có giá trị sưu tầm.'),
(36, N'customer2', 3, N'Khớp vai hơi lỏng, cần xử lý thêm.'),
(37, N'customer1', 5, N'Tỷ lệ hoàn hảo, đúng tinh thần nguyên mẫu.'),
(38, N'customer2', 4, N'Phụ kiện hiệu ứng lửa rất sống động.'),
(39, N'customer1', 5, N'Mô hình chắc chắn, nhựa dẻo dai.'),
(40, N'customer2', 5, N'Giao hàng hỏa tốc, đóng gói 10 điểm.'),
(41, N'customer1', 4, N'Dòng RG này làm chi tiết kinh khủng.'),
(42, N'customer2', 5, N'Giá cả cạnh tranh nhất thị trường.'),
(43, N'customer1', 5, N'Không uổng công chờ đợi sản phẩm này.'),
(44, N'customer2', 3, N'Kích thước hơi nhỏ so với tưởng tượng.'),
(45, N'customer1', 5, N'Đỉnh cao của mô hình lắp ráp.'),
(46, N'customer2', 4, N'Hàng chuẩn Bandai, không có gì để chê.'),
(47, N'customer1', 5, N'Thiết kế độc lạ, bổ sung tốt cho bộ sưu tập.'),
(48, N'customer2', 5, N'Màu sắc phối rất hài hòa.'),
(49, N'customer1', 4, N'Nên mua thêm giá đỡ để pose dáng đẹp hơn.'),
(50, N'customer2', 5, N'Mô hình to và nặng, cầm rất sướng tay.'),
(51, N'customer1', 5, N'Phụ kiện đầy đủ không thiếu thứ gì.'),
(52, N'customer2', 3, N'Mô hình hơi phức tạp cho trẻ em.'),
(53, N'customer1', 5, N'Figure Eren quá ngầu, biểu cảm rất đạt.'),
(54, N'customer2', 4, N'Nendoroid Gura dễ thương vô đối!'),
(55, N'customer1', 5, N'Levi nhìn sắc lạnh đúng chuẩn đội trưởng.'),
(56, N'customer2', 5, N'Link có nhiều phụ kiện, thay đổi được nhiều dáng.'),
(57, N'customer1', 4, N'Luffy bản Onigashima sơn rất đẹp.'),
(58, N'customer2', 5, N'Makima nhìn rất thần thái, shop giao nhanh.'),
(59, N'customer1', 5, N'Naruto nendoroid kinh điển, fan phải có.'),
(60, N'customer2', 3, N'Power hơi khó đứng nếu không có đế cắm.'),
(61, N'customer1', 5, N'Rengoku quá rực rỡ, hiệu ứng lửa đỉnh.'),
(62, N'customer2', 4, N'Người nhện linh hoạt, pose dáng Spider-man rất chuẩn.'),
(63, N'customer1', 5, N'Sasuke đi kèm hiệu ứng Chidori cực đẹp.'),
(64, N'customer2', 5, N'Yor Forger nendoroid đáng yêu quá.'),
(65, N'customer1', 4, N'Figure 2B tỷ lệ 1/4 thực sự rất to.'),
(66, N'customer2', 5, N'Albedo quyến rũ, chi tiết đôi cánh tuyệt vời.'),
(67, N'customer1', 5, N'Ganyu Apex Toys hoàn thiện quá tốt.'),
(68, N'customer2', 3, N'Kurumi súng ống chi tiết nhưng hơi mỏng manh.'),
(69, N'customer1', 5, N'Makima eStream quá hoành tráng.'),
(70, N'customer2', 4, N'Milim Nava màu sắc tươi tắn, năng động.'),
(71, N'customer1', 5, N'Ningguang diorama là một tác phẩm nghệ thuật.'),
(72, N'customer2', 5, N'Lôi thần Raiden Shogun uy nghi lẫm liệt.'),
(73, N'customer1', 4, N'Rem Crystal Dress thực sự lấp lánh.'),
(74, N'customer2', 5, N'Saber Alter Kimono quý phái, sơn mài đẹp.'),
(75, N'customer1', 5, N'Mai Sakurajima 1/4 quá chất lượng.'),
(76, N'customer2', 3, N'Yae Miko phụ kiện nhiều nhưng dễ gãy.'),
(77, N'customer1', 5, N'Bộ sơn này rất an toàn, không mùi.'),
(78, N'customer2', 4, N'Kềm DSPIAE cắt nhựa ngọt như cắt bơ.'),
(79, N'customer1', 5, N'Kềm Tamiya bền, dùng mãi không hỏng.'),
(80, N'customer2', 5, N'Bút tăng cứng khớp cứu vãn được nhiều mô hình cũ.'),
(81, N'customer1', 4, N'Bút kẻ lằn dễ dùng cho người mới.'),
(82, N'customer2', 5, N'Băng keo che sơn độ dính vừa phải, không làm tróc sơn.'),
(83, N'customer1', 5, N'Mark Setter giúp decal bám chắc hẳn.'),
(84, N'customer2', 3, N'Mark Softer cần cẩn thận khi dùng kẻo rách decal.'),
(85, N'customer1', 5, N'Keo dán nhựa này khô siêu nhanh.'),
(86, N'customer2', 4, N'Bộ kẹp sơn rất tiện lợi khi làm mô hình lớn.'),
(87, N'customer1', 5, N'Mực kẻ lằn đen là cơ bản nhất, cực tốt.'),
(88, N'customer2', 5, N'Bộ dụng cụ Tamiya này quá đủ cho người mới.'),
(89, N'customer1', 4, N'Xiao nendoroid biểu cảm rất sát anime.'),
(90, N'customer2', 5, N'Nanami figma đi kèm bánh mì rất hài hước.'),
(91, N'customer1', 5, N'Spider-Punk thiết kế phá cách, rất đẹp.'),
(92, N'customer2', 3, N'Loid Forger khớp hơi lỏng ở phần hông.'),
(93, N'customer1', 5, N'Pekora figma đáng yêu, mua về chơi cùng nendo.'),
(94, N'customer2', 4, N'Frieren nhìn rất thanh thoát, gậy phép đẹp.'),
(95, N'customer1', 5, N'Bocchi nendoroid tái hiện tốt sự lo âu, hài hước.'),
(96, N'customer2', 5, N'Jiren figma cơ bắp cuồn cuộn, pose dáng lực.'),
(97, N'customer1', 4, N'Gabimaru nhìn rất lạnh lùng, pose dáng ninja đỉnh.'),
(98, N'customer2', 5, N'Thủy thần Furina thiết kế váy áo rất cầu kỳ.'),
(99, N'customer1', 5, N'Lady Maria figma cực kỳ chi tiết, phong cách gothic.'),
(100, N'customer2', 3, N'Samurai Sword chi tiết lưỡi cưa hơi bén, cẩn thận.'),
(101, N'customer1', 5, N'March 7th màu sắc rực rỡ, nhìn là thấy vui.'),
(102, N'customer2', 4, N'Sukuna figma nhìn rất uy quyền.'),
(103, N'customer1', 5, N'Dio nendoroid biểu cảm WRRRRYYYY quá chuẩn.'),
(104, N'customer2', 5, N'Miyabi nendoroid hoàn thiện tốt, tóc đẹp.'),
(105, N'customer1', 4, N'Griffith Femto nhìn rất ma mị và bí ẩn.'),
(106, N'customer2', 5, N'Suisei nendoroid fan idol không thể bỏ qua.'),
(107, N'customer1', 5, N'Albedo bản váy cưới đẹp lộng lẫy.');
GO

INSERT INTO [dbo].[Vouchers] (VoucherCode, DiscountPercent, DiscountAmount, UsageLimit, ExpiryDate) VALUES
(N'WELCOME', 10, NULL, 100, '2030-12-31'),
(N'SALE50K', NULL, 50000, 50, '2030-12-31'),
(N'SALE15P', 15, NULL, 100, '2030-12-31');
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