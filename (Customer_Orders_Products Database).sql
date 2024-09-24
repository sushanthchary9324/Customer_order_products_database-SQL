CREATE DATABASE Customers_Orders_Product
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);





CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);



  ------------------------------------------------------------------------------------
  ------------------------------------TASK1-------------------------------------------
 SELECT * FROM Customers;
  
 
 SELECT Name, Email FROM Customers WHERE Name LIKE 'J%';
 
  
  
  SELECT OrderID, ProductName, Quantity FROM Orders;
  
 
 SELECT SUM(Quantity) AS TotalQuantity FROM Orders;
 
 SELECT DISTINCT C.Name FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID;

SELECT * FROM Products WHERE Price > 10.00;


SELECT C.Name, O.OrderDate
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate >= '2023-07-05';


SELECT AVG(Price) AS AveragePrice FROM Products;


SELECT C.Name, SUM(O.Quantity) AS TotalQuantity
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.Name;


SELECT P.*
FROM Products P
LEFT JOIN Orders O ON P.ProductName = O.ProductName
WHERE O.OrderID IS NULL;

------------------------------------------------------------------------------------
-----------------------------TASK2-------------------------------------------------------
SELECT C.CustomerID, C.Name, SUM(O.Quantity) AS TotalQuantity
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name
ORDER BY TotalQuantity DESC
LIMIT 5;

SELECT CategoryID, AVG(Price) AS AveragePrice
FROM Products
GROUP BY CategoryID;

SELECT C.*
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

SELECT O.OrderID, O.ProductName, O.Quantity
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.Name LIKE 'M%';

SELECT SUM(P.Price * O.Quantity) AS TotalRevenue
FROM Orders O
JOIN Products P ON O.ProductName = P.ProductName;

SELECT C.Name, SUM(P.Price * O.Quantity) AS TotalRevenue
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Products P ON O.ProductName = P.ProductName
GROUP BY C.Name;

SELECT C.CustomerID, C.Name
FROM Customers C
WHERE NOT EXISTS (
    SELECT DISTINCT CategoryID
    FROM Products
    WHERE NOT EXISTS (
        SELECT O.ProductName
        FROM Orders O
        WHERE O.CustomerID = C.CustomerID AND O.ProductName = Products.ProductName
    )
);

SELECT DISTINCT C.CustomerID, C.Name
FROM Customers C
JOIN Orders O1 ON C.CustomerID = O1.CustomerID
JOIN Orders O2 ON C.CustomerID = O2.CustomerID AND O2.OrderDate = O1.OrderDate + INTERVAL 1 DAY;

SELECT ProductName, AVG(Quantity) AS AvgQuantity
FROM Orders
GROUP BY ProductName
ORDER BY AvgQuantity DESC
LIMIT 3;

SELECT 
    (COUNT(CASE WHEN Quantity > AvgQuantity THEN 1 END) / COUNT(*)) * 100 AS Percentage
FROM 
    Orders,
    (SELECT AVG(Quantity) AS AvgQuantity FROM Orders) AS AvgTable;

------------------------------------------------------------------------------------
----------------------------TASK3---------------------------------------------------
SELECT C.CustomerID, C.Name
FROM Customers C
WHERE NOT EXISTS (
    SELECT P.ProductName
    FROM Products P
    WHERE NOT EXISTS (
        SELECT O.ProductName
        FROM Orders O
        WHERE O.CustomerID = C.CustomerID AND O.ProductName = P.ProductName
    )
);

SELECT P.ProductName
FROM Products P
WHERE NOT EXISTS (
    SELECT C.CustomerID
    FROM Customers C
    WHERE NOT EXISTS (
        SELECT O.ProductName
        FROM Orders O
        WHERE O.CustomerID = C.CustomerID AND O.ProductName = P.ProductName
    )
);

SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    SUM(Price * Quantity) AS TotalRevenue
FROM Orders O
JOIN Products P ON O.ProductName = P.ProductName
GROUP BY Month;


SELECT P.ProductName
FROM Products P
JOIN Orders O ON P.ProductName = O.ProductName
GROUP BY P.ProductName
HAVING COUNT(DISTINCT O.CustomerID) > (SELECT COUNT(*) * 0.5 FROM Customers);


SELECT C.CustomerID, C.Name
FROM Customers C
WHERE NOT EXISTS (
    SELECT P.ProductName
    FROM Products P
    WHERE CategoryID = 1 AND NOT EXISTS (
        SELECT O.ProductName
        FROM Orders O
        WHERE O.CustomerID = C.CustomerID AND O.ProductName = P.ProductName
    )
);


SELECT C.CustomerID, C.Name, SUM(P.Price * O.Quantity) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Products P ON O.ProductName = P.ProductName
GROUP BY C.CustomerID, C.Name
ORDER BY TotalSpent DESC
LIMIT 5;


SELECT CustomerID, OrderID, ProductName, Quantity, 
       SUM(Quantity) OVER (PARTITION BY CustomerID ORDER BY OrderID) AS RunningTotal
FROM Orders;


SELECT CustomerID, OrderID, ProductName, OrderDate
FROM (
    SELECT CustomerID, OrderID, ProductName, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum
    FROM Orders
) AS RankedOrders
WHERE RowNum <= 3;


SELECT C.CustomerID, C.Name, 
       SUM(P.Price * O.Quantity) AS TotalRevenue
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Products P ON O.ProductName = P.ProductName
WHERE O.OrderDate >= CURDATE() - INTERVAL 30 DAY
GROUP BY C.CustomerID, C.Name;


SELECT C.CustomerID, C.Name
FROM Customers C
WHERE (
    SELECT COUNT(DISTINCT CategoryID)
    FROM Products P
    JOIN Orders O ON P.ProductName = O.ProductName
    WHERE O.CustomerID = C.CustomerID
) >= 2;


SELECT C.CustomerID, C.Name,
       AVG(P.Price * O.Quantity) AS AvgRevenuePerOrder
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Products P ON O.ProductName = P.ProductName
GROUP BY C.CustomerID, C.Name;


SELECT DISTINCT P.ProductName
FROM Products P
JOIN Orders O ON P.ProductName = O.ProductName
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.Country = 'YourCountry';


SELECT C.CustomerID, C.Name
FROM Customers C
WHERE NOT EXISTS (
    SELECT DISTINCT DATE_FORMAT(OrderDate, '%Y-%m')
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID
    AND YEAR(OrderDate) = 2023
    AND NOT EXISTS (
        SELECT 1
        FROM Orders O2
        WHERE O2.CustomerID = O.CustomerID
        AND DATE_FORMAT(O2.OrderDate, '%Y-%m') = DATE_FORMAT(O.OrderDate, '%Y-%m')
    )
);


SELECT C.CustomerID, C.Name
FROM Customers C
WHERE EXISTS (
    SELECT 1
    FROM Orders O1
    JOIN Orders O2 ON O1.CustomerID = O2.CustomerID
    WHERE O1.ProductName = 'YourProduct'
    AND DATEDIFF(O2.OrderDate, O1.OrderDate) = 30
);


SELECT P.ProductName
FROM Products P
JOIN Orders O ON P.ProductName = O.ProductName
WHERE O.CustomerID = 1 -- Replace 1 with the specific CustomerID
GROUP BY P.ProductName
HAVING COUNT(*) >= 2;













