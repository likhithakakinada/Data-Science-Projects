/* Create the Table */
CREATE TABLE IF NOT EXISTS store(
Row_ID SERIAL,
Order_ID CHAR(25),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID CHAR(25),
Customer_Name VARCHAR(75),
Segment VARCHAR(25),
Country VARCHAR(50),
City VARCHAR(50),
States VARCHAR(50),
Postal_Code INT,
Region VARCHAR(12),
Product_ID VARCHAR(75),
Category VARCHAR(25),
Sub_Category VARCHAR(25),
Product_Name VARCHAR(255),
Sales FLOAT,
Quantity INT,
Discount FLOAT,
Profit FLOAT,
Discount_amount FLOAT,
Years INT,
Customer_Duration VARCHAR(50),
Returned_Items VARCHAR(50),
Return_Reason VARCHAR(255)
) 

/* checking the raw Table */
SELECT * FROM store

/* Importing csv file */
SET client_encoding = 'ISO_8859_5';
COPY store(Row_ID,Order_ID,Order_Date,Ship_Date,Ship_Mode,Customer_ID,Customer_Name,Segment,Country,City,States,Postal_Code,Region,Product_ID,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit,Discount_Amount,Years,Customer_Duration,Returned_Items,Return_Reason)
FROM 'C:\to path\Store.csv'
DELIMITER ','
CSV HEADER;

/* Dataset Look */
SELECT * FROM store

-- DATASET  INFORMATION
-- Customer_Name   : Customer's Name
-- Customer_Id  : Unique Id of Customers
-- Segment : Product Segment
-- Country : United States
-- City : City of the product ordered
-- State : State of product ordered
-- Product_Id : Unique Product ID
-- Category : Product category
-- Sub_Category : Product sub category
-- Product_Name : Name of the product
-- Sales : Sales contribution of the order
-- Quantity : Quantity Ordered
-- Discount : % discount given
-- Profit : Profit for the order
-- Discount_Amount : discount  amount of the product 
-- Customer Duration : New or Old Customer
-- Returned_Item :  whether item returned or not
-- Returned_Reason : Reason for returning the item

--Database Size
SELECT pg_size_pretty(pg_database_size('Data Analysis using sql'))

--Table Size
SELECT pg_size_pretty(pg_relation_size('store'))

/* row count of data */
SELECT COUNT(*) AS Row_Count FROM store

/* Check Dataset Information */
SELECT *
FROM information_schema.columns
WHERE table_name = 'store'

/* column count of data */
SELECT COUNT(*) AS Column_Count
FROM information_schema.columns
WHERE table_name = 'store'

/*  get column names of store data */
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'store'

/* get column names with data type of store data */
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'store'

/* checking null values of store data */
/* Using Nested Query */
SELECT * FROM STORE
WHERE (SELECT column_name
FROM information_schema.columns
WHERE table_name = 'store') = NULL
/* No Missing Values Found */

/* Dropping Unnecessary column like Row_ID */
ALTER TABLE store DROP COLUMN row_id
SELECT * FROM store LIMIT 5

/* Check the count of United States */
SELECT COUNT(*) AS US_count FROM store
WHERE country = 'United States'

/* PRODUCT LEVEL ANALYSIS*/
/* What are the unique product categories? */
SELECT DISTINCT category FROM store

/* What is the number of products in each category? */
SELECT category,COUNT(*) AS No_of_Products FROM store
GROUP BY category
ORDER BY COUNT(*) DESC

/* Find the number of Subcategories products that are divided. */
SELECT COUNT(DISTINCT(sub_category)) As No_of_Sub_Categories FROM store

/* Find the number of products in each sub-category. */
SELECT sub_category,COUNT(*) AS No_of_products FROM store
GROUP BY sub_category
ORDER BY COUNT(*) DESC

/* Find the number of unique product names. */
SELECT COUNT(DISTINCT product_name) As No_of_unique_products FROM store

/* Which are the Top 10 Products that are ordered frequently? */
SELECT product_name,COUNT(*) AS No_of_products FROM store
GROUP BY product_name
ORDER BY COUNT(*) DESC
LIMIT 10

