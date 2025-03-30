GO
CREATE OR ALTER PROC KIEMTRADANGNHAP 
    @email varchar(100), 
    @pwd varchar(255)
AS
BEGIN
    IF EXISTS (SELECT * FROM Users WHERE Email = @email)
    BEGIN
        IF EXISTS (SELECT * FROM Users WHERE Email = @email AND PasswordHash = @pwd)
        BEGIN
            SELECT * 
            FROM Users 
            WHERE Email = @email AND PasswordHash = @pwd
        END
        ELSE
        BEGIN
            SELECT NULL AS ErrorCode, N'Sai mật khẩu!' AS ErrorMessage
        END
    END
    ELSE
    BEGIN
        SELECT NULL AS ErrorCode, N'Email không tồn tại!' AS ErrorMessage
    END
END

EXEC KIEMTRADANGNHAP 'admin@hasaki.vn', 'admin'

GO
CREATE OR ALTER PROCEDURE XULYDANGKY
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255),
    @FullName NVARCHAR(255),
    @PhoneNumber NVARCHAR(15),
    @Gender NVARCHAR(5),
    @Addresses NVARCHAR(255),
    @DOB DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, Gender, Addresses, DOB)
        VALUES (@Email, @PasswordHash, @FullName, @PhoneNumber, @Gender, @Addresses, @DOB);

        SELECT NULL AS Field, N'Đăng ký thành công.' AS Message;
    END TRY
    BEGIN CATCH
        SELECT NULL AS Field, ERROR_MESSAGE() AS Message;
    END CATCH
END

GO

Go
CREATE OR ALTER TRIGGER trg_UpdateUpdatedAt
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Products
    SET UpdatedAt = GETDATE()
    FROM Products P
    INNER JOIN inserted I ON P.ProductID = I.ProductID;
END;

GO
CREATE OR ALTER PROC LaySPSale
AS
BEGIN
    SELECT distinct
        p.ProductName,
        p.Price,
        p.PriceSale,
        p.Image,
        pr.StartDate,
        pr.EndDate,
        pr.DiscountPercentage
    FROM 
        ProductPromotions pp
    JOIN 
        Products p ON pp.ProductID = p.ProductID
    JOIN 
        Promotions pr ON pp.PromotionID = pr.PromotionID
    WHERE 
        pr.StartDate <= GETDATE()
        AND pr.EndDate >= GETDATE()
    ORDER BY 
        pr.StartDate DESC;
END;

GO
CREATE OR ALTER PROC LayHinhBrandID
@BrandID INT
AS
BEGIN
    SELECT distinct Image
    FROM Brands
	 WHERE BrandID = @BrandID
END;
Go
CREATE OR ALTER PROC LayHinhBrand
AS
BEGIN
    SELECT distinct Image
    FROM Brands
END;

Go

CREATE OR ALTER PROC LayTTSP
AS
BEGIN
    SELECT distinct
        p.ProductID,
        p.ProductName,
        p.Description,
        p.Price,
        p.PriceSale,
        p.Image,
        pr.DiscountPercentage AS Discount,
        c.CategoryName  -- Thêm tên danh mục
    FROM 
        Products p
    LEFT JOIN 
        Reviews r ON p.ProductID = r.ProductID
    LEFT JOIN 
        Users u ON r.UserID = u.UserID
    LEFT JOIN 
        ProductPromotions pp ON p.ProductID = pp.ProductID
    LEFT JOIN 
        Promotions pr ON pp.PromotionID = pr.PromotionID
    LEFT JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    GROUP BY 
        p.ProductID, p.ProductName, p.Description, p.Price, p.PriceSale, p.Image, pr.DiscountPercentage, c.CategoryName;  -- Thêm CategoryName vào GROUP BY
END



GO
	CREATE OR ALTER PROC LayCTSP
	@ProductID INT
	AS
	BEGIN
		SELECT distinct
			p.ProductID,
			p.ProductName,
			p.Description,
			p.Price,
			p.PriceSale,
			p.Image,
			p.Stock,
			AVG(r.Rating) AS Rating,
			pr.DiscountPercentage AS Discount,
			STRING_AGG(r.Comment, N', ') AS Comments,
			STRING_AGG(u.FullName, N', ') AS CommenterNames 
		FROM 
			Products p
		LEFT JOIN 
			Reviews r ON p.ProductID = r.ProductID
		LEFT JOIN 
			Users u ON r.UserID = u.UserID
		LEFT JOIN 
			ProductPromotions pp ON p.ProductID = pp.ProductID
		LEFT JOIN 
			Promotions pr ON pp.PromotionID = pr.PromotionID
			WHERE p.ProductID = @ProductID
		GROUP BY 
			p.ProductID, p.ProductName, p.Description, p.Price, p.PriceSale, p.Image, p.Stock, pr.DiscountPercentage;
	END
	GO

	CREATE OR ALTER PROC LaySPTheoDM
    @CategoryName NVARCHAR(100),
    @MinPrice DECIMAL(18,2) = NULL,
    @MaxPrice DECIMAL(18,2) = NULL,
    @BrandName NVARCHAR(100) = NULL,
    @Sort NVARCHAR(50) = NULL,
    @Page INT = 1,
    @PageSize INT = 8
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = @CategoryName)
    BEGIN
        PRINT N'CategoryName không tồn tại.';
        RETURN;
    END

    -- Xây dựng câu truy vấn động
    DECLARE @Sql NVARCHAR(MAX);

    IF @Sort = 'ban-chay'
    BEGIN
        SET @Sql = N'
            SELECT DISTINCT
                p.ProductID,
                p.ProductName,
                p.Price,
                p.PriceSale,
                p.Description,
                p.Stock,
                p.Image,
                c.CategoryName,
                b.BrandName,
                COALESCE(pr.DiscountPercentage, 0) AS Discount,
                p.CreatedAt,
                COALESCE(SUM(od.Quantity), 0) AS TotalSold
            FROM 
                Products p
            INNER JOIN 
                Categories c ON p.CategoryID = c.CategoryID
            INNER JOIN 
                Brands b ON p.BrandID = b.BrandID
            LEFT JOIN 
                ProductPromotions pp ON p.ProductID = pp.ProductID
            LEFT JOIN 
                Promotions pr ON pp.PromotionID = pr.PromotionID
            LEFT JOIN 
                OrderDetails od ON p.ProductID = od.ProductID
            WHERE 
                c.CategoryName = @CategoryName';
        
        IF @MinPrice IS NOT NULL
            SET @Sql += N' AND p.Price >= @MinPrice';
        IF @MaxPrice IS NOT NULL
            SET @Sql += N' AND p.Price <= @MaxPrice';
        IF @BrandName IS NOT NULL
            SET @Sql += N' AND b.BrandName = @BrandName';

        SET @Sql += N'
            GROUP BY 
                p.ProductID, p.ProductName, p.Price, p.PriceSale, p.Description, 
                p.Stock, p.Image, c.CategoryName, b.BrandName, pr.DiscountPercentage, p.CreatedAt
            ORDER BY 
                COALESCE(SUM(od.Quantity), 0) DESC
            OFFSET (@Page - 1) * @PageSize ROWS 
            FETCH NEXT @PageSize ROWS ONLY';
    END
    ELSE
    BEGIN
        SET @Sql = N'
            SELECT DISTINCT
                p.ProductID,
                p.ProductName,
                p.Price,
                p.PriceSale,
                p.Description,
                p.Stock,
                p.Image,
                c.CategoryName,
                b.BrandName,
                COALESCE(pr.DiscountPercentage, 0) AS Discount,
                p.CreatedAt
            FROM 
                Products p
            INNER JOIN 
                Categories c ON p.CategoryID = c.CategoryID
            INNER JOIN 
                Brands b ON p.BrandID = b.BrandID
            LEFT JOIN 
                ProductPromotions pp ON p.ProductID = pp.ProductID
            LEFT JOIN 
                Promotions pr ON pp.PromotionID = pr.PromotionID';

        SET @Sql += N'
            WHERE 
                c.CategoryName = @CategoryName';

        IF @MinPrice IS NOT NULL
            SET @Sql += N' AND p.Price >= @MinPrice';
        IF @MaxPrice IS NOT NULL
            SET @Sql += N' AND p.Price <= @MaxPrice';
        IF @BrandName IS NOT NULL
            SET @Sql += N' AND b.BrandName = @BrandName';

        SET @Sql += N'
            ORDER BY ';
        SET @Sql += CASE @Sort
            WHEN 'moi-nhat' THEN N'p.CreatedAt DESC'
            WHEN 'gia-thap-cao' THEN N'p.Price ASC'
            WHEN 'gia-cao-thap' THEN N'p.Price DESC'
            ELSE N'p.ProductName'
        END;

        SET @Sql += N'
            OFFSET (@Page - 1) * @PageSize ROWS 
            FETCH NEXT @PageSize ROWS ONLY';
    END

    -- Thực thi truy vấn động
    EXEC sp_executesql @Sql,
        N'@CategoryName NVARCHAR(100), @MinPrice DECIMAL(18,2), @MaxPrice DECIMAL(18,2), @BrandName NVARCHAR(100), @Page INT, @PageSize INT',
        @CategoryName, @MinPrice, @MaxPrice, @BrandName, @Page, @PageSize;
END

GO

CREATE OR ALTER PROC DemSPTheoDM
    @CategoryName NVARCHAR(100),
    @MinPrice DECIMAL(18,2) = NULL,
    @MaxPrice DECIMAL(18,2) = NULL,
    @BrandName NVARCHAR(100) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = @CategoryName)
    BEGIN
        PRINT N'CategoryName không tồn tại.';
        RETURN 0;
    END

    DECLARE @Sql NVARCHAR(MAX);
    SET @Sql = N'
        SELECT COUNT(DISTINCT p.ProductID)
        FROM 
            Products p
        INNER JOIN 
            Categories c ON p.CategoryID = c.CategoryID
        INNER JOIN 
            Brands b ON p.BrandID = b.BrandID
        LEFT JOIN 
            ProductPromotions pp ON p.ProductID = pp.ProductID
        LEFT JOIN 
            Promotions pr ON pp.PromotionID = pr.PromotionID
        WHERE 
            c.CategoryName = @CategoryName';

    IF @MinPrice IS NOT NULL
        SET @Sql += N' AND p.Price >= @MinPrice';
    IF @MaxPrice IS NOT NULL
        SET @Sql += N' AND p.Price <= @MaxPrice';
    IF @BrandName IS NOT NULL
        SET @Sql += N' AND b.BrandName = @BrandName';

    EXEC sp_executesql @Sql,
        N'@CategoryName NVARCHAR(100), @MinPrice DECIMAL(18,2), @MaxPrice DECIMAL(18,2), @BrandName NVARCHAR(100)',
        @CategoryName, @MinPrice, @MaxPrice, @BrandName;
END

GO