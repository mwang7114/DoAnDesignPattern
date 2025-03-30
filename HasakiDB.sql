use master
create database Hasaki
use Hasaki
go
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Online' CHECK (Status IN (N'Online', N'Offline')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Brands (
    BrandID INT PRIMARY KEY IDENTITY(1,1),
    BrandName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Image NVARCHAR(255),
    Status VARCHAR(50) DEFAULT 'Online' CHECK (Status IN (N'Online', N'Offline')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE ProductSubCategories (
    SubCategoryID INT PRIMARY KEY IDENTITY(1,1),
    SubCategoryName VARCHAR(100) NOT NULL,
    ImageID NVARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(255) NOT NULL,
    CategoryID INT,
    BrandID INT,
    SubCategoryID INT,
    Price DECIMAL(10, 2) NOT NULL,
    PriceSale DECIMAL(10, 2),
    Description NVARCHAR(MAX),
    Stock INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    Image VARCHAR(255),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (SubCategoryID) REFERENCES ProductSubCategories(SubCategoryID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName NVARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL UNIQUE,
    Gender NVARCHAR(5) NOT NULL CHECK (Gender IN (N'Nam', N'Nữ', N'Khác')),
	Addresses NVARCHAR(255)NOT NULL,
    DOB DATETIME NOT NULL,
    Role NVARCHAR(50) NOT NULL DEFAULT 'user',
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    Status VARCHAR(50) NOT NULL CHECK (Status IN ('Processing', 'Shipped', 'Delivered','Failed')),
	UserAddress NVARCHAR(255),
    OrderDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
);


CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    PromotionName NVARCHAR(255) NOT NULL UNIQUE,
    DiscountPercentage INT CHECK (DiscountPercentage > 0 AND DiscountPercentage <= 100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Description NVARCHAR(MAX)
);

CREATE TABLE ProductPromotions (
    ProductPromotionID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    PromotionID INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
);

CREATE TABLE DailyViews (
    ViewDate DATE PRIMARY KEY,
    ViewCount INT
);

CREATE TABLE Carts (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE CartItems (
    CartItemID INT PRIMARY KEY IDENTITY(1,1),
    CartID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CartID) REFERENCES Carts(CartID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO ProductSubCategories (SubCategoryName, ImageID) VALUES
(N'Trang Điểm Môi', '/Content/Images/trangdiemmoi.jpg'),
(N'Trang Điểm Mắt', '/Content/Images/trangdiemmats.jpg'),
(N'Trang Điểm Mặt', '/Content/Images/trangdiemmat.jpg'),
(N'Mặt nạ', '/Content/Images/matna.jpg'),
(N'Nước hoa', '/Content/Images/nuochoa.jpg'),
(N'Serum', '/Content/Images/Serum.jpg'),
(N'Tẩy TRang Mặt', '/Content/Images/Taytrang.jpg'),
(N'Sữa Tắm', '/Content/Images/Suatam.jpg'),
(N'Dầu gội và Dầu Xả', '/Content/Images/Daugoi.jpg');

INSERT INTO Categories (CategoryName, Status, CreatedAt) VALUES
(N'Nội dung Mỹ Phẩm High-End', N'Online', NULL),
(N'Chăm Sóc Da Mặt', N'Online', NULL),
(N'Trang Điểm', N'Online', NULL),
(N'Chăm Sóc Tóc Và Da Đầu', N'Online', NULL),
(N'Chăm Sóc Cơ Thể', N'Online', NULL),
(N'Chăm Sóc Cá Nhân', N'Online', NULL),
(N'Nước Hoa', N'Online', NULL),
(N'Thực Phẩm Chức Năng', N'Online', NULL),
(N'Hasaki Clinic & Spa', N'Online', NULL),
(N'Dịch Vụ Trải Nghiệm', N'Offline', NULL);

INSERT INTO Brands (BrandName, Description, Image, Status, CreatedAt) VALUES
(N'L''Oreal', N'Thương hiệu chuyên về các sản phẩm chăm sóc cá nhân', N'/Content/Images/LOréal.jpg', N'Online', NULL),
(N'Vaseline', N'Thương hiệu mỹ phẩm nổi tiếng trực thuộc Tập đoàn đa quốc gia Unilever', N'/Content/Images/Vaseline.jpg', N'Online', NULL),
(N'Dove', N'Thương hiệu chăm sóc cá nhân của Mỹ', N'/Content/Images/Dove.jpg', N'Online', NULL),
(N'Klairs''s', N'Thương hiệu chăm sóc da và mỹ phẩm của Hàn Quốc', N'/Content/Images/Klairs.jpg', N'Online', NULL),
(N'La Roche-Posay', N'Thương hiệu chăm sóc cá nhân', N'/Content/Images/Larocheposay.jpg', N'Offline', NULL),
(N'DHC', N'Thương hiệu thực phẩm chức năng', N'/Content/Images/DHC.jpg', N'Offline', NULL);

INSERT INTO Products (ProductName, CategoryID, BrandID, SubCategoryID, Price, PriceSale, Description, Stock, Image, CreatedAt) VALUES
(N'Kem Dưỡng Ẩm Oreal', 2, 1, 3, 250000, 200000, N'Kem dưỡng ẩm dành cho da khô, giúp duy trì độ ẩm suốt cả ngày.', 100, N'/Content/Images/KemDuongAm.jpg', NULL),
(N'Serum Shiseido Ultimune', 2, 2, 6, 1500000, 1400000, N'Serum dưỡng da cao cấp, cải thiện khả năng đàn hồi và chống lão hóa.', 50, N'/Content/Images/serumshiseido.jpg', NULL),
(N'Son Môi Estee Lauder', 3, 3, 1, 800000, 750000, N'Son môi lâu trôi, màu sắc tự nhiên, không gây khô môi.', 200, N'/Content/Images/este.jpg', NULL),
(N'Kem Chống Nắng La Roche-Posay', 2, 5, 3, 500000, 450000, N'Kem chống nắng không gây kích ứng, phù hợp cho da nhạy cảm.', 300, N'/Content/Images/laporay.jpg', NULL),
(N'Sữa Rửa Mặt Kiehls', 2, 4, 3, 400000, 350000, N'Sữa rửa mặt dịu nhẹ, không chứa xà phòng, giúp làm sạch mà không làm khô da.', 120, N'/Content/Images/sua-rua-mat-kiehls.png', NULL),
(N'Dầu Gội Phục Hồi TRESemmé', 4, 1, 9, 300000, 270000, N'Dầu gội với công thức phục hồi tóc hư tổn, giúp tóc suôn mượt.', 150, N'/Content/Images/dau-goi-phuc-hoi-tresemme.jpg', NULL),
(N'Nước Hoa Chanel No.5', 7, 3, 5, 2500000, 2300000, N'Hương nước hoa cao cấp, sang trọng, phù hợp cho mọi dịp.', 80, N'/Content/Images/nuoc-hoa-chanel-no5.jpg', NULL),
(N'Kem Tẩy Tế Bào Chết Vichy', 2, 5, 5, 450000, 420000, N'Kem tẩy tế bào chết dịu nhẹ, giúp da mịn màng và tươi sáng hơn.', 90, N'/Content/Images/kem-tay-te-bao-chet-vichy.jpg', NULL),
(N'Phấn Nền Maybelline', 3, 1, 2, 350000, 330000, N'Phấn nền kiềm dầu, giúp che khuyết điểm và giữ lớp nền lâu trôi.', 180, N'/Content/Images/phan-nen-maybelline.jpg', NULL),
(N'Thực Phẩm Chức Năng Collagen', 8, 4, NULL, 900000, 850000, N'Thực phẩm chức năng bổ sung collagen, giúp da căng bóng và khỏe mạnh.', 70, N'/Content/Images/thuc-pham-chuc-nang-collagen.jpg', NULL),
(N'Mặt Nạ Giấy Hada Labo', 2, 2, 5, 150000, 130000, N'Mặt nạ dưỡng da chuyên sâu, cung cấp độ ẩm tức thì.', 400, N'/Content/Images/mat-na-giay-hada-labo.png', NULL),
(N'Kem Dưỡng Trắng Da Innisfree', 2, 3, 5, 700000, 650000, N'Kem dưỡng trắng da chiết xuất thiên nhiên, không gây kích ứng.', 160, N'/Content/Images/kem-duong-trang-da-innisfree.png', NULL),
(N'Tinh Chất Trị Mụn Some By Mi', 2, 4, 5, 350000, 320000, N'Tinh chất trị mụn hiệu quả, giúp giảm mụn sưng đỏ.', 200, N'/Content/Images/tinh-chat-tri-mun-some-by-mi.jpg', NULL),
(N'Nước Hoa Hồng Thayers', 2, 5, 5, 300000, 280000, N'Nước hoa hồng dịu nhẹ, giúp cân bằng độ pH và làm mềm da.', 220, N'/Content/Images/nuoc-hoa-hong-thayers.png', NULL),
(N'Dầu Xả Phục Hồi Sunsilk', 4, 1, 9, 250000, 230000, N'Dầu xả bổ sung độ ẩm, giúp tóc mềm mại và dễ chải.', 140, N'/Content/Images/dau-xa-phuc-hoi-sunsilk.png', NULL),
(N'Dầu Dưỡng Tóc L Oréal Professionnel', 2, 1, 3, 300000, 280000, N'Dầu dưỡng tóc giúp phục hồi và nuôi dưỡng tóc từ sâu bên trong.', 150, N'/Content/Images/dau-duong-toc-LOréal-Professionnel.jpg', NULL),
(N'Dầu Gội Cấp Ẩm L Oréal Professionnel', 2, 1, 3, 350000, 320000, N'Dầu gội cung cấp độ ẩm cho tóc khô và hư tổn.', 200, N'/Content/Images/dau-goi-cap-am-LOréal-Professionnel.jpg', NULL),
(N'Dầu Gội Olaplex', 2, 2, 3, 450000, 400000, N'Dầu gội bảo vệ tóc, phục hồi kết cấu tóc hư tổn.', 100, N'/Content/Images/dau-goi-Olaplex.jpg', NULL),
(N'Dầu Gội Serie Expert Absolut Repair Gold', 2, 1, 3, 500000, 450000, N'Dầu gội dành cho tóc hư tổn nặng, phục hồi tóc mềm mại và bóng mượt.', 180, N'/Content/Images/dau-goi-Serie-Expert-Absolut-Repair-Gold.jpg', NULL),
(N'Dầu Gội Serie Expert Vitamino Resveratrol', 2, 1, 3, 480000, 440000, N'Dầu gội dành cho tóc nhuộm, bảo vệ màu tóc lâu dài.', 150, N'/Content/Images/dau-goi-Serie-Expert-Vitamino-Resveratrol.jpg', NULL),
(N'Kem Nền Estee Lauder', 3, 3, 1, 1200000, 1100000, N'Kem nền mỏng nhẹ, giúp da đều màu và giữ lớp nền lâu trôi.', 130, N'/Content/Images/kem-nen-estee-lauder.jpg', NULL),
(N'Mặt Nạ Kiehls', 2, 4, 3, 600000, 550000, N'Mặt nạ dưỡng da giúp làm sáng da và cung cấp độ ẩm.', 90, N'/Content/Images/mat-na-kiehls.jpg', NULL),
(N'Nước Cân Bằng Elixir', 2, 5, 3, 350000, 320000, N'Nước cân bằng da giúp cân bằng độ pH và làm dịu da.', 220, N'/Content/Images/nuoc-can-bang-elixir.jpg', NULL),
(N'Phấn Nước Laneige', 2, 5, 3, 800000, 750000, N'Phấn nước giúp tạo lớp nền mỏng nhẹ, làm sáng da.', 180, N'/Content/Images/phan-nuoc-laneige.jpg', NULL),
(N'Serum Elixer', 2, 5, 3, 900000, 850000, N'Serum dưỡng da giúp tăng cường độ ẩm và làm sáng da.', 150, N'/Content/Images/serum-elixer.jpg', NULL),
(N'Serum Olaplex No.9', 2, 2, 3, 1500000, 1400000, N'Serum giúp phục hồi tóc hư tổn, bảo vệ tóc khỏi tác động từ môi trường.', 50, N'/Content/Images/serum-olaplex-no9.jpg', NULL),
(N'Sữa Chống Nắng Elixir', 2, 5, 3, 500000, 450000, N'Sữa chống nắng bảo vệ da khỏi tác hại của tia UV.', 200, N'/Content/Images/sua-chong-nang-elixir.jpg', NULL),
(N'Sữa Chống Nắng Elixir 35g', 2, 5, 3, 250000, 230000, N'Sữa chống nắng Elixir phiên bản 35g tiện lợi.', 150, N'/Content/Images/sua-chong-nang-elixir-35g.jpg', NULL),
(N'Sữa Rửa Mặt Elixir', 2, 5, 3, 300000, 270000, N'Sữa rửa mặt giúp làm sạch da mà không gây khô rát.', 180, N'/Content/Images/sua-rua-mat-Elixir.jpg', NULL),
(N'Tinh Chất Kiehls', 2, 4, 3, 800000, 750000, N'Tinh chất dưỡng da sâu, giúp cải thiện độ đàn hồi và làm sáng da.', 100, N'/Content/Images/tinh-chat- Kiehls.jpg', NULL),
(N'Tinh Chất Skinceuticals', 2, 4, 3, 1500000, 1400000, N'Tinh chất chống lão hóa, phục hồi và làm săn chắc da.', 80, N'/Content/Images/tinh-chat-Skinceuticals.jpg', NULL),
(N'Mặt Nạ Ngủ Laneige', 2, 5, 3, 600000, 550000, N'Mặt nạ ngủ giúp cấp ẩm và dưỡng da suốt đêm.', 120, N'/Content/Images/mat-na-ngu-laneige.png', NULL),
(N'Dầu Xả Olaplex', 2, 2, 3, 500000, 450000, N'Dầu xả phục hồi tóc hư tổn và giữ tóc khỏe mạnh.', 150, N'/Content/Images/dau-xa-Olaplex.png', NULL),
(N'Na Ngủ Dưỡng Môi Laneige', 2, 5, 3, 350000, 320000, N'Mặt nạ ngủ cho môi, giúp môi mềm mịn và không bị khô.', 200, N'/Content/Images/na-ngu-duong-moi-laneige.png', NULL),
(N'Serum Laneige', 2, 5, 3, 750000, 700000, N'Serum dưỡng da giúp cung cấp độ ẩm sâu và nuôi dưỡng da.', 100, N'/Content/Images/serum-Laneige.png', NULL),
(N'Nước Hoa Nam Armaf Club De Nuit EDT Intense', 7, 6, 1, 1000000, 950000, N'Nước hoa nam cao cấp, hương thơm mạnh mẽ và cuốn hút.', 80, N'/Content/Images/nuoc-hoa-nam-Armaf-Club-De-Nuit-EDT-Intense.jpg', NULL),
(N'Nước Hoa Nam Armaf Club De Nuit Urban Elixir EDP', 7, 6, 1, 1200000, 1100000, N'Hương nước hoa nam quyến rũ, phù hợp với mọi dịp đặc biệt.', 90, N'/Content/Images/nuoc-hoa-nam-Armaf-Club-De-Nuit-Urban-Elixir-EDP.jpg', NULL),
(N'Nước Hoa Nam TOMMY Cologne EDT', 1, 2, 1, 800000, 750000, N'Nước hoa nam cổ điển, tươi mát và dễ chịu.', 120, N'/Content/Images/nuoc-hoa-nam-TOMMY-Cologne-EDT.jpg', NULL),
(N'Nước Hoa Nam Giorgio Armani Code Parfum', 2, 2, 1, 2500000, 2400000, N'Nước hoa nam sang trọng, mạnh mẽ và quyến rũ.', 70, N'/Content/Images/nuoc-hoa-nam-Giorgio-Armani-Code-Parfum.jpg', NULL),
(N'Nước Hoa Nam Tommy Impact Intense EDP', 3, 3, 1, 1000000, 950000, N'Nước hoa nam mạnh mẽ, lưu hương lâu dài.', 100, N'/Content/Images/nuoc-hoa-nam-Tommy-Impact-Intense-EDP.jpg', NULL),
(N'Nước Hoa Nam Versace Eros EDT', 4, 1, 1, 2200000, 2100000, N'Nước hoa nam mạnh mẽ, đầy đam mê và quyến rũ.', 60, N'/Content/Images/nuoc-hoa-nam-Versace-Eros-EDT.jpg', NULL),
(N'Nước Hoa Nam Versace Man Eau Fraiche EDT', 5, 3, 1, 1800000, 1700000, N'Nước hoa nam tươi mát và nam tính, thích hợp cho mùa hè.', 150, N'/Content/Images/nuoc-hoa-nam-Versace-Man-Eau-Fraiche-EDT.jpg', NULL),
(N'Nước Hoa Nữ Burberry Her Blossom EDT', 6, 4, 1, 2000000, 1900000, N'Nước hoa nữ ngọt ngào, nhẹ nhàng và quyến rũ.', 80, N'/Content/Images/nuoc-hoa-nu-Burberry-Her-Blossom-EDT.jpg', NULL),
(N'Nước Hoa Nữ Carolina Herrera Very Good Girl Glam EDP', 1, 4, 1, 3000000, 2900000, N'Nước hoa nữ quyến rũ, mạnh mẽ và cá tính.', 90, N'/Content/Images/nuoc-hoa-nu-Carolina-Herrera-Very-Good-Girl-Glam-EDP.jpg', NULL),
(N'Nước Hoa Nữ Diamond Femme Pink', 2, 4, 1, 1500000, 1400000, N'Nước hoa nữ nhẹ nhàng, dịu dàng với hương hoa tươi mát.', 150, N'/Content/Images/nuoc-hoa-nu-Diamond-Femme-Pink.jpg', NULL),
(N'Nước Hoa Nữ Lancôme Idôle EDP', 3, 4, 1, 4000000, 3900000, N'Nước hoa nữ thanh lịch và quyến rũ.', 70, N'/Content/Images/nuoc-hoa-nu-Lancôme-Idôle-EDP.jpg', NULL),
(N'Nước Hoa Nữ Narciso Rodriguez For Her', 4, 4, 1, 3500000, 3400000, N'Nước hoa nữ với hương hoa nhẹ nhàng, đầy quyến rũ.', 80, N'/Content/Images/nuoc-hoa-nu-Narciso-Rodriguez-For-Her.jpg', NULL),
(N'Nước Hoa Nữ Versace Bright Crystal Absolu', 5, 4, 1, 2500000, 2400000, N'Nước hoa nữ ngọt ngào, đầy sự tươi mới và quyến rũ.', 100, N'/Content/Images/nuoc-hoa-nu-Versace-Bright-Crystal-Absolu.jpg', NULL),
(N'Nước Hoa Nữ Versace Yellow Diamond EDT', 6, 4, 1, 2300000, 2200000, N'Nước hoa nữ thanh khiết, quyến rũ và tươi mới.', 150, N'/Content/Images/nuoc-hoa-nu-Versace-Yellow-Diamond-EDT.jpg', NULL),
(N'Nước Hoa Nữ YSL Libre EDP', 1, 4, 1, 3000000, 2900000, N'Nước hoa nữ đầy sự tự do và quyến rũ.', 80, N'/Content/Images/nuoc-hoa-nu-YSL-Libre-EDP.jpg', NULL),
(N'Xịt Toàn Thân Kiss My Body Passion', 2, 3, 1, 200000, 190000, N'Xịt toàn thân có hương thơm ngọt ngào, giúp cơ thể thư giãn.', 100, N'/Content/Images/xit-toan-than-Kiss-My-Body-Passion.jpg', NULL),
(N'Nước Hoa Nam Moschino Toy Boy EDP', 3, 6, 1, 2200000, 2100000, N'Nước hoa nam tươi mới và ngọt ngào.', 120, N'/Content/Images/nuoc-hoa-nam-Moschino-Toy-Boy-EDP.png', NULL),
(N'Nước Hoa Nam Gota Bouncy Eau de Parfum', 4, 6, 1, 1800000, 1700000, N'Nước hoa nam nhẹ nhàng và tươi mới, phù hợp cho mùa hè.', 150, N'/Content/Images/nuoc-hoa-nam-Gota-Bouncy-Eau-de-Parfum.png', NULL),
(N'Nước Hoa Vùng Kín Foellie', 5, 6, 1, 600000, 580000, N'Nước hoa cho vùng kín, giúp giữ sự tươi mới suốt cả ngày.', 200, N'/Content/Images/nuoc-hoa-vung-kin-Foellie.png', NULL),
(N'Xịt Toàn Thân Malissa Kiss', 6, 3, 1, 250000, 230000, N'Xịt toàn thân có hương thơm nhẹ nhàng và dễ chịu.', 100, N'/Content/Images/xit-toan-than-Malissa-Kiss.png', NULL),
(N'Combo Kén C DHC', 1, 4, 1, 700000, 650000, N'Combo thực phẩm chức năng cung cấp vitamin C từ thiên nhiên.', 100, N'/Content/Images/combo-ken-c-DHC.jpg', NULL),
(N'Keo Ngậm Bổ Mắt Rohto Clear Vision Junior', 2, 4, 1, 100000, 95000, N'Keo ngậm bổ mắt giúp giảm mỏi mắt và giữ sự tỉnh táo.', 150, N'/Content/Images/keo-ngam-bo-mat-Rohto-Clear-Vision-Junior.jpg', NULL),
(N'Nước Uống Astalift', 3, 4, 1, 1200000, 1150000, N'Nước uống dưỡng da giúp cung cấp collagen và làm sáng da.', 100, N'/Content/Images/nuoc-uong-Astalift.jpg', NULL),
(N'Nước Uống Collagen Alfe Deep Essence', 4, 4, 1, 900000, 850000, N'Nước uống bổ sung collagen cho làn da căng mịn và đàn hồi.', 200, N'/Content/Images/nuoc-uong-Collagen-Alfe-Deep-Essence.jpg', NULL),
(N'Nước Uống Collagen Elasten', 5, 4, 1, 1100000, 1050000, N'Nước uống collagen giúp phục hồi da từ sâu bên trong.', 150, N'/Content/Images/nuoc-uong-Collagen-Elasten.jpg', NULL),
(N'Nước Uống Collagen Gilaa', 6, 4, 1, 950000, 900000, N'Nước uống bổ sung collagen giúp da mềm mại và khỏe mạnh.', 100, N'/Content/Images/nuoc-uong-Collagen-Gilaa.jpg', NULL),
(N'Thực Phẩm Bảo Vệ Da SK Blossomy', 1, 4, 1, 1200000, 1150000, N'Thực phẩm bảo vệ da giúp duy trì làn da khỏe mạnh và sáng mịn.', 80, N'/Content/Images/thuc-pham-bao-ve-sk-Blossomy.jpg', NULL),
(N'Thực Phẩm Bảo Vệ Da InnerB Snow White', 2, 4, 1, 1000000, 950000, N'Thực phẩm giúp làm sáng da và chống lão hóa.', 120, N'/Content/Images/thuc-pham-bao-ve-sk-InnerB-Snow-White.jpg', NULL),
(N'Khẩu Trang Unicharm', 6, 1, 4, 50000, 48000, N'Khẩu trang Unicharm bảo vệ sức khỏe, thoáng khí và dễ chịu.', 200, N'/Content/Images/khau-trang-Unicharm.jpg', NULL),
(N'Mặt Nạ Xông Hơi Mặt MegRhythm', 6, 2, 4, 150000, 140000, N'Mặt nạ xông hơi giúp thư giãn và làm mềm da mặt.', 150, N'/Content/Images/mat-na-xong-hoi-mat-MegRhythm.jpg', NULL),
(N'Nước Súc Miệng Listerine', 6, 3, 7, 80000, 75000, N'Nước súc miệng Listerine giúp bảo vệ răng miệng khỏi vi khuẩn và mảng bám.', 250, N'/Content/Images/nuoc-suc-mieng-Listerine.jpg', NULL),
(N'Nước Súc Miệng Propolinse', 6, 4, 7, 120000, 110000, N'Nước súc miệng Propolinse giúp làm sạch và bảo vệ răng miệng.', 200, N'/Content/Images/nuoc-suc-mieng-Propolinse.jpg', NULL),
(N'Bông Tắm JOMI', 6, 5, 8, 50000, 48000, N'Bông tắm JOMI mềm mại, giúp làm sạch cơ thể hiệu quả.', 300, N'/Content/Images/bong-tam-JOMI.png', NULL),
(N'Xịt Thơm Miệng Loli And The Wolf', 6, 6, 7, 150000, 140000, N'Xịt thơm miệng Loli And The Wolf giúp hơi thở luôn thơm mát.', 150, N'/Content/Images/xit-thom-mieng-Loli-And-The-Wolf.png', NULL),
(N'Dưỡng Thể Dove', 6, 1, 8, 200000, 190000, N'Dưỡng thể Dove giúp da mềm mại và mịn màng suốt cả ngày.', 180, N'/Content/Images/duong-the-Dove.jpg', NULL),
(N'Kem Dưỡng Thể Paula’s Choice 10% AHA', 6, 2, 8, 450000, 430000, N'Kem dưỡng thể Paula’s Choice giúp làm sáng da và dưỡng ẩm.', 90, N'/Content/Images/kem-duong-the-Paula’s-Choice-10%-AHA.jpg', NULL),
(N'Kem Tắm Secret Key', 6, 3, 8, 250000, 230000, N'Kem tắm Secret Key giúp dưỡng da và mang lại làn da sáng mịn.', 120, N'/Content/Images/kem-tam-Secret-Key.jpg', NULL),
(N'Lan Khử Mùi EtiaXil', 6, 4, 7, 300000, 280000, N'Lan khử mùi EtiaXil giúp giữ cơ thể khô ráo và thoáng mát suốt cả ngày.', 100, N'/Content/Images/lan-khu-mui-EtiaXil.jpg', NULL),
(N'Sáp Dưỡng Ẩm Vaseline Pure Petroleum Jelly', 6, 5, 8, 120000, 110000, N'Sáp dưỡng ẩm Vaseline giúp giữ ẩm cho da khô và nứt nẻ.', 150, N'/Content/Images/sap-duong-am-Vaseline-Pure-Petroleum-Jelly.jpg', NULL),
(N'Sáp Khử Mùi Timber', 6, 6, 7, 180000, 170000, N'Sáp khử mùi Timber giúp bảo vệ cơ thể khỏi mùi cơ thể suốt cả ngày.', 120, N'/Content/Images/sap-khu-mui-Timber.jpg', NULL),
(N'Serum Dưỡng Thể Vaseline', 6, 1, 6, 220000, 210000, N'Serum dưỡng thể Vaseline giúp dưỡng ẩm sâu và làm mềm da.', 120, N'/Content/Images/serum-duong-the-Vaseline.jpg', NULL),
(N'Sữa Chống Nắng Sunplay', 6, 2, 5, 180000, 170000, N'Sữa chống nắng Sunplay giúp bảo vệ da khỏi tác hại của tia UV.', 200, N'/Content/Images/sua-chong-nang-Sunplay.jpg', NULL),
(N'Sữa Dưỡng Thể Ban Đêm Nivea', 6, 3, 8, 200000, 190000, N'Sữa dưỡng thể ban đêm Nivea giúp làm mềm da và cung cấp độ ẩm suốt đêm.', 150, N'/Content/Images/sua-duong-the-ban-dem-Nivea.jpg', NULL),
(N'Sữa Dưỡng Thể Ban Đêm Vaseline', 6, 4, 8, 220000, 210000, N'Sữa dưỡng thể ban đêm Vaseline giúp phục hồi da khô và bảo vệ da suốt đêm.', 120, N'/Content/Images/sua-duong-the-ban-dem-Vaseline.jpg', NULL),
(N'Sữa Tắm Hazeline', 6, 5, 8, 150000, 140000, N'Sữa tắm Hazeline giúp làm sạch da và giữ ẩm cho da.', 250, N'/Content/Images/sua-tam-Hazeline.jpg', NULL),
(N'Sữa Tắm Lifebuoy Khổ Qua', 6, 6, 8, 130000, 120000, N'Sữa tắm Lifebuoy khổ qua giúp làm sạch và bảo vệ da khỏi vi khuẩn.', 200, N'/Content/Images/sua-tam-lifbuoy-kho-qua.jpg', NULL),
(N'Sữa Tắm Lifebuoy Detox', 6, 1, 8, 150000, 140000, N'Sữa tắm Lifebuoy Detox giúp làm sạch và loại bỏ độc tố trên da.', 150, N'/Content/Images/sua-tam-Lifebuoy-Detox.jpg', NULL),
(N'Sữa Tắm Life Buoy Than', 6, 2, 8, 150000, 140000, N'Sữa tắm Life Buoy Than giúp làm sạch sâu và mang lại làn da mềm mại.', 200, N'/Content/Images/sua-tam-life-buoy-than.jpg', NULL),
(N'Sữa Tắm Some By Mi', 6, 3, 8, 220000, 210000, N'Sữa tắm Some By Mi giúp dưỡng da và làm mềm da hiệu quả.', 100, N'/Content/Images/sua-tam-Some-By-Mi.jpg', NULL),
(N'Kem Tẩy Lông Da Nhạy Cảm Cléo', 6, 4, 9, 300000, 290000, N'Kem tẩy lông Cléo giúp tẩy lông hiệu quả mà không gây kích ứng da.', 120, N'/Content/Images/kem-tay-long-da-nhay-cam-Cléo.png', NULL),
(N'Lan Nách Angel''s Liquid', 6, 5, 7, 250000, 230000, N'Lan nách Angel''s Liquid giúp khử mùi và làm mềm da.', 150, N'/Content/Images/lan-nach-Angels-Liquid.png', NULL),
(N'Sữa Tắm Nước Hoa Tesori ''Oriente', 6, 6, 8, 350000, 330000, N'Sữa tắm nước hoa Tesori d''Oriente giúp da mềm mại và thơm ngát.', 100, N'/Content/Images/sua-tam-nuoc-hoa-Tesori-dOriente.png', NULL),
(N'Tẩy Da Chết Toàn Thân Cocoon', 6, 1, 9, 300000, 290000, N'Tẩy da chết Cocoon giúp loại bỏ tế bào chết và làm sáng da.', 120, N'/Content/Images/tay-da-chet-toan-than-Cocoon.png', NULL),
(N'Xịt Giảm Mụn Lưng Angel''s Liquid', 6, 2, 7, 250000, 230000, N'Xịt giảm mụn lưng Angel''s Liquid giúp làm sạch và giảm mụn hiệu quả.', 150, N'/Content/Images/xit-giam-mun-lung-Angels-Liquid.png', NULL),
(N'Nước Tẩy Trang Da Nhạy Cảm Bioderma', 6, 1, 7, 350000, 330000, N'Nước tẩy trang Bioderma giúp làm sạch nhẹ nhàng và hiệu quả cho da nhạy cảm.', 180, N'/Content/Images/nuoc-tay-trang-da-nhay-cam-Bioderma.jpg', NULL),
(N'Nước Tẩy Trang Da Nhạy Cảm La Roche-Posay', 6, 2, 7, 450000, 430000, N'Nước tẩy trang La Roche-Posay giúp làm sạch da nhạy cảm và bảo vệ độ ẩm tự nhiên.', 150, N'/Content/Images/nuoc-tay-trang-da-nhay-cam-La-Roche-Posay.jpg', NULL),
(N'Serum Giảm Thâm Sáng Da La Roche-Posay', 6, 2, 6, 750000, 720000, N'Serum La Roche-Posay giúp giảm thâm nám, sáng da và cải thiện sắc tố da.', 100, N'/Content/Images/serum-giam-tham-sang-da-La-Roche-Posay.jpg', NULL),
(N'Serum Timeless', 6, 3, 6, 600000, 580000, N'Serum Timeless giúp chống lão hóa và cung cấp độ ẩm cho da.', 120, N'/Content/Images/serum-Timeless.jpg', NULL),
(N'Sữa Chống Nắng Da Dầu Anessa', 6, 4, 5, 600000, 580000, N'Sữa chống nắng Anessa phù hợp cho da dầu, bảo vệ da khỏi tia UV và duy trì độ thoáng mát.', 100, N'/Content/Images/sua-chong-nang-da-dau-Anessa.jpg', NULL),
(N'Sữa Chống Nắng Da Nhạy Cảm Anessa', 6, 4, 5, 650000, 630000, N'Sữa chống nắng Anessa bảo vệ da nhạy cảm khỏi ánh nắng và không gây kích ứng.', 150, N'/Content/Images/sua-chong-nang-da-nhay-cam-Anessa.jpg', NULL),
(N'Sữa Rửa Mặt Cetaphil', 6, 5, 7, 350000, 330000, N'Sữa rửa mặt Cetaphil nhẹ nhàng làm sạch mà không làm khô da.', 200, N'/Content/Images/sua-rua-mat-Cetaphil.jpg', NULL),
(N'Nước Tẩy Trang Da Dầu Mụn Garnier', 6, 6, 7, 180000, 170000, N'Nước tẩy trang Garnier giúp làm sạch da dầu và giảm mụn.', 250, N'/Content/Images/nuoc-tay-trang-da-dau-mun-Garnier.png', NULL),
(N'Nước Tẩy Trang L''Oreal', 6, 1, 7, 200000, 190000, N'Nước tẩy trang L''Oreal giúp làm sạch sâu và dưỡng ẩm cho da.', 220, N'/Content/Images/nuoc-tay-trang-LOreal.png', NULL),
(N'Serum L''Oreal Hyaluronic Acid', 6, 1, 6, 800000, 780000, N'Serum L''Oreal với hyaluronic acid giúp cấp ẩm sâu cho da, mang lại làn da mịn màng và săn chắc.', 100, N'/Content/Images/serum-LOreal-Hyaluronic-Acid.png', NULL),
(N'Sữa Rửa Mặt Cerave', 6, 5, 7, 450000, 430000, N'Sữa rửa mặt Cerave giúp làm sạch và dưỡng ẩm cho da, phù hợp với da khô và nhạy cảm.', 150, N'/Content/Images/sua-rua-mat-Cerave.png', NULL)


INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, Gender,Addresses, Role, DOB) VALUES
('admin@hasaki.vn', 'admin', N'Nguyễn Minh Hoàng', '0367123901', N'Nam', N'123 Đường ABC, Quận 1, TP.HCM' ,'admin', '2004-11-07'),
('manager@hasaki.vn', 'manager', N'Nguyễn Huỳnh An Khánh', '0123456789', N'Nam',N'456 Đường DEF, Quận 2, TP.HCM', 'manager', '2004-10-31'),
('manager2@hasaki.vn', 'manager', N'Vũ Nguyễn Anh Quân', '0123431289', N'Nam',N'789 Đường GHI, Quận 7, TP.HCM', 'manager', '2004-12-07'),
('user1@example.com', 'user1', N'Người dùng 1', '0987654321', N'Nam', N'123 Đường ABC, Quận 1, TP.HCM', 'user', '2001-11-01'),
('user2@example.com', 'user2', N'Người dùng 2', '6789012345', N'Nữ', N'123 Đường ABC, Quận 1, TP.HCM', 'user', '2002-11-07'),
('user3@example.com', 'user3', N'Người dùng 3', '1234567890', N'Nam', N'123 Đường ABC, Quận 1, TP.HCM', 'user', '1998-06-07');

INSERT INTO Orders (UserID, TotalAmount, Status) VALUES
(1, 1500000, N'Delivered'),
(4, 800000, N'Processing'),
(5, 1200000, N'Shipped'),
(3, 200000, N'Failed'),
(4, 850000, N'Delivered');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price) VALUES
(1, 2, 1, 1500000),
(1, 5, 1, 400000),
(2, 3, 1, 800000),
(3, 6, 2, 300000),
(4, 8, 1, 450000);


INSERT INTO Reviews (ProductID, UserID, Rating, Comment) VALUES
(1, 3, 5, N'Sản phẩm rất tốt, da mình cải thiện rõ rệt'),
(2, 4, 4, N'Serum dưỡng da tốt nhưng giá hơi cao'),
(3, 5, 3, N'Son môi đẹp nhưng hơi khô môi'),
(4, 3, 5, N'Kem chống nắng tuyệt vời cho da nhạy cảm'),
(5, 4, 4, N'Sữa rửa mặt dịu nhẹ và không gây khô da'),
(6, 4, 5, N'Sản phẩm tuyệt vời, rất hài lòng'),
(6, 5, 4, N'Sản phẩm tốt nhưng có thể cải thiện chất lượng'),
(6, 6, 3, N'Sản phẩm ổn, nhưng không hiệu quả như kỳ vọng'),
(7, 4, 2, N'Không hợp với da tôi, có thể gây kích ứng'),
(7, 5, 4, N'Chất lượng khá tốt, tuy nhiên giá hơi cao'),
(7, 6, 5, N'Rất thích sản phẩm này, tôi sẽ mua lại'),
(8, 4, 3, N'Sản phẩm vừa phải, không có gì đặc biệt'),
(8, 5, 2, N'Tôi không thích sản phẩm này, không hiệu quả'),
(8, 6, 4, N'Sản phẩm khá tốt, tuy nhiên có mùi hơi khó chịu'),
(9, 4, 5, N'Kem chống nắng này rất phù hợp với da nhạy cảm'),
(9, 5, 4, N'Rất tốt nhưng cần phải thoa lại sau vài giờ'),
(9, 6, 3, N'Tôi cảm thấy sản phẩm này hơi dính và khó chịu'),
(10, 4, 5, N'Son môi rất đẹp, lên màu chuẩn và lâu trôi'),
(10, 5, 2, N'Son môi này không hợp với tôi, dễ khô môi'),
(10, 6, 4, N'Màu son đẹp nhưng hơi khô môi'),
(11, 4, 3, N'Sản phẩm này không có tác dụng rõ rệt'),
(11, 5, 4, N'Rất hợp với tôi, da trở nên mịn màng hơn'),
(11, 6, 2, N'Sản phẩm không hiệu quả với tôi, hơi thất vọng'),
(12, 4, 5, N'Sản phẩm rất tốt, mình thấy da sáng và mịn hơn'),
(12, 5, 4, N'Serum này làm da mềm mại, nhưng giá hơi cao'),
(12, 6, 3, N'Sản phẩm cũng khá ổn nhưng không có hiệu quả thần kỳ'),
(13, 4, 2, N'Tôi không thấy hiệu quả gì sau khi sử dụng sản phẩm này'),
(13, 5, 3, N'Sản phẩm bình thường, không có gì đặc biệt'),
(13, 6, 4, N'Tôi thích sản phẩm này, tuy nhiên có thể cải thiện thêm'),
(14, 4, 1, N'Sản phẩm này không hợp với tôi, đã gây kích ứng da'),
(14, 5, 3, N'Sản phẩm này khá ổn, nhưng vẫn chưa hoàn hảo'),
(14, 6, 5, N'Chất lượng rất tốt, tôi rất thích sản phẩm này'),
(15, 4, 5, N'My favorite sản phẩm, tôi sẽ mua lại ngay'),
(15, 5, 4, N'Sản phẩm tốt, hiệu quả rõ rệt nhưng hơi đắt'),
(15, 6, 2, N'Sản phẩm không hiệu quả với tôi'),
(16, 4, 3, N'Sản phẩm trung bình, không làm da tôi thay đổi nhiều'),
(16, 5, 5, N'Tôi yêu sản phẩm này, da trở nên rất mềm mại'),
(16, 6, 4, N'Sản phẩm tốt, nhưng tôi nghĩ có thể cải thiện về độ thẩm thấu'),
(17, 4, 4, N'Sản phẩm này khá ổn, tôi thấy da sáng hơn một chút'),
(17, 5, 5, N'Rất tốt, da tôi đã cải thiện rõ rệt sau khi sử dụng'),
(17, 6, 3, N'Sản phẩm này không tồi, nhưng tôi hy vọng sẽ có kết quả tốt hơn'),
(18, 4, 2, N'Tôi không thấy sự khác biệt nhiều sau khi dùng sản phẩm này'),
(18, 5, 4, N'Sản phẩm này khá tốt, nhưng có thể cải thiện mùi hương'),
(18, 6, 5, N'Sản phẩm này thực sự hiệu quả với tôi'),
(19, 4, 3, N'Tôi không hài lòng lắm, da tôi không cải thiện nhiều'),
(19, 5, 5, N'Rất tuyệt vời, là sản phẩm tôi yêu thích'),
(19, 6, 4, N'Sản phẩm khá tốt, sẽ tiếp tục sử dụng'),
(20, 4, 5, N'Rất thích sản phẩm này, dùng một thời gian da sáng lên rất rõ'),
(20, 5, 4, N'Tôi thấy da mình cải thiện đáng kể, nhưng giá hơi cao'),
(20, 6, 3, N'Hiệu quả chậm, nhưng vẫn có chút cải thiện'),
(21, 4, 5, N'Kem chống nắng này phù hợp với da nhạy cảm của tôi'),
(21, 5, 4, N'Sản phẩm tốt, nhưng cần thoa lại sau một thời gian'),
(21, 6, 3, N'Tôi thấy sản phẩm này bình thường, không quá đặc biệt'),
(22, 4, 2, N'Sản phẩm không giúp ích gì cho tôi'),
(22, 5, 4, N'Tôi thích sản phẩm này, nhưng hy vọng có thể cải thiện về mùi'),
(22, 6, 5, N'Sản phẩm này rất tuyệt vời, giúp da sáng và mềm mại'),
(23, 4, 1, N'Sản phẩm này khiến da tôi bị nổi mụn'),
(23, 5, 3, N'Sản phẩm chỉ có tác dụng nhẹ, không rõ rệt'),
(23, 6, 4, N'Sản phẩm này khá tốt, nhưng tôi hy vọng có thể có kết quả nhanh hơn'),
(24, 4, 4, N'Rất thích sản phẩm này, hiệu quả rõ rệt'),
(24, 5, 5, N'Sản phẩm này rất tuyệt vời, tôi sẽ mua lại'),
(24, 6, 3, N'Sản phẩm này không quá tệ, nhưng tôi vẫn mong có hiệu quả tốt hơn'),
(25, 4, 5, N'Kem chống nắng này là lựa chọn tốt cho da nhạy cảm của tôi'),
(25, 5, 4, N'Tôi rất hài lòng với sản phẩm này, dù giá hơi cao'),
(25, 6, 3, N'Sản phẩm có thể hiệu quả hơn nữa'),
(26, 4, 4, N'Hiệu quả rất tốt, da mịn màng hơn hẳn sau vài ngày sử dụng'),
(26, 5, 5, N'Rất thích sản phẩm này, sẽ tiếp tục dùng'),
(26, 6, 2, N'Tôi không thấy sự thay đổi nhiều từ sản phẩm này'),
(27, 4, 3, N'Sản phẩm khá ổn, nhưng không đủ tốt để tôi mua lại'),
(27, 5, 4, N'Chất lượng khá tốt, giá hợp lý'),
(27, 6, 5, N'Sản phẩm này thực sự hiệu quả với tôi'),
(28, 4, 2, N'Sản phẩm không hợp với da tôi, gây kích ứng'),
(28, 5, 3, N'Sản phẩm chỉ có tác dụng nhẹ, không hiệu quả nhanh'),
(28, 6, 5, N'Chất lượng rất tốt, tôi rất thích'),
(29, 4, 3, N'Sản phẩm bình thường, không có gì đặc biệt'),
(29, 5, 5, N'Sản phẩm tuyệt vời, tôi sẽ mua lại'),
(29, 6, 4, N'Chất lượng tốt, nhưng tôi mong nó hiệu quả nhanh hơn'),
(30, 4, 2, N'Tôi không thấy hiệu quả rõ rệt sau khi dùng'),
(30, 5, 3, N'Sản phẩm này bình thường, không có gì nổi bật'),
(30, 6, 4, N'Sản phẩm này khá ổn, nhưng cần thời gian để thấy kết quả'),
(31, 4, 4, N'Rất thích sản phẩm này, da tôi cải thiện rõ rệt'),
(31, 5, 5, N'Chất lượng tuyệt vời, tôi sẽ tiếp tục sử dụng'),
(31, 6, 3, N'Sản phẩm ổn, nhưng tôi mong nó cải thiện thêm'),
(32, 4, 1, N'Sản phẩm này gây kích ứng da của tôi'),
(32, 5, 4, N'Tôi rất thích sản phẩm này, hiệu quả khá nhanh'),
(32, 6, 5, N'Sản phẩm này thực sự hiệu quả với tôi, da sáng lên rõ rệt'),
(33, 4, 3, N'Sản phẩm tốt nhưng giá hơi cao so với chất lượng'),
(33, 5, 5, N'Sản phẩm này thực sự hiệu quả với tôi, tôi rất hài lòng'),
(33, 6, 4, N'Tôi thấy sản phẩm này khá ổn, nhưng có thể cải thiện thêm'),
(34, 4, 2, N'Tôi không cảm thấy sự thay đổi đáng kể sau khi sử dụng'),
(34, 5, 3, N'Sản phẩm này khá nhẹ nhàng nhưng không có hiệu quả rõ rệt'),
(34, 6, 4, N'Sản phẩm này khá tốt, hiệu quả không nhanh nhưng ổn'),
(35, 4, 5, N'Sản phẩm này rất tuyệt vời, da tôi trở nên mềm mại và sáng hơn'),
(35, 5, 4, N'Sản phẩm tốt, nhưng có thể cải thiện thêm về mùi hương'),
(35, 6, 3, N'Tôi cảm thấy hiệu quả hơi chậm, nhưng vẫn thấy da mình cải thiện'),
(36, 4, 3, N'Sản phẩm này tốt, nhưng không phải lựa chọn ưu tiên của tôi'),
(36, 5, 5, N'Sản phẩm này rất tuyệt vời, tôi sẽ mua lại'),
(36, 6, 4, N'Tôi thấy sản phẩm này hiệu quả, tuy nhiên cần thêm thời gian'),
(37, 4, 2, N'Tôi cảm thấy sản phẩm này không hợp với da của tôi'),
(37, 5, 3, N'Sản phẩm này khá tốt nhưng không có tác dụng rõ rệt'),
(37, 6, 4, N'Sản phẩm này có hiệu quả, nhưng khá chậm'),
(38, 4, 5, N'Sản phẩm này rất tốt, tôi thấy da mình sáng và đều màu hơn'),
(38, 5, 4, N'Sản phẩm khá tốt, nhưng có thể cải thiện về độ thẩm thấu'),
(38, 6, 3, N'Tôi thấy sản phẩm này không tồi, nhưng không có thay đổi lớn'),
(39, 4, 1, N'Tôi bị dị ứng với sản phẩm này, không sử dụng nữa'),
(39, 5, 2, N'Sản phẩm không có tác dụng rõ rệt với tôi'),
(39, 6, 4, N'Sản phẩm này khá tốt, mặc dù có hiệu quả chậm'),
(40, 4, 4, N'Tôi rất thích sản phẩm này, sẽ tiếp tục sử dụng'),
(40, 5, 3, N'Sản phẩm ổn, nhưng không có gì đặc biệt'),
(40, 6, 5, N'Sản phẩm tuyệt vời, tôi rất hài lòng với kết quả'),
(41, 4, 2, N'Sản phẩm này không phù hợp với da tôi'),
(41, 5, 3, N'Sản phẩm này có tác dụng nhẹ, nhưng không có hiệu quả nhanh'),
(41, 6, 4, N'Sản phẩm khá tốt, nhưng tôi vẫn mong kết quả nhanh hơn'),
(42, 4, 5, N'Sản phẩm này rất hiệu quả, tôi rất thích'),
(42, 5, 4, N'Sản phẩm này ổn, tuy nhiên tôi mong nó sẽ cải thiện hơn nữa'),
(42, 6, 3, N'Sản phẩm này không tồi, nhưng không có thay đổi lớn'),
(43, 4, 1, N'Sản phẩm này làm da tôi bị nổi mụn'),
(43, 5, 2, N'Sản phẩm không phù hợp với tôi, tôi không thấy hiệu quả'),
(43, 6, 4, N'Sản phẩm này khá tốt, mặc dù có tác dụng chậm'),
(44, 4, 5, N'Tôi rất thích sản phẩm này, kết quả rõ rệt sau vài ngày sử dụng'),
(44, 5, 4, N'Sản phẩm này tốt, nhưng giá hơi cao'),
(44, 6, 3, N'Sản phẩm này hiệu quả, nhưng tôi nghĩ có thể cải thiện thêm'),
(45, 4, 3, N'Sản phẩm này bình thường, không có gì đặc biệt'),
(45, 5, 5, N'Sản phẩm rất tốt, tôi sẽ mua lại'),
(45, 6, 4, N'Sản phẩm này khá ổn, tôi sẽ tiếp tục sử dụng'),
(46, 4, 4, N'Sản phẩm này tốt, tuy nhiên tôi muốn thấy kết quả nhanh hơn'),
(46, 5, 5, N'Tôi rất hài lòng với sản phẩm này'),
(46, 6, 3, N'Sản phẩm ổn, nhưng cần thêm thời gian để đạt hiệu quả'),
(47, 4, 2, N'Sản phẩm này không hiệu quả với tôi'),
(47, 5, 3, N'Sản phẩm này khá ổn, nhưng không có thay đổi rõ rệt'),
(47, 6, 5, N'Sản phẩm tuyệt vời, tôi rất hài lòng với kết quả'),
(48, 4, 1, N'Sản phẩm không hợp với tôi, da tôi bị kích ứng'),
(48, 5, 4, N'Sản phẩm này khá tốt, nhưng không có tác dụng rõ rệt'),
(48, 6, 3, N'Sản phẩm này có hiệu quả nhẹ nhưng khá chậm'),
(49, 4, 5, N'Sản phẩm tuyệt vời, da tôi sáng hơn rất nhiều sau khi sử dụng'),
(49, 5, 4, N'Sản phẩm này rất tốt, mặc dù có thể cải thiện về độ thẩm thấu'),
(49, 6, 3, N'Sản phẩm khá tốt, nhưng tôi vẫn mong có kết quả nhanh hơn'),
(50, 4, 3, N'Sản phẩm này khá ổn, nhưng tôi mong có hiệu quả rõ rệt hơn'),
(50, 5, 5, N'Sản phẩm rất tốt, tôi sẽ tiếp tục mua lại'),
(50, 6, 4, N'Sản phẩm khá tốt, nhưng hiệu quả hơi chậm')



INSERT INTO Promotions (PromotionName, DiscountPercentage, StartDate, EndDate, Description) VALUES
(N'Giảm Giá Mùa Hè', 10, '2024-06-01', '2024-06-30', N'Khuyến mãi mùa hè'),
(N'Giảm Giá Tết', 15, '2024-01-15', '2024-02-15', N'Khuyến mãi Tết'),
(N'Flash Sale', 20, '2024-11-21', '2025-05-12', N'Giảm giá đặc biệt Flash Sale'),
(N'Giảm Giá Black Friday', 25, '2024-11-25', '2024-11-30', N'Khuyến mãi Black Friday'),
(N'Giảm Giá Cuối Năm', 30, '2024-12-25', '2024-12-31', N'Khuyến mãi cuối năm');

INSERT INTO ProductPromotions (ProductID, PromotionID) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 3),
(7, 3),
(8, 3),
(9, 3),
(10, 3)
UPDATE Orders
SET OrderDate = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01');

UPDATE Products
SET CreatedAt = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01');

UPDATE Products
SET UpdatedAt = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01')
WHERE DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01') >= CreatedAt;

UPDATE Reviews
SET ReviewDate = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01');

UPDATE Categories
SET CreatedAt = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01');

UPDATE Brands
SET CreatedAt = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 365), '2023-01-01');