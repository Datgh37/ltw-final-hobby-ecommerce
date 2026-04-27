CREATE DATABASE Ecommerce_Hobby_Shop
GO
USE Ecommerce_Hobby_Shop
GO

-----------------------------------------------------------
-- NHÓM 1: HỆ THỐNG TÀI KHOẢN & PHÂN QUYỀN
-----------------------------------------------------------

CREATE TABLE [dbo].[Roles](
    [RoleID] [int] NOT NULL,
    [RoleName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleID] ASC)
)
GO

CREATE TABLE [dbo].[Accounts](
    [AccountID] [nvarchar](20) NOT NULL,
    [Password] [nvarchar](50) NOT NULL,
    [FullName] [nvarchar](50) NOT NULL,
    [Email] [nvarchar](50) NOT NULL,
    [PhoneNumber] [nvarchar](24) NULL,
    [Address] [nvarchar](100) NULL,
    [BirthDate] [datetime] NULL,
    [Gender] [bit] NOT NULL DEFAULT (1),
    [Image] [nvarchar](50) NULL DEFAULT (N'~/images/user-default.png'),
    [IsActive] [bit] NOT NULL DEFAULT (1),
    [RoleID] [int] NOT NULL DEFAULT (0), -- 0: Customer, 1: Admin
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([AccountID] ASC)
)
GO

-----------------------------------------------------------
-- NHÓM 2: DANH MỤC & SẢN PHẨM (MỞ RỘNG CHO HOBBY SHOP)
-----------------------------------------------------------

CREATE TABLE [dbo].[Categories](
    [CategoryID] [int] IDENTITY(1,1) NOT NULL,
    [CategoryName] [nvarchar](50) NOT NULL,
    [CategorySlug] [nvarchar](50) NULL,
    [Image] [nvarchar](50) NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
)
GO

CREATE TABLE [dbo].[Series](
    [SeriesID] [int] IDENTITY(1,1) NOT NULL,
    [SeriesName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Series] PRIMARY KEY CLUSTERED ([SeriesID] ASC)
)
GO

CREATE TABLE [dbo].[Suppliers](
    [SupplierID] [nvarchar](50) NOT NULL,
    [CompanyName] [nvarchar](50) NOT NULL,
    [Logo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([SupplierID] ASC)
)
GO

CREATE TABLE [dbo].[Products](
    [ProductID] [int] IDENTITY(1,1) NOT NULL,
    [ProductName] [nvarchar](200) NOT NULL,
    [ProductSlug] [nvarchar](200) NULL, 
    [CategoryID] [int] NOT NULL,
    [SeriesID] [int] NULL, 
    [SupplierID] [nvarchar](50) NOT NULL,
    [UnitPrice] [decimal](18, 2) NOT NULL DEFAULT (0),
    [Description] [nvarchar](max) NULL,
    [Discount] [float] NOT NULL DEFAULT (0),
    [ViewCount] [int] NOT NULL DEFAULT (0),
    [StockQuantity] [int] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC)
)
GO