/* Calculate the cost for each Order_ID with respective Product Name. */
SELECT order_id,product_name,ROUND(CAST((sales-profit) AS NUMERIC),2) AS cost
FROM store

/* Calculate % profit for each Order_ID with respective Product Name. */
select order_id,product_name,ROUND(CAST(((profit * 100)/(sales-profit))AS numeric),2) AS percentage_profit
FROM store

/* Calculate the overall profit of the store. */
select ROUND(CAST(((SUM(profit)/((sum(sales)-sum(profit))))*100)AS NUMERIC),2) as percentage_profit 
from store

/* Calculate percentage profit and group by them with Product Name and Order_Id. */
select order_id,product_name,ROUND(CAST(((profit * 100)/(sales-profit))AS numeric),2) AS percentage_profit
FROM store
GROUP BY product_name, order_id,percentage_profit 

/* Where can we trim some loses? 
   In Which products?
   We can do this by calculating the average sales and profits, and comparing the values to that average.
   If the sales or profits are below average, then they are not best sellers and 
   can be analyzed deeper to see if its worth selling thema anymore. */

SELECT ROUND(CAST(AVG(sales) AS numeric),2) AS avg_sales
FROM store
-- the average sales on any given product is 229.8, so approx. 230.

SELECT ROUND(CAST(AVG(profit) AS numeric),2) AS avg_sales
FROM store
-- the average profit on any given product is 28.6, or approx 29.

-- Average sales per sub-cat
SELECT sub_category,ROUND(CAST(AVG(sales) AS numeric),2) AS avg_sales
FROM store
GROUP BY sub_category
ORDER BY avg_sales 
--The sales of these Sub_category products are below the average sales.

-- Average profit per sub-cat
SELECT sub_category,ROUND(CAST(AVG(profit) AS numeric),2) AS avg_profit
FROM store
GROUP BY sub_category
ORDER BY avg_profit 

--The profit of these Sub_category products are below the average profit.
-- "Minus sign" Respresnts that those products are in losses.

/* CUSTOMER LEVEL ANALYSIS*/
/* What is the number of unique customer IDs? */
SELECT COUNT(DISTINCT customer_id) FROM store

/* Find those customers who registered during 2014-2016. */
SELECT distinct customer_name,years
FROM store WHERE customer_id is NOT NULL AND years BETWEEN 2014 AND 2016 
ORDER BY years

/* Calculate Total Frequency of each order id by each customer Name in descending order. */
SELECT order_id,customer_name,COUNT(order_id) AS total_order_id 
FROM store
GROUP BY order_id,customer_name
ORDER BY total_order_id DESC

/* Calculate  cost of each customer name. */
SELECT customer_name,sales,(sales-profit) AS cost
FROM store
GROUP BY  customer_name,sales,cost

/* Display No of Customers in each region in descending order. */
SELECT region,COUNT(*) AS no_of_customers
FROM store
GROUP BY region
ORDER BY no_of_customers DESC

/* Find Top 10 customers who order frequently. */
SELECT customer_name,COUNT(*) AS no_of_orders
FROM store
GROUP BY customer_name
ORDER BY no_of_orders DESC
LIMIT 10

 /* Display the records for customers who live in state California and Have postal code 90032. */
 SELECT * FROM store
 WHERE states = 'California' AND postal_code = '90032'
 
 /* Find Top 20 Customers who benefitted the store.*/
SELECT Customer_Name, Profit
FROM store
GROUP BY Customer_Name,Profit
order by  Profit desc
limit 20

--Which state(s) is the superstore most succesful in? Least?
--Top 10 results:
SELECT round(cast(sum(Profit) as numeric),2) as profit,states
FROM store
GROUP BY states
order by  profit desc
limit 10

/* ORDER LEVEL ANALYSIS */
/* number of unique orders */
SELECT count(DISTINCT order_id) AS no_of_unique_orders FROM store

/* Find Sum Total Sales of Superstore. */
SELECT ROUND(CAST(SUM(sales) AS numeric),2) FROM store

/* Calculate the time taken for an order to ship and converting the no. of days in int format. */
SELECT order_id,(ship_date - order_date) AS time_taken 
FROM store
ORDER BY time_taken DESC

