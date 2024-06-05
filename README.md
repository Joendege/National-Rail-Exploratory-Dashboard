# National-Rail-Exploratory-Dashboard


## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Recommedations](#recommedations)
- [Results and Findings](#results-and-findings)
- [References](#references)

### Project Overview
In this project, I used Power BI to provide insights for a company providing train passenger services and operates in England, Scotland and Wales. I have been tasked to create a exploratory dashboard that will help with the following information:
- Indentify most popular routes.
- Determine peak travel times.
- Analyze revenue from different ticket types and classes.
- Diagnose on time performance and contributing factors


![home](https://github.com/Joendege/National-Rail-Exploratory-Dashboard/assets/123901910/a390470c-a31a-4ea1-bd93-3a1fe56248fb)

![tickets](https://github.com/Joendege/National-Rail-Exploratory-Dashboard/assets/123901910/8c7ba6f4-64af-4a33-943c-e6d10d9d1402)

![routes](https://github.com/Joendege/National-Rail-Exploratory-Dashboard/assets/123901910/07596ece-5850-4ac7-bc12-46fab35b7b76)


### Data Sources
The primary data source for this project "railway.csv" file containing a detailed information of all tickets sold, type, class and journey details indicating time depature station and journey status.

### Tools
1. MS SQL Server - Data Analysis [Download Here](https://www.microsoft.com)
2. Power BI - Report Creating [Download Here](https://www.microsoft.com)


### Exploratory Data Analysis
EDA involved exploring the railway data to answer keys questions as:
- What are the most popular routes?
- What are the peak travel time?
- How is revenue by ticket types and class?
- What are the contributing factors to on time performance?

### Data Analysis
``` SQL
-- Total Passengers by Day
SELECT 
	DATEPART(WEEKDAY, Date_of_Journey) day_no,
	DATENAME(WEEKDAY, Date_of_Journey) day_name,
	COUNT(*) total_passagers
FROM railway
GROUP BY DATEPART(WEEKDAY, Date_of_Journey), DATENAME(WEEKDAY, Date_of_Journey)
ORDER BY day_no;
```
``` SQL
-- Revenue by Ticket Class

SELECT 
	Ticket_Class,
	SUM(Price) class_revenue,
	CONCAT(CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	SUM(SUM(CAST(Price AS DECIMAL(7,2)))) OVER() * 100 AS DECIMAL(7,2)), '%') revenue_tckt_class_percentage
FROM railway
GROUP BY Ticket_Class
ORDER BY class_revenue DESC;
```
``` SQL
-- Revenue by Purchase Type
SELECT 
	Purchase_Type,
	SUM(Price) revenue,
	CONCAT(CAST(SUM(CAST(Price AS DECIMAL(7,2))) / 
	SUM(SUM(CAST(Price AS DECIMAL(7,2)))) OVER() * 100 AS DECIMAL(7,2)), '%') revenue_purchase_type_percentage
FROM railway
GROUP BY Purchase_Type;
```
``` SQL
-- Top Five Popular Routes
SELECT TOP 5
	CONCAT(Departure_Station, ' - ', Arrival_Destination) route,
	COUNT (DISTINCT Transaction_ID) total_passangers
FROM railway
GROUP BY CONCAT(Departure_Station, ' - ', Arrival_Destination)
ORDER BY total_passangers DESC
```
``` SQL

-- Peak Travel Times
SELECT
	DATEPART(HOUR, Departure_Time) travel_hour,
	COUNT(*) total_passagers
FROM railway
GROUP BY DATEPART(HOUR, Departure_Time)
ORDER BY DATEPART(HOUR, Departure_Time)
```
``` SQL
--On Time Percentage

SELECT 
	CAST(CAST(COUNT(*) AS DECIMAL(7,2))/ 
	(SELECT CAST(COUNT(*) AS DECIMAL(7,2)) FROM railway) * 100 AS DECIMAL(5,2)) on_time_trips_percentage
FROM railway
WHERE Journey_Status = 'On Time';
```
``` SQL
-- Reasons for delay
SELECT 
	Reason_for_Delay,
	COUNT(*) total_trips 
FROM railway
WHERE Reason_for_Delay IS NOT NULL
GROUP BY Reason_for_Delay
ORDER BY total_trips DESC;
```

### Recommedations
Based on the analysis we recommed the following actions:
1. The company must increase the sales of "First Class" or "Advance Tickets" in order to generate more revenue.
2. For routes with high number of passengers the company must add more carriages to cater for the increase in passenger density.
3. The company must improve the current system and keep downtime to minimum, and also hire more operational staff to improve passenger services.

### Results and Findings
- The most popular route is Manchester Piccadilly to Liverpool Lime Street with over 46K purchases and 4338 sucessful journeys, although the average delay time is 67 minutes.
- The peak hours are morning between 6AM to 8AM and evening from 4PM and 6PM, is likely the hours passengers are reporting to work and leaving work for home.
- Standard tickets contributed to higher revenue compared to First Class tickets and based on ticket type Advanced tickets contributed 42% and Anytime and Off Peak 28% and 30% respectively.
- Weather and Weather conditions causes majority of passenger delays which is 33% the rest are are related to company opertions which is 67% percent for instance technical issue, signal failure etc. 


### References
1. [Stack Overflow](https://www.stackoverflow.com)
2. [Power BI Documentation](https://www.microsoft.com)
