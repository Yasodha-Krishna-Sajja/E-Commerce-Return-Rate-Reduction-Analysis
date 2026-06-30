/*
===========================================
Project: E-commerce Return Risk Prediction
Phase 3: SQL Business Analysis
Author: Sajja Yasodha Krishna
Database: PostgreSQL
===========================================
*/

CREATE TABLE ecommerce_returns (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    category VARCHAR(50),
    price NUMERIC(10,2),
    discount NUMERIC(5,2),
    quantity INTEGER,
    payment_method VARCHAR(50),
    order_date DATE,
    delivered_date DATE,
    region VARCHAR(50),
    returned INTEGER,
    request_date DATE,
    return_reason VARCHAR(100),
    total_amount NUMERIC(12,2),
    shipping_cost NUMERIC(10,2),
    profit_margin NUMERIC(12,2),
    customer_age INTEGER,
    customer_gender VARCHAR(20),
    delivery_days INTEGER,
    age_group VARCHAR(10)
);

--------  Business Analysis -----------
--------                    -----------
SELECT *FROM ecommerce_returns LIMIT 10

/*
Business Question 1:
What percentage of orders are returned?
*/
SELECT
	COUNT(*) AS total_orders,
	SUM(returned) AS returned_orders,
	ROUND(SUM(returned)* 100.0/COUNT(*),2) AS pct_returned
FROM
	ecommerce_returns
/*
Result:
- Total Orders: 34,500
- Returned Orders: 1,903
- Return Rate: 5.52%
*/


/*
Business Question 2:
Which product categories have the highest return rates?
*/
SELECT
	category,
	COUNT(*) AS total_orders,
	SUM(returned) AS returned_orders,
	ROUND(SUM(returned) * 100.0 / COUNT(*),2) AS pct_returned
FROM
	ecommerce_returns
GROUP BY category
ORDER BY returned_orders DESC

/*
Key Finding:
Fashion (8.28%) and Electronics (7.30%)
have the highest return rates.
*/


/*
Business Question 3:
Which geographic regions experience the highest return rates?
*/
SELECT
	region,
	COUNT(*) AS total_orders,
	SUM(returned) AS returned_orders,
	ROUND(SUM(returned) * 100.0 / COUNT(*),2) AS pct_returned
FROM
	ecommerce_returns
GROUP BY region
ORDER BY pct_returned DESC

/*Key Finding:
- East recorded the highest return rate (5.91%).
- Central recorded the lowest return rate (5.10%).
- Return rates across regions vary by less than one percentage point.
*/

/*
Business Question 4:
What are the most common reasons for product returns?
*/
SELECT
    return_reason,
    COUNT(*) AS return_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_share
FROM ecommerce_returns
WHERE returned = 1
GROUP BY return_reason
ORDER BY return_count DESC;

/*Key Finding:
- Not as described is the leading return reason (25.75%).
- Slow delivery accounts for only 1.47% of returns.
*/

/*
Business Question 5:
How do return rates vary across different customer age groups? */
SELECT
	age_group,
	COUNT(*) AS total_orders,
	SUM(returned) AS returned_orders,
	ROUND(SUM(returned) * 100.0 / COUNT(*),2) AS pct_returned
FROM
	ecommerce_returns
GROUP BY age_group
ORDER BY returned_orders DESC

/*Key Finding:
- Customers aged 36–45 recorded the highest return rate (5.93%).
- Customers aged 46–60 generated the highest number of returned orders due to having the largest customer base.
*/

/*
Business Question 6:
Does return behavior differ across customer genders?*/
SELECT
	customer_gender,
	COUNT(*) AS total_orders,
	SUM(returned) AS returned_orders,
	ROUND(SUM(returned) * 100.0 / COUNT(*),2) AS pct_returned
FROM
	ecommerce_returns
GROUP BY customer_gender
ORDER BY returned_orders DESC
/*
Key Finding:
- Female customers recorded the highest return rate (5.62%).
- Return rates across genders are highly consistent, with less than a 0.5 percentage point difference.
*/

/*
Business Question 7:
Does delivery duration influence return behavior?*/
SELECT
    delivery_days,
    COUNT(*) AS total_orders,
    SUM(returned) AS returned_orders,
    ROUND(
        SUM(returned) * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM ecommerce_returns
GROUP BY delivery_days
ORDER BY delivery_days DESC

/*Key Finding:
Return rates remain relatively stable for deliveries completed within
3 to 8 days. A higher return rate is observed for 9-day deliveries,
although the sample size is considerably smaller.
*/

/*
Business Question:
How has the return rate changed over time?
*/
SELECT
	EXTRACT(YEAR FROM order_date) AS order_year,
	COUNT(*) AS total_orders,
    SUM(returned) AS returned_orders,
    ROUND(
        SUM(returned) * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM ecommerce_returns
GROUP BY order_year
ORDER BY order_year
/*Key Finding:
The return rate remained relatively stable between 2023 and 2025,
ranging from 5.16% to 5.64%.
*/

/*
Business Question:
How has the monthly return rate changed over time?*/
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    COUNT(*) AS total_orders,
    SUM(returned) AS returned_orders,
    ROUND(
        SUM(returned)::NUMERIC * 100 / COUNT(*),
        2
    ) AS return_rate_pct
FROM ecommerce_returns
GROUP BY order_month
ORDER BY order_month;
/*Key Finding:
Monthly return rates remained relatively stable throughout the
analysis period, with occasional peaks exceeding 6%.
*/