/* Extract the year for respective order ID and Customer ID with quantity. */
SELECT order_id,customer_id,quantity,EXTRACT(year FROM order_date) AS year
FROM store 
group by order_id,customer_id,quantity,EXTRACT(year from Order_Date) 
order by quantity desc

/* What is the Sales impact? */
SELECT EXTRACT(YEAR from Order_Date), Sales, round(cast(((profit/((sales-profit))*100))as numeric),2) as profit_percentage
FROM store
GROUP BY EXTRACT(YEAR from Order_Date), Sales, profit_percentage
order by  profit_percentage 
limit 20

--Breakdown by Top vs Worst Sellers:
-- Find Top 10 Categories (with the addition of best sub-category within the category).
SELECT category,sub_category,round(cast(sum(sales)as numeric),2) as prod_sales
FROM store
GROUP BY category,sub_category
ORDER BY prod_sales DESC
LIMIT 10

--Find Top 10 Sub-Categories. :
SELECT sub_category,round(cast(sum(sales)as numeric),2) as prod_sales
FROM store
GROUP BY sub_category
ORDER BY prod_sales DESC
OFFSET 1 ROWS
FETCH NEXT 10 ROWS ONLY

--Find Worst 10 Categories.:
SELECT category,sub_category,round(cast(sum(sales)as numeric),2) as prod_sales
FROM store
GROUP BY category,sub_category
ORDER BY prod_sales ASC
LIMIT 10

-- Find Worst 10 Sub-Categories. :
SELECT sub_category,round(cast(sum(sales)as numeric),2) as prod_sales
FROM store
GROUP BY sub_category
ORDER BY prod_sales 
OFFSET 1 ROWS
FETCH NEXT 10 ROWS ONLY

/* Show the Basic Order information. */
select count(Order_ID) as Purchases,
round(cast(sum(Sales)as numeric),2) as Total_Sales,
round(cast(sum(((profit/((sales-profit))*100)))/ count(*)as numeric),2) as avg_percentage_profit,
min(Order_date) as first_purchase_date,
max(Order_date) as Latest_purchase_date,
count(distinct(Product_Name)) as Products_Purchased,
count(distinct(City)) as Location_count
from store

/* RETURN LEVEL ANALYSIS */
/* Find the number of returned orders. */
SELECT * FROM store
SELECT returned_items,COUNT(*) AS count_returned FROM store
GROUP BY returned_items
HAVING returned_items = 'Returned'

--Find Top 10 Returned Categories.:
SELECT category,sub_category,returned_items,count(returned_items) as count_returned
FROM store
GROUP BY category,returned_items,sub_category
HAVING returned_items = 'Returned'
ORDER BY count_returned DESC
LIMIT 10

-- Find Top 10  Returned Sub-Categories.:
SELECT sub_category,returned_items,count(returned_items) as count_returned
FROM store
GROUP BY returned_items,sub_category
HAVING returned_items = 'Returned'
ORDER BY count_returned DESC
LIMIT 10

--Find Top 10 Customers Returned Frequently.:
SELECT customer_name,returned_items,count(returned_items) as count_returned
FROM store
GROUP BY customer_name,returned_items
HAVING returned_items = 'Returned'
ORDER BY count_returned DESC
LIMIT 10

-- Find Top 20 cities and states having higher return.
SELECT city,states,returned_items,count(returned_items) as count_returned
FROM store
GROUP BY city,states,returned_items
HAVING returned_items = 'Returned'
ORDER BY count_returned DESC
LIMIT 20

--Check whether new customers are returning higher or not.
SELECT customer_duration,returned_items,count(returned_items) as count_returned
FROM store
GROUP BY customer_duration,returned_items
HAVING returned_items = 'Returned'
ORDER BY count_returned DESC

--Find Top  Reasons for returning.
SELECT returned_items,return_reason,count(returned_items) as count_returned
FROM store
GROUP BY returned_items,return_reason
HAVING returned_items <> 'Not Returned' AND return_reason <> 'Not Returned'
ORDER BY count_returned DESC
