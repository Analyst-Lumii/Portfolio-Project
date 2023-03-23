with hotel as (
select * from dbo.[Year 2018]
union 
select * from dbo.[Year 2019]
union 
select * from dbo.[Year 2020])

select * from hotel
left join dbo.market_segment$
on hotel.market_segment = market_segment$.market_segment
left join meal_cost$
on meal_cost$.meal = hotel.meal


-- To analyse if the hotel revenue is growing by yeear the below querry will help

select arrival_date_year, 
hotel, 
round(sum((stays_in_week_nights+stays_in_weekend_nights)* adr),2) as revenue 
from hotel 
group by arrival_date_year, hotel

