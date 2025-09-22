SELECT * FROM Walmart_sales;
SELECT COUNT(*) AS Total_rows FROM Walmart_sales;
SELECT DISTINCT payment_method FROM Walmart_sales;
SELECT DISTINCT payment_method,COUNT(*) FROM Walmart_sales GROUP BY payment_method;
SELECT COUNT(DISTINCT Branch) AS Unique_Branches FROM Walmart_sales;
SELECT MIN(quantity) as Minimum_quanity FROM Walmart_sales;

-- 1. What are the different payment methods, and how many transactions and items were sold with each method? 
SELECT payment_method,COUNT(*) AS no_transactions, SUM(quantity) AS items_sold FROM Walmart_sales GROUP BY payment_method;

-- 2. Which category received the highest average rating in each branch?
SELECT Branch, category, avg_rating
FROM (
    SELECT 
        Branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
    FROM Walmart_sales
    GROUP BY branch, category
) AS ranked
WHERE rank = 1;

-- 3: Calculate the total quantity of items sold per payment method
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM Walmart_sales
GROUP BY payment_method;

-- 4: Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM Walmart_sales
GROUP BY city, category;

-- 5: Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM Walmart_sales
GROUP BY category
ORDER BY total_profit DESC;

-- 6: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        Branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS rank
    FROM Walmart_sales
    GROUP BY Branch, payment_method
)
SELECT Branch, payment_method AS preferred_payment_method
FROM cte
WHERE rank = 1;

