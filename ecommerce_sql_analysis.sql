-- E-COMMERCE SALES & CUSTOMER ANALYSIS (SQL)
-- Author: Sunaina Agarwal
-- Tool: SQLite
-- Dataset: Brazilian E-Commerce (Kaggle - Olist)

-- 1. Total revenue generated
SELECT 
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items;
-- -----------------------------------------------------

-- 2. Monthly revenue trend
SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;
-- -----------------------------------------------------

-- 3. Top 10 customers by total spending
SELECT 
    c.customer_id,
    ROUND(SUM(oi.price), 2) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;
-- -----------------------------------------------------

-- 4. Rank customers based on spending (Window Function)
SELECT
    customer_id,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS customer_rank
FROM (
    SELECT 
        c.customer_id,
        SUM(oi.price) AS total_spent
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
);
-- -----------------------------------------------------

-- 5. Average delivery time in days
SELECT 
    ROUND(
        AVG(
            julianday(order_delivered_customer_date) -
            julianday(order_purchase_timestamp)
        ), 
    2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
-- -----------------------------------------------------

-- 6. Customers with more than one order (repeat ones)
SELECT 
    customer_id,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING order_count > 1
ORDER BY order_count DESC;
-- -----------------------------------------------------

-- 7. Number of orders by order status
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY