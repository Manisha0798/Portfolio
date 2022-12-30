use Portfolio

--Checking the columns 
select  continent,location,date,total_cases,new_cases,total_vaccinations,people_vaccinated,people_fully_vaccinated, total_cases from dbo.Covid_vaccinations
where location='India'

--number of people getting vaccinated each day in India
select location,date,max(total_vaccinations) as vaccines, max(cast(people_vaccinated as bigint)) as max_vaccinations_perday 
from dbo.Covid_vaccinations where location='India'
group by location,date
order by location,date
 

--running people getting vaccinated each day in India
select location,date, new_vaccinations,total_vaccinations,people_vaccinated,sum(cast(people_vaccinated as bigint))
 over ( partition by location order by location,date ) as running_people_vaccinated 
from dbo.Covid_vaccinations where location in ('India') and year(date)='2021'
--order by location,date


--people fully vaccinated in each location
select location,max(total_cases) as total_cases ,max(total_vaccinations) as total_vaccines, max(cast(people_vaccinated as bigint)) as total_people_vaccinated 
from dbo.Covid_vaccinations where continent is not null
group by location
order by location

--new cases in each location
select location ,cast(max(total_cases) as bigint) as total_cases, max(population) as population from dbo.Covid_vaccinations
where continent is not null and continent='Asia'
group by location
order by location

--world percentage of vaccination
select max(population) as total_population,max(people_fully_vaccinated) as people_fully_vaccinated, 
(max(people_fully_vaccinated)/max(population))*100 as percentage_of_people_fully_vaccinated
from Covid_vaccinations
where location='World'
group by location

--select top 5 location,date,total_cases,new_cases,* from Covid_vaccinations

--Number of people vaccinated each day in India as running count
select location,date,total_cases,new_cases, sum(cast(total_tests as bigint))  over(partition by location order by location,date)
as running_tests 
from dbo.Covid_vaccinations
where location='India'


---Percentage of vaccination in each country
select location, max(population) as population,-- (sum(cast(total_vaccinations as bigint))/max(population))*100 total_vaccinations_percentage,
(max(cast(people_fully_vaccinated as bigint))/max(population))*100 as full_vaccinations
from Covid_vaccinations
where continent is not null
group by location
order by max(population) desc


---Mortality rate for each location
select vacc.location as location,max(vacc.population) as total_population,(max(hos.total_deaths)/max(hos.total_cases))*100 as mortality_rate,
max(vacc.total_cases) as total_cases
from Covid_vaccinations as vacc
join  covid_Hospitalizations as  hos on
vacc.location=hos.location and vacc.date=hos.date
where hos.continent is not null
group by vacc.location
order by vacc.location

--Mortality rate in  World
select location ,max(population) as total_population,(max(total_deaths)/max(total_cases))*100 as mortality_rate,
max(total_cases) as total_cases
from Covid_vaccinations 
where location='World'
group by location

