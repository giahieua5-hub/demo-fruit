-- Tạo DB nếu chưa tồn tại
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'fruitables_db')
BEGIN
    CREATE DATABASE fruitables_db;
    PRINT '✅ Database fruitables_db created successfully!';
END
ELSE
BEGIN
    PRINT '⚠️ Database fruitables_db already exists!';
END
GO

-- Sử dụng DB
USE fruitables_db;
GO

-- Xóa bảng cũ nếu tồn tại (để tránh lỗi)
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Settings', 'U') IS NOT NULL DROP TABLE Settings;
GO

CREATE TABLE Settings (
    setting_id INT IDENTITY(1,1) PRIMARY KEY,
    setting_key VARCHAR(50) UNIQUE NOT NULL,
    value NVARCHAR(MAX) NOT NULL
);

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    phone VARCHAR(20),
    address NVARCHAR(MAX),
    role VARCHAR(20) DEFAULT 'Customer',   -- Customer / Admin
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name NVARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    category_id INT NOT NULL,
    image_url NVARCHAR(255),
    description NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_Product_Category FOREIGN KEY (category_id)
    REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME2 DEFAULT GETDATE(),
    total_amount DECIMAL(18,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending', 
    -- Pending / Processing / Shipping / Delivered / Cancelled

    CONSTRAINT FK_Orders_Users FOREIGN KEY (user_id)
    REFERENCES Users(user_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_OD_Order FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    CONSTRAINT FK_OD_Product FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);

INSERT INTO Categories (category_name) VALUES
(N'Rau củ'),
(N'Trái cây'),
(N'Đồ uống'),
(N'Sinh tố & nước ép');

INSERT INTO Users (username, email, password_hash, full_name, role)
VALUES 
('admin', 'admin@gmail.com', '123456', N'Quản trị viên', 'Admin'),
('user1', 'user1@gmail.com', '123456', N'Nguyễn Văn A', 'Customer');

INSERT INTO Products (product_name, price, category_id, image_url, description)
VALUES
(N'Cà chua Đà Lạt', 25000, 1, 'img/tomato.jpg', N'Rau sạch hữu cơ'),
(N'Bơ sáp', 45000, 2, 'img/avocado.jpg', N'Trái cây tươi ngon'),
(N'Nước cam nguyên chất', 30000, 3, 'img/orange-juice.jpg', N'Giải khát tự nhiên'),
(N'Sinh tố xoài', 35000, 4, 'img/mango-smoothie.jpg', N'Xay từ xoài chín');

INSERT INTO Orders (user_id, total_amount, status)
VALUES (2, 95000, 'Delivered');

INSERT INTO OrderDetails (order_id, product_id, quantity, price)
VALUES
(1, 1, 2, 25000),
(1, 3, 1, 30000),
(1, 2, 1, 45000);