CREATE TABLE [dbo].[ProductImages](
    [ImageID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [ImageURL] [nvarchar](255) NOT NULL,
    [IsPrimary] [bit] NOT NULL DEFAULT (0), -- 1 (true) là ảnh đại diện
 CONSTRAINT [PK_ProductImages] PRIMARY KEY CLUSTERED ([ImageID] ASC)
)
GO

CREATE TABLE [dbo].[Reviews](
    [ReviewID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL,
    [AccountID] [nvarchar](20) NOT NULL,
    [Rating] [int] NOT NULL DEFAULT (5),
    [Comment] [nvarchar](max) NULL,
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED ([ReviewID] ASC)
)
GO

-----------------------------------------------------------
-- NHÓM 3: GIỎ HÀNG 
-----------------------------------------------------------

CREATE TABLE [dbo].[Carts](
    [CartID] [nvarchar](50) NOT NULL, 
    [AccountID] [nvarchar](20) NULL,   
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Carts] PRIMARY KEY CLUSTERED ([CartID] ASC)
)
GO

CREATE TABLE [dbo].[CartItems](
    [CartItemID] [int] IDENTITY(1,1) NOT NULL,
    [CartID] [nvarchar](50) NOT NULL,
    [ProductID] [int] NOT NULL,
    [Quantity] [int] NOT NULL DEFAULT (1),
 CONSTRAINT [PK_CartItems] PRIMARY KEY CLUSTERED ([CartItemID] ASC)
)
GO

-----------------------------------------------------------
-- NHÓM 4: ĐƠN HÀNG, KHUYẾN MÃI & GIAO DỊCH
-----------------------------------------------------------

CREATE TABLE [dbo].[Vouchers](
    [VoucherCode] [nvarchar](50) NOT NULL,
    [DiscountPercent] [int] NULL,
    [DiscountAmount] [decimal](18, 2) NULL,
    [UsageLimit] [int] NULL, -- Giới hạn số lượt dùng
    [UsedCount] [int] NOT NULL DEFAULT (0), -- Đã dùng bao nhiêu lượt
    [ExpiryDate] [datetime] NULL,
    [IsActive] [bit] NOT NULL DEFAULT (1),
 CONSTRAINT [PK_Vouchers] PRIMARY KEY CLUSTERED ([VoucherCode] ASC)
)
GO

CREATE TABLE [dbo].[Statuses](
    [StatusID] [int] NOT NULL,
    [StatusName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED ([StatusID] ASC)
)
GO

CREATE TABLE [dbo].[Orders](
    [OrderID] [int] IDENTITY(1,1) NOT NULL,
    [AccountID] [nvarchar](20) NOT NULL,
    [OrderDate] [datetime] NOT NULL DEFAULT (getdate()),
    [FullName] [nvarchar](50) NULL,
    [Address] [nvarchar](150) NOT NULL,
    [PhoneNumber] [nvarchar](24) NULL, 
    [PaymentMethod] [nvarchar](50) NOT NULL DEFAULT (N'COD'),
    [ShippingFee] [decimal](18, 2) NOT NULL DEFAULT (0),
    [StatusID] [int] NOT NULL DEFAULT (0),
    -- CÁC TRƯỜNG MỞ RỘNG
    [TrackingNumber] [nvarchar](100) NULL, -- Mã vận đơn (GHTK, ViettelPost...)
    [VoucherCode] [nvarchar](50) NULL,     -- Mã giảm giá đã áp dụng
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC)
)
GO

CREATE TABLE [dbo].[OrderDetails](
    [OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
    [OrderID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [UnitPrice] [decimal](18, 2) NOT NULL,
    [Quantity] [int] NOT NULL,
    [Discount] [float] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED ([OrderDetailID] ASC)
)
GO

-----------------------------------------------------------
-- NHÓM 5: CMS, HỖ TRỢ & HỆ THỐNG
-----------------------------------------------------------

CREATE TABLE [dbo].[Topics](
    [TopicID] [int] IDENTITY(1,1) NOT NULL,
    [TopicName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Topics] PRIMARY KEY CLUSTERED ([TopicID] ASC)
)
GO

CREATE TABLE [dbo].[Questions](
    [QuestionID] [int] IDENTITY(1,1) NOT NULL,
    [TopicID] [int] NOT NULL,
    [QuestionText] [nvarchar](max) NOT NULL,
    [AnswerText] [nvarchar](max) NULL,
    [AccountID] [nvarchar](20) NULL,
    [PostedDate] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED ([QuestionID] ASC)
)
GO

CREATE TABLE [dbo].[WebPages](
    [PageID] [int] IDENTITY(1,1) NOT NULL,
    [PageName] [nvarchar](100) NOT NULL,
    [URL] [nvarchar](250) NOT NULL,
    [Content] [nvarchar](max) NULL,
 CONSTRAINT [PK_WebPages] PRIMARY KEY CLUSTERED ([PageID] ASC)
)
GO

CREATE TABLE [dbo].[AuditLogs](
    [LogID] [int] IDENTITY(1,1) NOT NULL,
    [AccountID] [nvarchar](20) NULL,
    [Action] [nvarchar](100) NOT NULL,
    [Timestamp] [datetime] NOT NULL DEFAULT (getdate()),
    [Message] [nvarchar](max) NULL,
 CONSTRAINT [PK_AuditLogs] PRIMARY KEY CLUSTERED ([LogID] ASC)
)
GO

CREATE TABLE [dbo].[Favorites](
    [FavoriteID] [int] IDENTITY(1,1) NOT NULL,
    [ProductID] [int] NOT NULL, 
    [AccountID] [nvarchar](20) NOT NULL, 
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()), 
 CONSTRAINT [PK_Favorites] PRIMARY KEY CLUSTERED ([FavoriteID] ASC)
)
GO

-----------------------------------------------------------
-- RÀNG BUỘC KHÓA NGOẠI (FOREIGN KEYS)
-----------------------------------------------------------

-- 1. Accounts
ALTER TABLE [dbo].[Accounts] ADD CONSTRAINT [FK_Accounts_Roles] FOREIGN KEY([RoleID]) REFERENCES [dbo].[Roles] ([RoleID])
GO

-- 2. Products
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryID]) REFERENCES [dbo].[Categories] ([CategoryID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [FK_Products_Series] FOREIGN KEY([SeriesID]) REFERENCES [dbo].[Series] ([SeriesID])
GO
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([SupplierID]) REFERENCES [dbo].[Suppliers] ([SupplierID])
GO
ALTER TABLE [dbo].[ProductImages] ADD CONSTRAINT [FK_ProductImages_Products] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reviews] ADD CONSTRAINT [FK_Reviews_Products] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reviews] ADD CONSTRAINT [FK_Reviews_Accounts] FOREIGN KEY([AccountID]) REFERENCES [dbo].[Accounts] ([AccountID])
GO

