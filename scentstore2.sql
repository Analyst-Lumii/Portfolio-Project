--Data being analysed is between February 26-02-2023 to March 28-03-2023 






--Numbers to Note
select distinct (
select count (distinct Query)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' ) as Indexed_Keywords,
(select sum (Clicks)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' and Query NOT LIKE '%xxx%') as Total_Clicks,
(select count (distinct Query)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' and Position <= 10 AND Query NOT LIKE '%xxx%') as First_Page,
(select count (distinct Query)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' and Position between 11 and 20 AND Query NOT LIKE '%xxx%') as Second_Page,
(select count (distinct Query)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' and Position between 21 and 30 AND Query NOT LIKE '%xxx%') as Third_Page,
(select count (distinct Query)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' and Position >= 31 AND Query NOT LIKE '%xxx%') as Fourth_Page
from [TheScentStore].[dbo].[ScentStore]


--Showing the amount of traffic in clicks generated to the website
SELECT DISTINCT (
select count (distinct Query)
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' ) as Indexed_Keywords,
  (SELECT SUM(Clicks) 
   FROM [TheScentStore].[dbo].[ScentStore] 
   WHERE Country = 'nga' AND Query NOT LIKE '%xxx%') AS Total_Clicks,
  
  (SELECT SUM(Clicks) 
   FROM [TheScentStore].[dbo].[ScentStore] 
   WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position BETWEEN 1 AND 3) AS one_to_three_First_page_clicks,
  
  (SELECT SUM(Clicks) 
   FROM [TheScentStore].[dbo].[ScentStore] 
   WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position BETWEEN 4 AND 10) AS four_to_ten_First_page_clicks,
  
  (SELECT SUM(Clicks) 
   FROM [TheScentStore].[dbo].[ScentStore] 
   WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position BETWEEN 11 AND 20) AS second_page_clicks,
  
  (SELECT SUM(Clicks) 
   FROM [TheScentStore].[dbo].[ScentStore] 
   WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position BETWEEN 21 AND 30) AS third_page_clicks,
  
  (SELECT SUM(Clicks) 
   FROM [TheScentStore].[dbo].[ScentStore] 
   WHERE Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position >= 31) AS fourth_page_downward_clicks
  
FROM [TheScentStore].[dbo].[ScentStore];


--Top 20 keyords ranking between 1-3 on Google's first page with the highest traffic
SELECT TOP 20
  Query, Position , SUM(Clicks) AS Total_Clicks 
FROM 
  [TheScentStore].[dbo].[ScentStore]
WHERE 
  Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position BETWEEN 1 AND 3
GROUP BY 
  Query, Position
ORDER BY 
  SUM(Clicks) DESC


  --Top 20 keyords ranking between 4-10 on Google's first page with the highest traffic
SELECT TOP 20
  Query, Position , SUM(Clicks) AS Total_Clicks 
FROM 
  [TheScentStore].[dbo].[ScentStore]
WHERE 
  Country = 'nga' AND Query NOT LIKE '%xxx%' AND Position BETWEEN 4 AND 10
GROUP BY 
  Query, Position
ORDER BY 
  SUM(Clicks) DESC



--Trend of keywords for the timeframe
select Query, Date, sum(Clicks) as Total_Clicks , sum(Impressions) as Total_Impressions
from [TheScentStore].[dbo].[ScentStore]
WHERE Country = 'nga' AND Query NOT LIKE '%xxx%'
group by Query, Date




