-- Total Passangers/Tickets

SELECT 
	COUNT(Transaction_ID) total_passagers 
FROM railway;

-- Total Revenue

SELECT 
	SUM(Price) total_revenue
FROM railway;

-- Average Ticket Price

SELECT 
	CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	CAST(COUNT(Transaction_ID) AS DECIMAL(7,2)) AS DECIMAL(7,2)) Avg_tckt_price
FROM railway

-- Average Delay Time

SELECT 
	CAST(AVG(CAST(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) AS DECIMAL(5,2))) AS DECIMAL(5,2)) Avg_Delay_Time 
FROM railway
WHERE Journey_Status = 'Delayed';

--On Time Percentage

SELECT 
	CAST(CAST(COUNT(*) AS DECIMAL(7,2))/ 
	(SELECT CAST(COUNT(*) AS DECIMAL(7,2)) FROM railway) * 100 AS DECIMAL(5,2)) on_time_trips_percentage
FROM railway
WHERE Journey_Status = 'On Time';


-- Reasons for delay
SELECT 
	Reason_for_Delay,
	COUNT(*) total_trips 
FROM railway
WHERE Reason_for_Delay IS NOT NULL
GROUP BY Reason_for_Delay
ORDER BY total_trips DESC;

--Frequency of Delays by Departure Station
SELECT	
	Departure_Station,
	COUNT(*) total_trips
FROM railway
WHERE Reason_for_Delay IS NOT NULL
GROUP BY Departure_Station
ORDER BY total_trips DESC;


-- Total Passengers by Day
SELECT 
	DATEPART(WEEKDAY, Date_of_Journey) day_no,
	DATENAME(WEEKDAY, Date_of_Journey) day_name,
	COUNT(*) total_passagers
FROM railway
GROUP BY DATEPART(WEEKDAY, Date_of_Journey), DATENAME(WEEKDAY, Date_of_Journey)
ORDER BY day_no


-- Overoll Journey Status
SELECT 
	Journey_Status,
	COUNT(*) status_trips,
	CONCAT(CAST(CAST(COUNT(*) AS DECIMAL(7,2)) / 
	SUM(CAST(COUNT(*) AS DECIMAL(7,2))) OVER () * 100 AS DECIMAL(7,2)), '%') journey_status_percentage
FROM railway
GROUP BY Journey_Status;

-- Total Refund Requests by Reason of Delay
SELECT
	Reason_for_Delay,
	COUNT(*) refund_requests
FROM railway 
WHERE Refund_Request = 1
GROUP BY Reason_for_Delay
ORDER BY refund_requests DESC

-- Revenue by Date of Purchase

SELECT 
	Date_of_Purchase,
	SUM(Price) revenue
FROM railway
GROUP BY Date_of_Purchase
ORDER BY Date_of_Purchase

-- Revenue by Ticket Type

SELECT 
	Ticket_Type, 
	SUM(Price) revenue,
	CONCAT(CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	SUM(SUM(CAST(Price AS DECIMAL(7,2)))) OVER () * 100 AS DECIMAL(7,2)), '%') revenue_percentage
FROM railway
GROUP BY Ticket_Type
ORDER BY revenue DESC


-- Revenue by Ticket Class

SELECT 
	Ticket_Class,
	SUM(Price) class_revenue,
	CONCAT(CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	SUM(SUM(CAST(Price AS DECIMAL(7,2)))) OVER() * 100 AS DECIMAL(7,2)), '%') revenue_tckt_class_percentage
FROM railway
GROUP BY Ticket_Class
ORDER BY class_revenue DESC;

-- Revenue by Purchase Type
SELECT 
	Purchase_Type,
	SUM(Price) revenue,
	CONCAT(CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	SUM(SUM(CAST(Price AS DECIMAL(7,2)))) OVER() * 100 AS DECIMAL(7,2)), '%') revenue_purchase_type_percentage
FROM railway
GROUP BY Purchase_Type;


-- Top Five Popular Routes
SELECT TOP 5
	CONCAT(Departure_Station, ' - ', Arrival_Destination) route,
	COUNT (DISTINCT Transaction_ID) total_passangers
FROM railway
GROUP BY CONCAT(Departure_Station, ' - ', Arrival_Destination)
ORDER BY total_passangers DESC


-- Peak Travel Times
SELECT
	DATEPART(HOUR, Departure_Time) travel_hour,
	COUNT(*) total_passagers
FROM railway
GROUP BY DATEPART(HOUR, Departure_Time)
ORDER BY DATEPART(HOUR, Departure_Time)

-- Revenue by Payment Menthod
SELECT 
	Payment_Method,
	SUM(Price) revenue,
	CONCAT(CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	SUM(SUM(CAST(Price AS DECIMAL(7,2)))) OVER() * 100 AS DECIMAL(7,2)), '%') revenue_payment_method_percentage
FROM railway
GROUP BY Payment_Method
ORDER BY revenue DESC

-- Railcard Users
SELECT 
	Railcard,
	COUNT(DISTINCT Transaction_ID) users
FROM railway
GROUP BY Railcard