-- 3. Carts
ALTER TABLE [dbo].[Carts] ADD CONSTRAINT [FK_Carts_Accounts] FOREIGN KEY([AccountID]) REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[CartItems] ADD CONSTRAINT [FK_CartItems_Carts] FOREIGN KEY([CartID]) REFERENCES [dbo].[Carts] ([CartID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CartItems] ADD CONSTRAINT [FK_CartItems_Products] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE
GO

-- 4. Orders
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Accounts] FOREIGN KEY([AccountID]) REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Statuses] FOREIGN KEY([StatusID]) REFERENCES [dbo].[Statuses] ([StatusID])
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Vouchers] FOREIGN KEY([VoucherCode]) REFERENCES [dbo].[Vouchers] ([VoucherCode])
GO
ALTER TABLE [dbo].[OrderDetails] ADD CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] ADD CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO

-- 5. CMS, Support, Systems
ALTER TABLE [dbo].[Questions] ADD CONSTRAINT [FK_Questions_Topics] FOREIGN KEY([TopicID]) REFERENCES [dbo].[Topics] ([TopicID])
GO
ALTER TABLE [dbo].[Questions] ADD CONSTRAINT [FK_Questions_Accounts] FOREIGN KEY([AccountID]) REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[AuditLogs] ADD CONSTRAINT [FK_AuditLogs_Accounts] FOREIGN KEY([AccountID]) REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[Favorites] ADD CONSTRAINT [FK_Favorites_Accounts] FOREIGN KEY([AccountID]) REFERENCES [dbo].[Accounts] ([AccountID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Favorites] ADD CONSTRAINT [FK_Favorites_Products] FOREIGN KEY([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE
GO

-----------------------------------------------------------
-- NHÓM 6: VIEWS (TƯƠNG ĐƯƠNG DTO ĐỂ QUERY TRỰC TIẾP LÊN VIEW)
-----------------------------------------------------------

-- 1. View Thẻ Sản Phẩm (Hiển thị trang chủ, danh sách)
CREATE VIEW [dbo].[v_ProductCard]
AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.ProductSlug,
    p.UnitPrice,
    p.Discount,
    c.CategoryName,
    s.SeriesName,
    pi.ImageURL AS PrimaryImage,
    ISNULL((SELECT AVG(CAST(Rating AS FLOAT)) FROM [dbo].[Reviews] r WHERE r.ProductID = p.ProductID), 0) AS AverageRating
FROM [dbo].[Products] p
LEFT JOIN [dbo].[Categories] c ON p.CategoryID = c.CategoryID
LEFT JOIN [dbo].[Series] s ON p.SeriesID = s.SeriesID
LEFT JOIN [dbo].[ProductImages] pi ON p.ProductID = pi.ProductID AND pi.IsPrimary = 1
GO

-- 2. View Chi tiết Giỏ Hàng (Hiển thị lúc khách xem giỏ)
CREATE VIEW [dbo].[v_CartDetails]
AS
SELECT 
    ci.CartID,
    ci.CartItemID,
    p.ProductID,
    p.ProductName,
    pi.ImageURL AS PrimaryImage,
    p.UnitPrice,
    p.Discount,
    ci.Quantity,
    (p.UnitPrice * (1 - p.Discount)) * ci.Quantity AS TotalItemPrice
FROM [dbo].[CartItems] ci
JOIN [dbo].[Products] p ON ci.ProductID = p.ProductID
LEFT JOIN [dbo].[ProductImages] pi ON p.ProductID = pi.ProductID AND pi.IsPrimary = 1
GO

-- 3. View Chi tiết Đơn Hàng (Dành cho Trang User xem lại lịch sử mua hoặc Admin xem chi tiết)
CREATE VIEW [dbo].[v_OrderDetailsWithProduct]
AS
SELECT 
    od.OrderID,
    od.OrderDetailID,
    p.ProductID,
    p.ProductName,
    pi.ImageURL AS PrimaryImage,
    od.UnitPrice,
    od.Quantity,
    od.Discount,
    (od.UnitPrice * (1 - od.Discount)) * od.Quantity AS TotalPrice
FROM [dbo].[OrderDetails] od
JOIN [dbo].[Products] p ON od.ProductID = p.ProductID
LEFT JOIN [dbo].[ProductImages] pi ON p.ProductID = pi.ProductID AND pi.IsPrimary = 1
GO