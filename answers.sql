-- Question 1: Achieving 1NF (First Normal Form)
-- Using a JOIN with a numbers table to split the comma-separated 'Products' column into individual rows.
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1;
------------------------------------------------------

-- Question 2: Achieving 2NF (Second Normal Form) 
-- Step 1: Create the 'Orders' table to store 'OrderID' and 'CustomerName'.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,           -- 'OrderID' is the primary key.
    CustomerName VARCHAR(255)          -- Store the customer name for each order.
);

-- Step 2: Create the 'OrderDetails' table, which stores 'OrderID', 'Product', and 'Quantity'.
CREATE TABLE OrderDetails (
    OrderID INT,                       -- 'OrderID' part of the primary key.
    Product VARCHAR(255),               -- 'Product' part of the primary key.
    Quantity INT,                       -- Store the quantity of each product for the order.
    PRIMARY KEY (OrderID, Product),     -- Composite primary key (OrderID, Product).
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)  -- 'OrderID' is a foreign key referencing the Orders table.
);

-- Step 3: Populate the 'Orders' table with distinct 'OrderID' and 'CustomerName' from the original table.
-- This ensures 'CustomerName' is stored in the 'Orders' table, removing the partial dependency on 'OrderID'.
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 4: Populate the 'OrderDetails' table with 'OrderID', 'Product', and 'Quantity'.
-- This step moves the product-related data into the new 'OrderDetails' table.
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OriginalOrderDetails;  -- Assuming 'OriginalOrderDetails' is the original table name.

