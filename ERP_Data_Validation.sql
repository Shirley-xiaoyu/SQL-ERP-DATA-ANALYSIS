-- =============================================
-- 0. Setup: Create Tables & Mock Data (For Demo Purpose)
-- Description: This section creates a temporary environment to test the queries below.
-- =============================================

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50)
);

-- Create Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    shipped_date DATE,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20)
);

-- Insert Mock Data (Simulating Real Scenarios)
INSERT INTO customers VALUES (1, 'TechCorp NZ', 'Auckland'), (2, 'BuildRight Ltd', 'Wellington');

INSERT INTO orders VALUES 
(101, 1, '2023-10-01', '2023-10-03', 5000.00, 'Completed'), -- Normal Order
(102, 2, '2023-10-05', '2023-10-20', 12000.00, 'Completed'), -- Delayed Shipment (>7 days)
(103, 99, '2023-10-10', NULL, 300.00, 'Pending'); -- Orphaned Order (Customer 99 does not exist)

-- =============================================
-- END OF SETUP
-- =============================================


/*
 * Project: ERP Data Integrity & Sales Analysis
 * Author: Shirley
 * Description: 
 * SQL scripts for validating enterprise data integrity and generating monthly sales reports.
 * Designed to simulate real-world ERP data management tasks.
 */

-- =============================================
-- 1. Data Validation: Check for Orphaned Orders
-- Purpose: Find orders that do not link to a valid customer profile.
-- =============================================
SELECT 
    o.order_id, 
    o.order_date, 
    o.total_amount, 
    o.customer_id
FROM 
    orders o
LEFT JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    c.customer_id IS NULL;

-- =============================================
-- 2. Business Analysis: Monthly Sales Report
-- Purpose: Aggregate revenue by month to track performance.
-- =============================================
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value
FROM 
    orders
WHERE 
    status = 'Completed'
GROUP BY 
    DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 
    sales_month DESC;

-- =============================================
-- 3. Operational Issue: Detect Delayed Shipments
-- Purpose: Flag orders that took longer than 7 days to ship.
-- =============================================
SELECT 
    order_id,
    order_date,
    shipped_date,
    DATEDIFF(shipped_date, order_date) AS processing_days
FROM 
    orders
WHERE 
    shipped_date IS NOT NULL 
    AND DATEDIFF(shipped_date, order_date) > 7
ORDER BY 
    processing_days DESC;

