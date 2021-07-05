
-- columns required

select location, date, population, total_cases, new_cases, total_deaths 
from covid_death
order by 1,2

-- total deaths VS total cases
--lilelihood of dying

select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage 
from covid_death
where location like '%states%'
order by date

-- total cases VS polulation
--total polpulation got infected by covid

select location,population, date, total_cases, round((total_cases/population)*100,2) as contagious_percentage 
from covid_death
where location like '%states%'
order by 3,4

--looking at countries with highest infection rate compared to the population

select top 10 location, population, max(total_cases) as highest_infection_count, 
max(round((total_cases/population)*100,2)) as highest_infection_rate 
from covid_death
where population is not null
group by location, population
order by 4 desc

-- showing highest death count per population

select continent, max(cast(total_deaths as int)) as total_death_count
from covid_death 
where continent is not null
group by continent
order by 2 desc

--world totalnumber
select SUM(new_cases) totalcases, SUM(cast(new_deaths as int)) totaldeaths,
round(SUM(cast(new_deaths as int))/ SUM(new_cases),2) as totaldeathpercentage
from COVID_DEATH
where continent is not null
order by 1

--Total people vaccinated vs population
select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
sum(cast(v.new_vaccinations as int)) over (partition by	d.location order by d.location) as rollingpeoplevaccinated
--rollingpeoplevaccinated/d.population ********* since we can not use alias name of column in calculation so creating CTE or temp table
from COVID_DEATH d join COVID_VACCINATION v on d.location=v.location and d.date=v.date
where d.continent is not null
order by 1,3,2



--creating CTE

with popvsvac (continent,location,date,population, new_vaccinations,rollingpeoplevaccinated)
as(
select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
sum(cast(v.new_vaccinations as int)) over (partition by	d.location order by d.location) as rollingpeoplevaccinated
from COVID_DEATH d join COVID_VACCINATION v on d.location=v.location and d.date=v.date
where d.continent is not null
--order by 1,3,2
)
select *, (rollingpeoplevaccinated/population)*100 from popvsvac
order by 1,3

-- creating veiw for later use

create view popvsvac as
select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
sum(cast(v.new_vaccinations as int)) over (partition by	d.location order by d.location) as rollingpeoplevaccinated
from COVID_DEATH d join COVID_VACCINATION v on d.location=v.location and d.date=v.date
where d.continent is not null
--order by 1,3,2

select * from popvsvac
