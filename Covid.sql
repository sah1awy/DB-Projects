-- Creating Our Database

create database PortfolioProject
go

use PortfolioProject
go

select * from CovidDeaths

-- Selecting the Data that we are going to use

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by location,date

-- Total Cases VS Total Deaths
select location,date,total_cases,total_deaths,round((total_deaths / total_cases)*100,2) as "Cummulative Death Percentage Overtime"
from CovidDeaths
order by location,date

-- Percentage in Egypt
select location,date,total_cases,total_deaths,round((total_deaths / total_cases)*100,2) as "Cummulative Death Percentage Overtime"
from CovidDeaths
where location = 'egypt'
order by location,date;

-- Percentage of Population got Covid
select location,date,population,total_cases,round((total_cases / population)*100,2) as "Covid Percentage"
from CovidDeaths
where location = 'egypt'
order by location,date;

-- Highest Infected Cities 
select location,population ,max(total_cases) as "Highest Count",max(round((total_cases / population)*100,2)) as "Population Infected Percentage"
from CovidDeaths
group by location,population
order by "Population Infected Percentage" desc;

 
select location,population ,max(total_cases) as "Highest Count",max(round((total_cases / population)*100,2)) as "Population Infected Percentage"
from CovidDeaths
where location = 'egypt'
group by location,population;

-- Highest Death rate locations 
select location ,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null 
group by location
order by TotalDeathCount desc; 

-- Death rate Count by Continent
select location ,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null 
group by location
order by TotalDeathCount desc; 

-- Global Numbers Per day
select date,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths ,round(sum(cast(new_deaths as int)) / sum(new_cases) * 100,2)
from CovidDeaths
where continent is not null 
group by date
order by date;


select * from CovidVaccinations

-- Total Population VS new Vaccinations

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollinPeopleVaccinated
 from CovidDeaths dea join CovidVaccinations vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null 
 order by  2,3


 -- CTE  
 with PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
 as
 (
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollinPeopleVaccinated
 from CovidDeaths dea join CovidVaccinations vac
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent is not null 
 -- order by  2,3
 )select * , (RollingPeopleVaccinated / Population) * 100 as Perc
 from PopvsVac
























