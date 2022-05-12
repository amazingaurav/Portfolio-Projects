use portfolioproject;
select * from CovidDeaths
order by 3,4;

--select * from CovidVaccinations
--order by 3,4;


select location,date,total_cases, new_cases,total_deaths, population from CovidDeaths
order by 1,2;

--looking at total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage from CovidDeaths
where location like '%india'
order by 1,2;

-- looking at total cases vs percentage

select location,date,population,total_cases,(total_cases/population)*100 as PercentagePopulationInfected  from CovidDeaths
where location like '%states'
order by 1,2;

-- looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases/population)*100) as PercentagePopulationInfected from CovidDeaths
group by location,population
order by PercentagePopulationInfected desc;

select * from CovidDeaths
where continent is not null
order by 3,4

-- showing the countries with highest death count per population

select location,max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- break things down by continent

select continent,max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- showing the continent with highest death count

select continent ,max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
where continent is not null
group by continent 
order by TotalDeathCount desc;


select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
--group by date
order by 1,2;

-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated,
from CovidDeaths dea
join CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


--using CTE

with PopvsVac ( continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 from PopvsVac;




-- temp table
drop table if exists PercentPopVaccinated
create table PercentPopVaccinated
( continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into PercentPopVaccinated
select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100 from PercentPopVaccinated;

--creating view to store data for later visualizations

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated






