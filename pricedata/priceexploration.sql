/* --------------------
   Case Study Questions
      Price Dataset
   --------------------*/

-- Test Case 1: Data Integrity Check
--Objective: Ensure all records have valid, non-null prices.

SELECT COUNT(*) FROM Prices WHERE price IS NULL OR price < 0;

--Test Case 2: Unique Product Identification
-- Objective: Verify each product has a unique identifier.

SELECT productId, COUNT(*) FROM Prices GROUP BY productId HAVING COUNT(*) > 1;

--Test Case 3: Price Trend Analysis Over Time
--Objective: Analyze the price trend for a specific product over time.

SELECT date, price FROM Prices WHERE productId = 'ProductID' ORDER BY date ASC;


--Test Case 4: Comparison of Average Prices Across Categories
--Objective: Compare the average price across different product categories.

SELECT category, AVG(price) FROM Prices GROUP BY category;

--Test Case 5: Detecting Price Anomalies
--Objective: Identify products with prices significantly above or below the average.

SELECT productId, price FROM Prices WHERE price > (SELECT AVG(price) * 1.5 FROM Prices) 
OR price < (SELECT AVG(price) * 0.5 FROM Prices);

--6.Test Case 6: Seasonal Pricing Changes
--Objective: Identify significant price changes that could indicate seasonal adjustments.

SELECT productId, AVG(price) AS AvgPrice, MONTH(date) AS Month FROM Prices GROUP BY productId, MONTH(date);

--Test Case 7: Price Distribution by Region
--Objective: Assess how prices are distributed across different regions.

SELECT region, MIN(price), AVG(price), MAX(price) FROM Prices GROUP BY region;

--Test Case 8: Historical Price Comparison
--Objective: Compare current prices to historical averages.

SELECT productId, price AS CurrentPrice, (SELECT AVG(price) FROM Prices AS p2 
WHERE p2.productId = p1.productId AND p2.date < '2023-01-01') 
AS HistoricalAvg FROM Prices AS p1 WHERE p1.date >= '2023-01-01';

--Test Case 9: Detecting Out-of-Range Prices
--Objective: Identify prices that fall outside an expected range.

SELECT * FROM Prices WHERE price NOT BETWEEN 10 AND 1000;


--Test Case 10: Year-over-Year Price Changes
--Objective: Calculate the year-over-year price change for products.

SELECT productId, (price - LAG(price) OVER (PARTITION BY productId ORDER BY date)) / LAG(price)
OVER (PARTITION BY productId ORDER BY date) AS YoYChange FROM Prices;

 --Test Case 11: Top 10 Most Expensive Products
--Objective: Identify the top 10 most expensive products.

SELECT productId, price FROM Prices ORDER BY price DESC LIMIT 10;

--Test Case 12: Price Fluctuation Frequency
--Objective: Determine how frequently product prices change.

SELECT productId, COUNT(DISTINCT price) AS PriceChanges FROM Prices GROUP BY productId;










