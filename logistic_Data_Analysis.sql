-- 1️⃣ Data Inspection & Cleanup

-- 1.1 Preview Datasets
SELECT * FROM logistic_database.incom2024_delay_example_dataset LIMIT 10;
SELECT * FROM logistic_database.delay_variable_description LIMIT 10;

-- 1.2 Check Data Structure
DESCRIBE logistic_database.incom2024_delay_example_dataset;

-- 1.3 Modify Data Types 
ALTER TABLE logistic_database.incom2024_delay_example_dataset
MODIFY COLUMN order_date DATETIME;
ALTER TABLE logistic_database.incom2024_delay_example_dataset
MODIFY COLUMN shipping_date DATE;

-- 1.4 Check for Missing Values
SELECT *
FROM logistic_database.incom2024_delay_example_dataset
WHERE customer_id IS NULL OR order_id IS NULL;

-- 2️⃣ Sales & Profitability Analysis

-- 2.1 Total Sales by Order Region
SELECT order_region, SUM(sales) AS total_sales
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY order_region
ORDER BY total_sales DESC;

-- 2.2 Total Sales and Profit by Customer Segment
SELECT customer_segment, SUM(sales) AS total_sales, SUM(profit_per_order) AS total_profit
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY customer_segment
ORDER BY total_profit DESC;

-- 2.3 Impact of Discounts on Profitability
SELECT order_item_discount, AVG(profit_per_order) AS avg_profit,
       SUM(profit_per_order) AS total_profit, COUNT(order_id) AS total_orders
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY order_item_discount
ORDER BY order_item_discount DESC;

-- 2.4 Correlation Between Discounts and Profit
SELECT CORR(order_item_discount, profit_per_order) AS discount_profit_correlation
FROM logistic_database.incom2024_delay_example_dataset;

-- 3️⃣ Sales Trend Over Time
SELECT EXTRACT(YEAR FROM order_date) AS year, EXTRACT(MONTH FROM order_date) AS month,
       SUM(sales) AS total_sales
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY year, month
ORDER BY year, month;

-- 4️⃣ Delivery Performance Analysis

-- 4.1 Categorizing Order Delivery Status
SELECT CASE 
           WHEN label = 1 THEN 'Delayed'
           WHEN label = 0 THEN 'On Time'
           ELSE 'Early Delivered'
       END AS delivery_status, COUNT(order_id) AS order_count
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY delivery_status;

-- 4.2 Average Delivery Time by Shipping Mode
SELECT shipping_mode, AVG(DATEDIFF(shipping_date, order_date)) AS avg_delivery_time
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY shipping_mode
ORDER BY avg_delivery_time;

-- 4.3 Delayed Orders by State & Region
SELECT order_region, order_state, COUNT(label) AS delayed_orders
FROM logistic_database.incom2024_delay_example_dataset
WHERE label = 1
GROUP BY order_region, order_state
ORDER BY delayed_orders DESC;

-- 4.4 Monthly Delivery Performance Trends
SELECT EXTRACT(YEAR FROM order_date) AS year, EXTRACT(MONTH FROM order_date) AS month,
       COUNT(CASE WHEN label = -1 THEN 1 END) AS early_deliveries,
       COUNT(CASE WHEN label = 0 THEN 1 END) AS on_time_deliveries,
       COUNT(CASE WHEN label = 1 THEN 1 END) AS delayed_deliveries,
       ROUND((COUNT(CASE WHEN label = 1 THEN 1 END) * 100.0) / COUNT(order_id), 2) AS delayed_percentage
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY year, month
ORDER BY year, month;

-- 5️⃣ Customer Analysis

-- 5.1 Top 10 Cities with Highest Customer Base & Products
SELECT customer_city, COUNT(customer_id) AS customer_count, COUNT(DISTINCT product_card_id) AS total_products
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY customer_city
ORDER BY customer_count DESC, total_products DESC
LIMIT 10;

-- 5.2 Customer Segments & Purchasing Behavior
SELECT customer_segment, COUNT(customer_id) AS total_customers, SUM(sales) AS total_sales,
       COUNT(DISTINCT product_card_id) AS total_products
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY customer_segment
ORDER BY total_customers DESC, total_sales DESC, total_products DESC;

-- 6️⃣ Regional Analysis

-- 6.1 Total Sales by City and Country
SELECT customer_city, customer_country, SUM(sales) AS total_sales
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY customer_city, customer_country
ORDER BY total_sales DESC;

-- 6.2 Order Volume by Region
SELECT order_region, COUNT(order_id) AS total_orders
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY order_region
ORDER BY total_orders DESC;

-- 6.3 Delayed Orders by Region
SELECT order_region, COUNT(order_id) AS total_orders,
       SUM(CASE WHEN label = 'Delayed' THEN 1 ELSE 0 END) AS delayed_orders,
       ROUND((SUM(CASE WHEN label = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)), 2) AS delay_percentage
FROM logistic_database.incom2024_delay_example_dataset
GROUP BY order_region
ORDER BY delay_percentage DESC;
