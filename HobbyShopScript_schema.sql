USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Ecommerce_Hobby_Shop')
BEGIN
    ALTER DATABASE Ecommerce_Hobby_Shop SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Ecommerce_Hobby_Shop;
END
GO

CREATE DATABASE Ecommerce_Hobby_Shop;
GO

USE Ecommerce_Hobby_Shop;
GO

-----------------------------------------------------------
-- NHÓM 1: HỆ THỐNG TÀI KHOẢN & PHÂN QUYỀN
-----------------------------------------------------------

CREATE TABLE [dbo].[Roles](
    [RoleID] [int] NOT NULL,
    [RoleName] [nvarchar](50) NOT NULL,
    [RoleName_EN] [nvarchar](50) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleID] ASC)
)
GO

CREATE TABLE [dbo].[Accounts](
    [AccountID] [nvarchar](20) NOT NULL,
    [Password] [nvarchar](255) NOT NULL, --Maxiumum Length for Hashed Password
    [FullName] [nvarchar](50) NOT NULL,
    [Email] [nvarchar](50) NOT NULL,
    [PhoneNumber] [nvarchar](24) NULL,
    [Address] [nvarchar](100) NULL,
    [BirthDate] [datetime] NULL,  -- Đổi ngược lại thành datetime để đồng bộ với .NET DateTime
    [Gender] [bit] NOT NULL DEFAULT (1),
    [Image] [nvarchar](255) NULL DEFAULT (N'~/images/user-default.png'),
    [IsActive] [bit] NOT NULL DEFAULT (1),
    [RoleID] [int] NOT NULL DEFAULT (1), -- 0: Admin, 1: Customer
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),  -- Thay datetime thành datetime2
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([AccountID] ASC)
)
GO

-----------------------------------------------------------
-- NHÓM 2: DANH MỤC & SẢN PHẨM (MỞ RỘNG CHO HOBBY SHOP)
-----------------------------------------------------------

CREATE TABLE [dbo].[Categories](
    [CategoryID] [int] IDENTITY(1,1) NOT NULL,
    [CategoryName] [nvarchar](50) NOT NULL,
    [CategoryName_EN] [nvarchar](50) NULL,
    [CategorySlug] [nvarchar](50) NULL,
    [Image] [nvarchar](255) NULL,
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
)
GO

CREATE TABLE [dbo].[Series](
    [SeriesID] [int] IDENTITY(1,1) NOT NULL,
    [SeriesName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](max) NULL,
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_Series] PRIMARY KEY CLUSTERED ([SeriesID] ASC)
)
GO

CREATE TABLE [dbo].[Suppliers](
    [SupplierID] [nvarchar](50) NOT NULL,
    [CompanyName] [nvarchar](50) NOT NULL,
    [Logo] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([SupplierID] ASC)
)
GO

CREATE TABLE [dbo].[Products](
    [ProductID] [int] IDENTITY(1,1) NOT NULL,
    [ProductName] [nvarchar](200) NOT NULL,
    [ProductName_EN] [nvarchar](200) NULL,
    [ProductSlug] [nvarchar](200) NULL, 
    [CategoryID] [int] NOT NULL,
    [SeriesID] [int] NULL, 
    [SupplierID] [nvarchar](50) NOT NULL,
    [UnitPrice] [decimal](18, 2) NOT NULL DEFAULT (0),
    [Description] [nvarchar](max) NULL,
    [Description_EN] [nvarchar](max) NULL,
    [Discount] [float] NOT NULL DEFAULT (0),
    [ViewCount] [int] NOT NULL DEFAULT (0),
    [StockQuantity] [int] NOT NULL DEFAULT (0),
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
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
    [ExpiryDate] [datetime] NULL,  -- Thay datetime thành datetime2
    [IsActive] [bit] NOT NULL DEFAULT (1),
    [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),  -- Thay datetime thành datetime2
 CONSTRAINT [PK_Vouchers] PRIMARY KEY CLUSTERED ([VoucherCode] ASC)
)
GO

CREATE TABLE [dbo].[Statuses](
    [StatusID] [int] NOT NULL,
    [StatusName] [nvarchar](50) NOT NULL,
    [StatusNameEN] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED ([StatusID] ASC)
)
GO

CREATE TABLE [dbo].[Orders](
    [OrderID] [int] IDENTITY(1,1) NOT NULL,
    [AccountID] [nvarchar](20) NOT NULL,
    [OrderDate] [datetime] NOT NULL DEFAULT (getdate()),  -- Thay datetime thành datetime2
    [FullName] [nvarchar](50) NULL,
    [Address] [nvarchar](150) NOT NULL,
    [PhoneNumber] [nvarchar](24) NULL, 
    [PaymentMethod] [nvarchar](50) NOT NULL DEFAULT (N'COD'),
    [ShippingFee] [decimal](18, 2) NOT NULL DEFAULT (0),
    [StatusID] [int] NOT NULL DEFAULT (0),
    [IsPaid] [bit] NOT NULL DEFAULT (0), -- Xác định xem đơn đã được thanh toán trước chưa
    -- CÁC TRƯỜNG MỞ RỘNG
    [TrackingNumber] [nvarchar](100) NULL, -- Mã vận đơn (GHTK, ViettelPost...)
    [VoucherCode] [nvarchar](50) NULL,     -- Mã giảm giá đã áp dụng
    [TransactionId] [nvarchar](100) NULL,  -- Mã giao dịch thanh toán trực tuyến (VNPAY, ZaloPay...)
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
    [PostedDate] [datetime] NOT NULL DEFAULT (getdate()),  -- Thay datetime thành datetime2
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
-- NHÓM 6: STORED PROCEDURES (THỦ TỤC LƯU TRỮ TỐI ƯU GIAO DỊCH)
-----------------------------------------------------------

-- 1. Thủ tục gộp Giỏ hàng từ Khách hàng vãng lai (Guest Cart) khi Đăng nhập
CREATE PROCEDURE [dbo].[sp_SyncCart]
    @GuestCartID NVARCHAR(50),
    @AccountID NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Tìm hoặc tạo mới Giỏ hàng chính thức của tài khoản thành viên
        DECLARE @UserCartID NVARCHAR(50) = N'CART_' + @AccountID;
        
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Carts] WHERE [CartID] = @UserCartID)
        BEGIN
            INSERT INTO [dbo].[Carts] ([CartID], [AccountID], [CreatedAt])
            VALUES (@UserCartID, @AccountID, GETDATE());
        END
        ELSE
        BEGIN
            -- Đảm bảo trường AccountID được liên kết chuẩn xác
            UPDATE [dbo].[Carts]
            SET [AccountID] = @AccountID
            WHERE [CartID] = @UserCartID;
        END

        -- Thực hiện gộp dữ liệu các mặt hàng sử dụng câu lệnh MERGE nguyên tử
        MERGE [dbo].[CartItems] AS target
        USING (
            SELECT [ProductID], [Quantity] 
            FROM [dbo].[CartItems] 
            WHERE [CartID] = @GuestCartID
        ) AS source
        ON (target.[CartID] = @UserCartID AND target.[ProductID] = source.[ProductID])
        
        -- Nếu mặt hàng đã có trong giỏ chính thức -> Cộng dồn số lượng Quantity
        WHEN MATCHED THEN
            UPDATE SET target.[Quantity] = target.[Quantity] + source.[Quantity]
        
        -- Nếu chưa có -> Thêm mới dòng sản phẩm
        WHEN NOT MATCHED THEN
            INSERT ([CartID], [ProductID], [Quantity])
            VALUES (@UserCartID, source.[ProductID], source.[Quantity]);

        -- Xóa sạch giỏ hàng vãng lai tạm thời
        DELETE FROM [dbo].[CartItems] WHERE [CartID] = @GuestCartID;
        DELETE FROM [dbo].[Carts] WHERE [CartID] = @GuestCartID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 2. Thủ tục Hủy đơn hàng và hoàn lại tồn kho
CREATE PROCEDURE [dbo].[sp_CancelOrder]
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @CurrentStatus INT;
        DECLARE @VoucherCode NVARCHAR(50);
        
        -- Lấy trạng thái hiện tại của đơn hàng và mã giảm giá (nếu có)
        SELECT @CurrentStatus = StatusID, @VoucherCode = VoucherCode
        FROM [dbo].[Orders] 
        WHERE OrderID = @OrderID;

        -- Chỉ cho phép hủy nếu đơn hàng đang ở trạng thái 0 (Chờ xử lý) hoặc 1 (Đang chuẩn bị)
        IF @CurrentStatus IS NOT NULL AND @CurrentStatus < 2
        BEGIN
            -- 1. Cập nhật trạng thái đơn hàng thành 4 (Đã hủy)
            UPDATE [dbo].[Orders]
            SET StatusID = 4
            WHERE OrderID = @OrderID;

            -- 2. Hoàn lại số lượng tồn kho cho các sản phẩm trong đơn hàng
            UPDATE p
            SET p.StockQuantity = p.StockQuantity + od.Quantity
            FROM [dbo].[Products] p
            INNER JOIN [dbo].[OrderDetails] od ON p.ProductID = od.ProductID
            WHERE od.OrderID = @OrderID;

            -- 3. Hoàn lại lượt sử dụng cho Voucher (nếu có)
            IF @VoucherCode IS NOT NULL AND @VoucherCode <> ''
            BEGIN
                UPDATE [dbo].[Vouchers]
                SET UsedCount = CASE WHEN UsedCount > 0 THEN UsedCount - 1 ELSE 0 END
                WHERE VoucherCode = @VoucherCode;
            END
        END
        ELSE
        BEGIN
            -- Có thể throw error hoặc return tuỳ thiết kế, ở đây ta throw error để EF bắt được
            RAISERROR('Không thể hủy đơn hàng này (Trạng thái không hợp lệ).', 16, 1);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO