using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebHasaki.Models;

namespace WebHasaki.DesignPattern
{
    public interface IProductFinder
    {
        List<Product> FindProducts(string productName, ProductFilterOptions options, string sort = null, int page = 1, int pageSize = 10);
        int GetTotalProducts(string productName, ProductFilterOptions options);
    }

    public class ProductFilterOptions
    {
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }
        public string CategoryName { get; set; }
        public string BrandName { get; set; }

        public ProductFilterOptions(decimal? minPrice = null, decimal? maxPrice = null, string categoryName = null, string brandName = null)
        {
            MinPrice = minPrice;
            MaxPrice = maxPrice;
            CategoryName = categoryName;
            BrandName = brandName;
        }
    }

    public class ProductSearchAdapter : IProductFinder
    {
        private readonly DataModel _db;

        public ProductSearchAdapter(DataModel db)
        {
            _db = db;
        }

        public List<Product> FindProducts(string productName, ProductFilterOptions options, string sort = null, int page = 1, int pageSize = 10)
        {
            if (string.IsNullOrEmpty(productName))
            {
                return new List<Product>();
            }

            string sql;
            var parameters = new List<SqlParameter> { new SqlParameter("@ProductName", "%" + productName + "%") };

            if (sort == "ban-chay")
            {
                sql = @"
                SELECT DISTINCT
                    p.ProductID, p.ProductName, p.Price, p.PriceSale, p.Description, p.Stock, p.Image,
                    c.CategoryName, b.BrandName, COALESCE(pr.DiscountPercentage, 0) AS Discount,
                    p.CreatedAt, COALESCE(SUM(od.Quantity), 0) AS TotalSold
                FROM Products p
                INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                INNER JOIN Brands b ON p.BrandID = b.BrandID
                LEFT JOIN ProductPromotions pp ON p.ProductID = pp.ProductID
                LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID
                LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
                WHERE p.ProductName LIKE @ProductName";

                if (options != null)
                {
                    if (options.MinPrice.HasValue)
                    {
                        sql += " AND p.Price >= @MinPrice";
                        parameters.Add(new SqlParameter("@MinPrice", options.MinPrice.Value));
                    }
                    if (options.MaxPrice.HasValue)
                    {
                        sql += " AND p.Price <= @MaxPrice";
                        parameters.Add(new SqlParameter("@MaxPrice", options.MaxPrice.Value));
                    }
                    if (!string.IsNullOrEmpty(options.CategoryName))
                    {
                        sql += " AND c.CategoryName = @CategoryName";
                        parameters.Add(new SqlParameter("@CategoryName", options.CategoryName));
                    }
                    if (!string.IsNullOrEmpty(options.BrandName))
                    {
                        sql += " AND b.BrandName = @BrandName";
                        parameters.Add(new SqlParameter("@BrandName", options.BrandName));
                    }
                }

                sql += @"
                GROUP BY 
                    p.ProductID, p.ProductName, p.Price, p.PriceSale, p.Description, 
                    p.Stock, p.Image, c.CategoryName, b.BrandName, pr.DiscountPercentage, p.CreatedAt
                ORDER BY COALESCE(SUM(od.Quantity), 0) DESC";
            }
            else
            {
                sql = @"
                SELECT DISTINCT
                    p.ProductID, p.ProductName, p.Price, p.PriceSale, p.Description, p.Stock, p.Image,
                    c.CategoryName, b.BrandName, COALESCE(pr.DiscountPercentage, 0) AS Discount,
                    p.CreatedAt
                FROM Products p
                INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                INNER JOIN Brands b ON p.BrandID = b.BrandID
                LEFT JOIN ProductPromotions pp ON p.ProductID = pp.ProductID
                LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID
                WHERE p.ProductName LIKE @ProductName";

                if (options != null)
                {
                    if (options.MinPrice.HasValue)
                    {
                        sql += " AND p.Price >= @MinPrice";
                        parameters.Add(new SqlParameter("@MinPrice", options.MinPrice.Value));
                    }
                    if (options.MaxPrice.HasValue)
                    {
                        sql += " AND p.Price <= @MaxPrice";
                        parameters.Add(new SqlParameter("@MaxPrice", options.MaxPrice.Value));
                    }
                    if (!string.IsNullOrEmpty(options.CategoryName))
                    {
                        sql += " AND c.CategoryName = @CategoryName";
                        parameters.Add(new SqlParameter("@CategoryName", options.CategoryName));
                    }
                    if (!string.IsNullOrEmpty(options.BrandName))
                    {
                        sql += " AND b.BrandName = @BrandName";
                        parameters.Add(new SqlParameter("@BrandName", options.BrandName));
                    }
                }

                sql += " ORDER BY ";
                switch (sort)
                {
                    case "moi-nhat":
                        sql += "p.CreatedAt DESC";
                        break;
                    case "gia-thap-cao":
                        sql += "p.Price ASC";
                        break;
                    case "gia-cao-thap":
                        sql += "p.Price DESC";
                        break;
                    default:
                        sql += "p.ProductName";
                        break;
                }
            }

            sql += " OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";
            parameters.Add(new SqlParameter("@Offset", (page - 1) * pageSize));
            parameters.Add(new SqlParameter("@PageSize", pageSize));

            var result = _db.get(sql, parameters.ToArray());
            return ConvertToProductList(result, sort);
        }

        public int GetTotalProducts(string productName, ProductFilterOptions options)
        {
            string sql = @"
            SELECT COUNT(DISTINCT p.ProductID)
            FROM Products p
            INNER JOIN Categories c ON p.CategoryID = c.CategoryID
            INNER JOIN Brands b ON p.BrandID = b.BrandID
            LEFT JOIN ProductPromotions pp ON p.ProductID = pp.ProductID
            LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID
            WHERE p.ProductName LIKE @ProductName";

            var parameters = new List<SqlParameter> { new SqlParameter("@ProductName", "%" + productName + "%") };

            if (options != null)
            {
                if (options.MinPrice.HasValue)
                {
                    sql += " AND p.Price >= @MinPrice";
                    parameters.Add(new SqlParameter("@MinPrice", options.MinPrice.Value));
                }
                if (options.MaxPrice.HasValue)
                {
                    sql += " AND p.Price <= @MaxPrice";
                    parameters.Add(new SqlParameter("@MaxPrice", options.MaxPrice.Value));
                }
                if (!string.IsNullOrEmpty(options.CategoryName))
                {
                    sql += " AND c.CategoryName = @CategoryName";
                    parameters.Add(new SqlParameter("@CategoryName", options.CategoryName));
                }
                if (!string.IsNullOrEmpty(options.BrandName))
                {
                    sql += " AND b.BrandName = @BrandName";
                    parameters.Add(new SqlParameter("@BrandName", options.BrandName));
                }
            }

            var result = _db.executeScalar(sql, parameters.ToArray());
            return Convert.ToInt32(result);
        }

        private List<Product> ConvertToProductList(ArrayList data, string sort)
        {
            var products = new List<Product>();
            foreach (ArrayList row in data)
            {
                var product = new Product
                {
                    ProductID = int.Parse(row[0]?.ToString() ?? "0"),
                    ProductName = row[1]?.ToString(),
                    Price = decimal.Parse(row[2]?.ToString() ?? "0"),
                    PriceSale = row[3] != null ? decimal.Parse(row[3].ToString()) : (decimal?)null,
                    Description = row[4]?.ToString(),
                    Stock = int.Parse(row[5]?.ToString() ?? "0"),
                    Image = row[6]?.ToString(),
                    CategoryName = row[7]?.ToString(),
                    BrandName = row[8]?.ToString(),
                    Discount = decimal.Parse(row[9]?.ToString() ?? "0"),
                    CreatedAt = row[10] != null ? DateTime.Parse(row[10].ToString()) : (DateTime?)null
                };
                if (sort == "ban-chay" && row.Count > 11)
                {

                }
                products.Add(product);
            }
            return products;
        }
    }
}