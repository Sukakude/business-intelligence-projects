/*
	The purpose of this script is for Exploratory Data Analysis.

*/

/*
	*** DATA EXPLORATION ***
*/
-- Explore all objects in the database
SELECT *  FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns for the table 'dim_customers' in the database 'DataWarehouse'
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


/*
	*** DIMENSION EXPLORATION ***
*/

-- Explore all geographical spread of our customers
SELECT DISTINCT country FROM Gold.dim_customers;
-- Insight: Our customers are spread across 6 different countries (Germany, US, UK, Australia, France, Canada).

-- Explore all the major product categories in the business
SELECT DISTINCT category, subcategory, product_name 
FROM Gold.dim_products
ORDER BY 1,2,3;
-- Insight: We have 4 major categories, 36 subcategories, and 295 products. 


/*
	*** DATE EXPLORATION ***
*/
-- Check how many years of sales data is available
SELECT DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS total_years
FROM Gold.fact_sales;

-- Finding the youngest/oldest customers
SELECT 
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS youngest_birthdate,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM Gold.dim_customers;
-- Insight: The oldest customer is 109 years old (as of 2025), and the youngest is 39 years old (as of 2025)

/*
	*** MEASURES EXPLORATION ***
*/

-- Finding the total sales
SELECT SUM(sales_amount) AS total_sales FROM Gold.fact_sales;
-- Insight: The total sales revenue for this business is around 29 million dollars.

-- Determine how many items are sold
SELECT SUM(quantity) AS total_items_sold FROM Gold.fact_sales;
-- Insight: 60423 items have been sold over the last 4 years, and these items have generated a revenue of almost 30 million dollars.

-- Determine the average sales price
SELECT AVG(price) AS avg_sales_price FROM Gold.fact_sales;
-- Insight: The average sales price over the last four years is 486 dollars. This means the business is most likely selling expensive items.

-- Determine how many orders have been made
SELECT COUNT(DISTINCT order_number) AS total_orders FROM Gold.fact_sales;
-- Insight: There have been 27659 orders placed over the last four years

-- Determine the total number of products
SELECT COUNT(DISTINCT product_key) AS total_products FROM Gold.dim_products;
-- Insight: There are 295 products in the business.

-- Determine the total number of customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM Gold.dim_customers;
-- Insight: There are 18 484 registered customers. However, some customers may have not placed an order.

-- Determine the total number of customers who have placed an order
SELECT COUNT(DISTINCT customer_key) as total_customers_with_order
FROM Gold.fact_sales;
-- Insight: There are 18 484 registered customers, and all customers have placed an order.


-- Report to show the Key Metrics of the business
SELECT 
	'Total Sales' AS measure_name,
	SUM(sales_amount) AS measure_value
FROM Gold.fact_sales
UNION ALL
SELECT
	'Total Quantity' AS measure_name,
	SUM(quantity) AS measure_value 
FROM Gold.fact_sales
UNION ALL
SELECT
	'Avg Price' AS measure_name,
	AVG(price) AS measure_value
FROM Gold.fact_sales
UNION ALL
SELECT
	'Total Nr. Orders' AS measure_name,
	COUNT(DISTINCT order_number) AS measure_value
FROM Gold.fact_sales
UNION ALL
SELECT
	'Total Nr. Products' AS measure_name,
	COUNT(DISTINCT product_key) AS measure_value
FROM Gold.dim_products
UNION ALL
SELECT
	'Total Nr. Customers' AS measure_name,
	COUNT(DISTINCT customer_id) AS measure_value
FROM Gold.dim_customers;


/*
	*** MAGNITUDE ANALYSIS ***
*/

-- Determine the total customers by countries
SELECT country, COUNT(customer_key) AS total_customers
FROM Gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Determine the total customers by gender
SELECT gender, COUNT(customer_key) AS total_customers
FROM Gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Determine the total products by category
SELECT 
	category, 
	COUNT(DISTINCT product_key) as total_products
FROM Gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Determine the average cost in each category
SELECT 
	category, 
	AVG(cost) as avg_cost
FROM Gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;


-- Determine the total revenue for each category
SELECT 
	p.category,
	SUM(sales_amount) as total_sales
FROM Gold.fact_sales s
LEFT JOIN Gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

-- Determine the total revenue for each customer
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(sales_amount) as total_sales
FROM Gold.fact_sales s
LEFT JOIN Gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_sales DESC;

-- Determine the distribution of sold items across countries
SELECT
	c.country,
	SUM(quantity) as total_sold_items
FROM Gold.fact_sales s
LEFT JOIN Gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;

-- Determine the top 5 product generated the highest revenue
SELECT TOP 5
	p.product_name,
	SUM(sales_amount) as total_sales
FROM Gold.fact_sales s
LEFT JOIN Gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY p.product_name DESC;



