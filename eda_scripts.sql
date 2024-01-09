-- Database Creation
CREATE DATABASE hotel_revenue;

-- Combining three years of data in a temporary table
CREATE TEMPORARY TABLE revenue AS (
(SELECT *
FROM (SELECT * FROM hotel_revenue.revenue2018
UNION
SELECT * FROM hotel_revenue.revenue2019
UNION
SELECT * FROM hotel_revenue.revenue2020) reservation
LEFT JOIN hotel_revenue.market_discount
ON reservation.market_segment = market_discount.segment
LEFT JOIN hotel_revenue.meal_cost
ON reservation.meal = meal_cost.meal_type));

-- Revenue by year
SELECT arrival_date_year, ROUND(SUM(((stays_in_weekend_nights + stays_in_week_nights) * (adr - adr*Discount)) + ((adults + children)*cost)), 2) AS revenue
FROM hotel_revenue.revenue
WHERE is_canceled != 1
GROUP BY arrival_date_year;

-- Revenue by hotel
SELECT hotel, arrival_date_year, ROUND(SUM(((stays_in_weekend_nights + stays_in_week_nights) * (adr - adr*Discount)) + ((adults + children)*cost)), 2) AS revenue
FROM hotel_revenue.revenue
WHERE is_canceled != 1
GROUP BY hotel, arrival_date_year
ORDER BY hotel;

-- Parking Spaces Occupied each month
SELECT arrival_date_year AS year, arrival_date_month AS month, SUM(required_car_parking_spaces) AS parking_spaces
FROM hotel_revenue.revenue
WHERE is_canceled != 1
GROUP BY arrival_date_month, arrival_date_year;

-- Cancellation Percentage
SELECT hotel, ROUND((COUNT(is_canceled)/100748)*100, 2) AS 'cancellation_percent'
FROM hotel_revenue.revenue
WHERE is_canceled = 1
GROUP BY is_canceled, hotel;

SELECT hotel, arrival_date_year, ROUND((COUNT(is_canceled)/100748)*100, 2) AS 'cancellation_percent'
FROM hotel_revenue.revenue
WHERE is_canceled = 1
GROUP BY is_canceled, hotel, arrival_date_year
ORDER BY hotel;