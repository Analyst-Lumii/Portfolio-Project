
select * from ['Covid death$']
where continent is not null
order by 3, 4

select * from ['covid vaccinations$']
order by 3, 4

--selecting the data i want to work with

select location, date, total_cases, new_cases, total_deaths, population
from ['Covid death$']
where continent is not null
order by 1,2

--Looking at death percentage Total cases vs Total deaths 
--It shows the likelihood of someone dieing from covid in my country

select location, date, total_cases, total_deaths, round((CAST(total_deaths AS float) / CAST(total_cases AS float))*100, 2) AS Death_Percentage
from ['Covid death$']
where location = 'Nigeria' and continent is not null
order by 1,2

--Looking at Total cases vs Population 
--This shows the percentage of the population in my country who has covid at certain times

select location, date, total_cases, population, round((CAST(total_cases AS float) / population)*100,2) AS Population_Percentage_with_Covid
from ['Covid death$']
where location = 'Nigeria' and continent is not null
order by 1,2


----Looking at countries with highest infection rate compared to their population

select location, sum(new_cases) as Total_Cases, population, 
(round(sum(cast(new_cases as int) / population*100),2)) AS Population_Percentage_with_Covid
from ['Covid death$']
where continent is not null
group by location, population
order by Population_Percentage_with_Covid desc

--Show countries with highest death count per population
--The numbers of these total death count per country is accurate as at when I pulled the data from https://ourworldindata.org/covid-deaths on 25/03/2023

select location, max(cast(total_deaths as int)) as Total_Death_Count
from ['Covid death$']
where continent is not null
group by location, population
order by Total_Death_Count desc

-- I want to break the Total death count down by Continents

select continent, max(cast(total_deaths as int)) as Total_Death_Count
from ['Covid death$']
where continent is not null
group by continent
order by Total_Death_Count desc

-- Gobal Numbers

select sum(new_cases) as World_Total_Cases, sum(cast(new_deaths as int)) as World_Total_Deaths,
sum(NULLIF(cast(new_deaths as int), 0)) / NULLIF(sum(NULLIF(new_cases, 0)), 0) * 100 AS World_Death_Percentage
from ['Covid death$']
--where continent is not null
order by 1,2

--Looking at total population vs vaccination

with Pop_vs_Vac (continent, location, date, population, new_vaccinations,Rolling_People_Vacinated)as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vacinated
from ['Covid death$'] dea
join ['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null)
select *, round((Rolling_People_Vacinated/population)*100,2) as Perc_of_Vaci_Population
from Pop_vs_Vac
order by 1,2,3


--Creating a temproray table

drop table if exists Percent_of_Vacinated_Population
create table Percent_of_Vacinated_Population
(
Continent nvarchar(255),
Location nvarchar(255), 
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_People_Vacinated numeric
)

Insert into Percent_of_Vacinated_Population
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vacinated
from ['Covid death$'] dea
join ['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
select *, round((Rolling_People_Vacinated/population)*100,2) as Perc_of_Vaci_Population
from Percent_of_Vacinated_Population



--creating views for later visualisation

create view Percentage_of_Vacinated_Population as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vacinated
from ['Covid death$'] dea
join ['covid vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

create view Global_Numbers as
select sum(new_cases) as World_Total_Cases, sum(cast(new_deaths as int)) as World_Total_Deaths,
sum(NULLIF(cast(new_deaths as int), 0)) / NULLIF(sum(NULLIF(new_cases, 0)), 0) * 100 AS World_Death_Percentage
from ['Covid death$']
--where continent is not null
--order by 1,2

create view Total_Death_Count_By_Continent as
select continent, max(cast(total_deaths as int)) as Total_Death_Count
from ['Covid death$']
where continent is not null
group by continent
--order by Total_Death_Count desc

create view Death_Count_by_Country as
select location, max(cast(total_deaths as int)) as Total_Death_Count
from ['Covid death$']
where continent is not null
group by location, population
--order by Total_Death_Count desc

create view Highest_Infection_Rate_With_Population as
select location, sum(new_cases) as Total_Cases, population, 
(round(sum(cast(new_cases as int) / population*100),2)) AS Population_Percentage_with_Covid
from ['Covid death$']
where continent is not null
group by location, population
--order by Population_Percentage_with_Covid desc

create view Nigeria_Infection_Rate_Trend as
select location, date, total_cases, population, round((CAST(total_cases AS float) / population)*100,2) AS Population_Percentage_with_Covid
from ['Covid death$']
where location = 'Nigeria' and continent is not null
--order by 1,2

create view Nigeria_Death_Percentage_Rate as
select location, date, total_cases, total_deaths, round((CAST(total_deaths AS float) / CAST(total_cases AS float))*100, 2) AS Death_Percentage
from ['Covid death$']
where location = 'Nigeria' and continent is not null
--order by 1,2