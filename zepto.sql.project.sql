DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availablequantity INTEGER,
discountedsellingprice NUMERIC(8,2),
weightingram INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

--Data Exploration

--Count of Rows
SELECT COUNT (*) FROM zepto;

--Sample Data 
SELECT * FROM zepto
LIMIT 10;

--Null Values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingram IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--Different Product Cetegories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Products in Stock VS Out of Stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--Product Names Present Multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--Data Cleaning

--Products With Price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--Convert Paise to Rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;

--Q1. Find the top 10 best-value Products based on the discount Percentage.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2. Calculate Estimated Revenue for each category.
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculate Estimated Revenue for each Category.
SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all Products where MRP is greater than RS.500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

--Q5. Identify the top 5 Categories offering the highest average discount Percentage.
SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the Price Per gram for Products adove 100g and sort by best value.
SELECT DISTINCT name, weightingram, discountedsellingprice,
ROUND(discountedsellingprice/weightingram,2) AS price_per_gram
FROM zepto
WHERE weightingram >= 100
ORDER BY price_per_gram;

--Q7. Group the Products into Categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightingram,
CASE WHEN weightingram < 1000 THEN 'Low'
WHEN weightingram < 5000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto;

--Q8. What is the Total Inventory Weight Per Category.
SELECT category,
SUM(weightingram * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


