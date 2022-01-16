-- **WHOLE SHEETS**

-- Importing Deaths Sheet
Select *
From PortfolioProject . .[Covid Deaths]
Order by 3, 4

-- Importing Vaccinations Sheet
Select *
From PortfolioProject . .[Covid Vaccinations]
Order by 3, 4

-- Better sort for Deaths Sheet
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject . .[Covid Deaths]
Order by 1, 2

-- Both Joined
Select*
From PortfolioProject . .[Covid Deaths] dea
Join PortfolioProject . .[Covid Vaccinations] vac
ON dea.location = vac.location AND dea.date = vac.date

-- **CREATE VIEW**
Create View USInfectionHistory as
Select location, population, date, total_cases, (total_cases/population)*100 as PercentageInfected
From PortfolioProject . .[Covid Deaths]
where location like '%states%'

Select *
From USInfectionHistory

Create View USDeathsPerPopulation as
Select location, population, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX((total_deaths/population))*100 as PercentageDead
From PortfolioProject . .[Covid Deaths]
where location like '%states%'
Group by location, population

-- **HISTORIES**

-- Total Cases vs Total Deaths History
-- Show the likelihood of death if you contract COVID by country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject . .[Covid Deaths]
Where continent is not null
Order by 1, 2


-- Total Cases vs Population History
-- Shows what percentage of population got Covid at any time
Select location, population, date, total_cases, (total_cases/population)*100 as PercentageInfected
From PortfolioProject . .[Covid Deaths]
Where continent is not null
Order by 1, 3

--Vaccination by Population History
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject . .[Covid Deaths] dea
Join PortfolioProject . .[Covid Vaccinations] vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- **NATIONAL**

--Highest Infection Rate per Population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentageInfected
From PortfolioProject . .[Covid Deaths]
Where continent is not null
Group by location, population
Order by PercentageInfected desc

-- Most Deaths per Population
Select location, population, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX((total_deaths/population))*100 as PercentageDead
From PortfolioProject . .[Covid Deaths]
Where continent is not null
Group by location, population
Order by PercentageDead desc

-- Rolling Vaccination by Population (Issue wherein vaccines eventually exceed population due to the fact people get multiple shots and "new vaccinations" is tally of all shots that day. 
-- However, query does succeed in intended use by getting rolling vaccine total and a percentage of pop provided.) 
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject . .[Covid Deaths] dea
Join PortfolioProject . .[Covid Vaccinations] vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population)*100 as PercentVaccinated
From PopvsVac
Order by Location, Date

-- **CONTINENTS**

--Most Deaths per Pop. by Continent 
Select location, MAX(CONVERT(int,total_deaths)) as TotalDeathCount, MAX((total_deaths/population))*100 as PercentageDead
From PortfolioProject . .[Covid Deaths]
Where location not like '%income' AND location not like '%Union' AND location not like 'International' AND continent is null
Group by location
Order by PercentageDead desc

-- **GLOBAL**

--Deaths per Infection Percentage
Select location, MAX(total_cases) as totalcases, MAX(cast(total_deaths as int)) as totaldeaths,  MAX(cast(total_deaths as int))/ MAX(total_cases)*100 as deathpercentage
From PortfolioProject . .[Covid Deaths]
Where location like 'World'
Group by location
Order by 1, 2


-- **INCOME**

--Most Deaths by Income (Most likely affected by worldwide gap in ability to get diagnosed between high income and low income people)
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX((total_deaths/population))*100 as PercentageDead
From PortfolioProject . .[Covid Deaths]
Where location like '%income' AND continent is null
Group by location
Order by PercentageDead desc