-- Delays by Departure Station

SELECT 
	Departure_Station,
	COUNT(Transaction_ID) no_of_delays
FROM railway
WHERE Reason_for_Delay IS NOT NULL
GROUP BY Departure_Station
ORDER BY no_of_delays DESC;

-- Refunded Amount

SELECT 
	SUM(Price) refunded_amount 
FROM railway 
WHERE Refund_Request = 1;

-- Refundable Amount
SELECT 
	SUM(Price) refundable_amount 
FROM railway
WHERE Journey_Status IN ('Delayed', 'Cancelled');

-- % for those who apply for refund

SELECT 
	CONCAT(CAST(CAST(COUNT(Transaction_ID) AS DECIMAL(7,2)) / 
		(SELECT CAST(COUNT(Transaction_ID) AS DECIMAL(7,2)) FROM railway) * 100 AS DECIMAL(5,2)), '%') refund_request_percentage
FROM railway
WHERE Refund_Request = 1;

-- Routes
SELECT 
	COUNT(DISTINCT CONCAT(Departure_Station, ' to ', Arrival_Destination)) total_routes
FROM railway;

SELECT 
	DISTINCT CONCAT(Departure_Station, ' to ', Arrival_Destination) routes
FROM railway;


-- Total Delays/Cancellations by Routes
SELECT 
	CONCAT(Departure_Station, ' to ', Arrival_Destination) route,
	COUNT(CONCAT(Departure_Station, ' to ', Arrival_Destination)) 'total delays/cancellation'
FROM railway
WHERE Journey_Status IN('Delayed', 'Cancelled')
GROUP BY CONCAT(Departure_Station, ' to ', Arrival_Destination)
ORDER BY [total delays/cancellation] DESC;

SELECT 
	SUM(a.total_delays) delays_and_cancellation
FROM
(SELECT 
	CONCAT(Departure_Station, ' to ', Arrival_Destination) route,
	COUNT(CONCAT(Departure_Station, ' to ', Arrival_Destination)) total_delays
FROM railway
WHERE Journey_Status IN('Delayed', 'Cancelled')
GROUP BY CONCAT(Departure_Station, ' to ', Arrival_Destination)) a

-- Longest Trips 
SELECT TOP 10
	CONCAT(Departure_Station, ' to ', Arrival_Destination) route,
	AVG(DATEDIFF(HOUR, Departure_Time, Actual_Arrival_Time)) 'avg_trip_duration(Hrs)'
FROM railway
GROUP BY CONCAT(Departure_Station, ' to ', Arrival_Destination)
ORDER BY [avg_trip_duration(Hrs)] DESC;