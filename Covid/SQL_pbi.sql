DROP VIEW IF EXISTS PBI_VIEW1;

CREATE VIEW PBI_VIEW1 AS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covid_deaths
WHERE LOCATION NOT IN ('World','International') AND CONTINENT IS NOT NULL
ORDER BY 1,2;

DROP VIEW IF EXISTS PBI_VIEW2;

CREATE VIEW PBI_VIEW2 AS 
SELECT LOCATION, POPULATION, SUM(CAST(NEW_DEATHS AS INT)) AS TOTALDEATHCOUNT
FROM covid_deaths
WHERE CONTINENT IS NULL AND LOCATION NOT IN ('World','International','European Union')
GROUP BY location
ORDER BY TOTALDEATHCOUNT DESC;

DROP VIEW IF EXISTS PBI_VIEW3;

CREATE VIEW PBI_VIEW3 AS
Select Location, Continent, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected, MAX(total_deaths) as HighestDeathCount,  Max((total_deaths/population))*100 as PercentPopulationDead
From covid_deaths
WHERE LOCATION NOT IN ('World','International') AND CONTINENT IS NOT NULL
Group by Location
order by PercentPopulationInfected desc;

DROP VIEW IF EXISTS PBI_VIEW4;
CREATE VIEW PBI_VIEW4 AS
Select Location, CONTINENT, Population,date, new_cases,new_deaths, MAX(total_cases) as HighestInfectionCount, MAX(total_deaths) as HighestDeathCount, Max((total_cases/population))*100 as PercentPopulationInfected, (MAX(total_deaths)/MAX(total_cases)) as Letality
From covid_deaths
--Where location like '%states%'
WHERE LOCATION NOT IN ('World','International') AND CONTINENT IS NOT NULL
Group by Location, date
order by PercentPopulationInfected desc;

DROP VIEW IF EXISTS PBI_VIEW5;
CREATE VIEW PBI_VIEW5 AS
SELECT LOCATION, CONTINENT, DATE, MAX(NEW_CASES) AS MAX_CASES
FROM covid_deaths
WHERE (LOCATION NOT IN ('International') AND CONTINENT IS NOT NULL) OR LOCATION='World'
Group by Location
ORDER BY MAX_CASES DESC;

DROP VIEW IF EXISTS PBI_VIEW6;
CREATE VIEW PBI_VIEW6 AS
SELECT LOCATION, CONTINENT, DATE, MAX(NEW_DEATHS) AS MAX_DEATHS
FROM covid_deaths
WHERE (LOCATION NOT IN ('International') AND CONTINENT IS NOT NULL) OR LOCATION='World'
Group by Location
ORDER BY MAX_DEATHS DESC;

DROP VIEW IF EXISTS PBI_VIEW7;
CREATE VIEW PBI_VIEW7 AS
SELECT V5.LOCATION, V5.CONTINENT, V5.DATE AS CASE_DATE, V6.DATE AS DEATHS_DATE, V5.MAX_CASES, V6.MAX_DEATHS
FROM PBI_VIEW5 V5
JOIN PBI_VIEW6 V6
    ON V5.LOCATION = V6.LOCATION;
	
DROP VIEW IF EXISTS PBI_VIEW8;
CREATE VIEW PBI_VIEW8 AS
SELECT DATE,LOCATION, SUM(new_cases) AS TOT_NEW_CASES, SUM(NEW_DEATHS) AS TOT_NEW_DEATHS
FROM covid_deaths
WHERE LOCATION NOT IN ('World','International') AND CONTINENT IS NOT NULL
Group by DATE,LOCATION
ORDER BY TOT_NEW_CASES DESC;

DROP VIEW IF EXISTS PBI_VIEW9;
CREATE VIEW PBI_VIEW9 AS
SELECT DATE,SUM(HighestInfectionCount) AS HighestInfectionCount, SUM(HighestDeathCount) AS HighestDeathCount
FROM PBI_VIEW4
Group by DATE
ORDER BY DATE DESC;