--------  Financial Impact Analysis -----------
--------                            -----------

/*
Business Question 1:
What is the total revenue lost due to returned orders?
*/

SELECT
    ROUND(SUM(total_amount), 2) AS revenue_lost
FROM ecommerce_returns
WHERE returned = 1;

/*Result:
Returned orders account for a total revenue loss of 388,755.97.
*/
/*
Business Question:
What percentage of total sales value is associated with returned orders?*/
SELECT
    ROUND(SUM(CASE WHEN returned = 1 THEN total_amount ELSE 0 END),2) AS returned_sales_value,
    ROUND(SUM(total_amount),2) AS total_sales,
    ROUND(
        SUM(CASE WHEN returned = 1 THEN total_amount ELSE 0 END)
        *100.0/
        SUM(total_amount),
        2
    ) AS revenue_loss_pct
FROM ecommerce_returns;
/*Key Finding:
Returned orders represent 6.63% of the total sales value.
*/

/*
Business Question:
How does the average value of returned orders compare with the overall average order value?
*/
SELECT
	AVG(total_amount) AS avg_ordervalue
FROM ecommerce_returns
/*Key Findings:
- Average Order Value: 170.01
- Average Returned Order Value: 204.29*/


/*Business Question 2:
What is the total profit lost due to returned orders?
*/
SELECT
    ROUND(SUM(profit_margin), 2) AS profit_lost
FROM ecommerce_returns
WHERE returned = 1;

/*Result:
Returned orders are associated with a total profit value of 61,805.46.
*/

/*
Business Question 3:
Which product categories generate the highest revenue loss?
*/

SELECT
    category,
    COUNT(*) AS returned_orders,
    ROUND(SUM(total_amount),2) AS revenue_lost
FROM ecommerce_returns
WHERE returned = 1
GROUP BY category
ORDER BY revenue_lost DESC;
/*Key Finding:
Electronics contributes the highest returned sales value
despite Fashion having the highest return rate.
*/

/*
Business Question 4:
Which product categories generate the highest profit loss?
*/

SELECT
    category,
    ROUND(SUM(profit_margin),2) AS profit_lost
FROM ecommerce_returns
WHERE returned = 1
GROUP BY category
ORDER BY profit_lost DESC;

SELECT DISTINCT(EXTRACT(YEAR FROM order_date))
FROM ecommerce_returns

/*Key Finding:
Electronics contributes the highest profit loss
despite Fashion having the highest return rate.
*/

/*
Business Question 5:
How has the financial impact of returned orders changed over time?*/

SELECT
	EXTRACT(YEAR FROM order_date) AS order_year,
	COUNT(*) AS returned_orders,
    SUM(total_amount) AS revenue_loss
FROM ecommerce_returns
WHERE returned=1
GROUP BY order_year
ORDER BY order_year

/*
Key Finding:
2024 recorded the highest returned sales value (196,327.50)
and the highest number of returned orders (967).*/

/*
Business Question 8.5:
Which regions contribute the highest financial impact from returned orders?*/
SELECT
    region,
    COUNT(*) AS returned_orders,
    ROUND(SUM(total_amount),2) AS revenue_loss,
    ROUND(SUM(profit_margin),2) AS profit_impact
FROM ecommerce_returns
WHERE returned = 1
GROUP BY region
ORDER BY revenue_loss DESC;
/*Key Findings:
- South generated the highest returned sales value (94,242.83) and profit impact (14,729.00).
- East ranked second in both returned sales value and profit impact.
- Central recorded the lowest financial impact among all regions.*/

/*
Business Question:
What is the average value of a returned order?*/
SELECT
    ROUND(AVG(total_amount),2) AS avg_returned_order_value
FROM ecommerce_returns
WHERE returned = 1;

/*Key Finding:
The average returned order is valued at 204.29.*/

/*
Business Question:
What is the average profit associated with each returned order?*/
SELECT
    ROUND(AVG(profit_margin),2) AS avg_profit_per_return
FROM ecommerce_returns
WHERE returned = 1;

/*Key Finding:
Each returned order is associated with an average profit value of 32.48.
*/

/*
Business Question:
Which return reasons generate the greatest financial impact?*/
SELECT
    return_reason,
    COUNT(*) AS returned_orders,
    ROUND(SUM(total_amount),2) AS revenue_loss,
    ROUND(SUM(profit_margin),2) AS profit_impact
FROM ecommerce_returns
WHERE returned = 1
GROUP BY return_reason
ORDER BY revenue_loss DESC;
/*Key Findings:
- Not as described accounts for the highest returned sales value (105,010.39).
- Defective and Missing/Wrong item also contribute significantly.
- Slow delivery represents only a small proportion of the financial impact.
*/

/*
Business Question:
What shipping cost is associated with returned orders?*/
SELECT
    ROUND(SUM(shipping_cost),2) AS shipping_cost_returns
FROM ecommerce_returns
WHERE returned = 1;
/*Key Finding:
Returned orders are associated with 12,622.58 in shipping costs.*/

/*
====================================================
EXECUTIVE SUMMARY
====================================================

Dataset Size:
• 34,500 Orders

Overall Return Rate:
• 5.52%

Key Findings:
• Fashion has the highest return rate (8.28%)
• Electronics generates the highest returned sales value
• Product-related issues account for over 98% of returns
• Regional and demographic differences are minimal
• Returned sales value = 388,755.97
• Returned sales represent 6.63% of total sales
• Average returned order value is 20% higher than the average order value

Business Recommendation:
Prioritize return reduction efforts for high-value Electronics and Fashion products by improving product quality, product descriptions, and implementing a predictive return risk model.
*/
