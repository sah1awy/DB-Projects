-- Data For Tableau 

select * from CovidDeaths;


-- table Data
select sum(new_cases) as 'Total Cases', sum(cast(new_deaths as int)) as 'Total Deaths',
sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from CovidDeaths
where continent is not null 
order by 1,2;


-- Bar Chart Data
select location as Continent, sum(cast(new_deaths as int)) as DeathCount
from CovidDeaths
where continent is null and location not in ('World','European Union','International')
group by location
order by DeathCount desc;

select * from CovidDeaths

-- Map Data 
select location, population, max(total_cases) as TotalCases, max((total_cases/population))*100 as InfectionPercentage
from CovidDeaths
group by location,population
order by 4 desc;

-- Forecasting Data

select location,population,date,max(total_cases) as HighestInfectionCount, max((total_cases/population)) * 100 as PercentPopulationInfected
from CovidDeaths
group by location,population,date
order by 5 desc;




