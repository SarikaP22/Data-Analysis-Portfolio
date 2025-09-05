-- Objective 2: Compare popularity across decades
-- To find the top 3 girl names and top 3 boy names for each year, 
--and also for each decade.


--For each year, return the 3 most popular girl names and 3 most popular boy names
with pop_pattern as(
  select name, gender, year, sum(births) as sum_births
  from names_data
  group by name, gender, year
)
select * from (
select name, gender, year, sum_births,
rank() over(partition by year, gender order by sum_births desc) as pop_rnk_each_year
from pop_pattern)
where pop_rnk_each_year <= 3

  
--For each decade, return the 3 most popular girl names and 3 most popular boy names
with pop_pattern as(
  select name, gender, concat(substring(year, 3, 1),'0''s') as Decade,
  sum(births) as sum_births
  from names_data
  group by name, gender, decade
)
select * from (
  select name, gender, decade, sum_births,
  rank() over(partition by decade, gender order by sum_births desc) as pop_rnk_each_deacde
  from pop_pattern)
where pop_rnk_each_deacde <= 3
