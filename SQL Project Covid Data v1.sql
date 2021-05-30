select * from CovidDeaths;


select * from CovidVaccinations
order by 3;


-- daily info per country
select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent is not null  --used to eliminate continent groupings and world grouping
order by 1,2;

-- total cases vs. total deaths
-- shows likelihood of dying if you contract covid in slovenia

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as CaseMortality
from CovidDeaths
where continent is not null
--where location like '%love%'	--narrow on location
order by 2 desc;

-- total cases vs. entire population
-- shows percentage of of confirmed cases so far within the entire population
select location, continent, date, population, total_cases, (total_cases/population)*100 as PopulationInfectionRate
from CovidDeaths
where continent is not null
and location like '%mex%'	--narrow on location
order by 5 desc;


-- max total cases vs population
-- shows countries with highest infection rate and highest absolute numbersr
select location, population, max(total_cases) as HighestInfection, max((total_cases/population))*100 as HighestInfectionRate
from CovidDeaths
--where location like '%love%'	--narrow on location
where continent is not null
group by population, location
order by 4 desc;

-- countries with highest death rate per capita

select location, population, max(total_deaths) as Total_Deaths, max((total_deaths/population))*100 as HighestDeathRate
from CovidDeaths
--where location like '%love%'	--narrow on location
where continent is not null
group by population, location
order by 3 desc;

-- continents with highest death rate

select location, population, max(total_deaths) as Total_Deaths, max((total_deaths/population))*100 as HighestDeathRate
from CovidDeaths
--where location like '%love%'	--narrow on location
where continent is null
group by population, location
order by 3 desc;

-- highest death rate in single country on continent
select continent, max(total_deaths) as Total_deaths
from CovidDeaths
--where location like '%love%'	--narrow on location
where continent is not null
group by continent
order by 2 desc;


--new cases and deaths globally per day

select date, sum(new_cases) as TotalInfections, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as CaseMortality
from CovidDeaths
where continent is not null
--- location like '%love%'	--narrow on location
group by date
order by 1 desc;


-- sum of all cases and deaths globally

select sum(new_cases) as TotalInfections, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as CaseMortality
from CovidDeaths
where continent is not null
--- location like '%love%'	--narrow on location
order by 1 desc;


---Vaccination table inspection

select * 
from CovidVaccinations 


--joining deaths and vaccination table, daily vaccinations on country level


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3 desc;



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) 
OVER (partition by dea.location order by dea.location, dea.date ) as RollingNumberVaccinated
--,(RollingNumberVaccinated/dea.population)*100
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3 desc;


-- CTE for daily new vaccinations and rolling daily vaccinations

with PopVsVac(continent, location, date, population, new_vaccinations, rollingnumbervaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) 
OVER (partition by dea.location order by dea.location, dea.date ) as RollingNumberVaccinated
--,(RollingNumberVaccinated/dea.population)*100
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3 desc
)
select *, (RollingNumberVaccinated/population)*100 as PercentageVaccinated
from PopVsVac
order by 7 desc;




--Temp table version of above

create table #PercentPopulationVaccinated

(continent nvarchar(50), 
location nvarchar(50),
date datetime,
population float, 
new_vaccinations float,
RollingNumberVaccinated float)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) 
OVER (partition by dea.location order by dea.location, dea.date ) as RollingNumberVaccinated
--,(RollingNumberVaccinated/dea.population)*100
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 


select *, (RollingNumberVaccinated/population)*100 as PercentageVaccinated
from #PercentPopulationVaccinated
order by 7 desc;

-- View for latter visualization

create view PercentPopulationVaccinated
as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) 
OVER (partition by dea.location order by dea.location, dea.date ) as RollingNumberVaccinated
--,(RollingNumberVaccinated/dea.population)*100
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null; 
--order by 2,3 desc


select * 
from PercentPopulationVaccinated;