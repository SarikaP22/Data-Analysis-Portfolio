-- objective 1
-- Track changes in name popularity
--Your first objective is to see how the most popular names have changed over time, 
--and also to identify the names that have jumped the most in terms of popularity.

-- top 3 most popular boy and girl baby names of all the time
with pop_3_cte as (
  with most_pop as (
    select name, gender, sum(births) as sum_births
    from names_data
    group by  name, gender
  )
  select * from (
    select name, gender, sum_births,
    rank() over (partition by gender order by sum_births desc) as popularity_rnk
    from most_pop
  )
  where popularity_rnk <= 3
),
-- popularity trend over the years
pattern_cte as (
  with pop_pattern as (
    select name, gender, year, sum(births) as sum_births
    from names_data
    group by year, name, gender
  )
  select name, gender, year, sum_births,
  rank() over(partition by year, gender order by sum_births desc) as popularity_rnk
  from pop_pattern
) 
-- how the most popular names have changed over time
SELECT * 
FROM pop_3_cte pop inner JOIN pattern_cte as pat
on pop.name = pat.name and pop.gender = pat.gender


--Find the names with the biggest jumps in popularity from the first year of the data set to the last year
WITH yr_range as (
  select min(year) as first_year, max(year) as last_year
  from names_data),
pop_pattern as (
  select name, gender, year, sum(births) as sum_births
  from names_data
  group by year, name, gender
),
pattern_first_year as (
  select name, gender, year, sum_births,
  rank() over(partition by gender order by sum_births desc) as popularity_rnk
  from pop_pattern, yr_range
  where year = yr_range.first_year
),
pattern_last_year as (
  select name, gender, year, sum_births,
  rank() over(partition by gender order by sum_births desc) as popularity_rnk
  from pop_pattern, yr_range
  where year = yr_range.last_year)
select * from (
  select first.name, first.gender, first.popularity_rnk, last.popularity_rnk,
  rank() over(partition by first.gender order by first.popularity_rnk - last.popularity_rnk desc) as pop_jump
  from pattern_first_year first join pattern_last_year last
  on first.name = last.name and first.gender = last.gender
) 
where pop_jump <= 3

--Objective 2
--Compare popularity across decades
--Your second objective is to find the top 3 girl names and top 3 boy names for each year, 
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


--Objective 3
--Compare popularity across regions
--Your third objective is to find the number of babies born in each region, 
--and also return the top 3 girl names and top 3 boy names within each region.

--Return the number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region)
with cleaned_regions as (
  select state, 
  (case when region = 'New England' then 'New_England' else region END) as clean_region
  from regions
  UNION
  SELECT 'MI' as state, 'Midwest' as clean_region
),
sum_births_by_region as (
  select r.clean_region as region, sum(births) as sum_births
  from names_data n join cleaned_regions r
  on n.State = r.state
  group by r.clean_region
)
select region, sum_births,
rank() over(order by sum_births desc) as num_births_by_region
from sum_births_by_region

--Return the 3 most popular girl names and 3 most popular boy names within each region
with cleaned_regions as (
  select state, 
  (case when region = 'New England' then 'New_England' else region END) as clean_region
  from regions
  UNION
  SELECT 'MI' as state, 'Midwest' as clean_region
),
pop_pattern_by_region as (
  select r.clean_region as region, name, gender, sum(births) as sum_births
  from names_data n join cleaned_regions r
  on n.State = r.state
  group by r.clean_region, name, gender
)
select * from (
  select region, name, gender, sum_births,
  rank() over(partition by region, gender order by sum_births desc) as pop_rnk_by_region
  from pop_pattern_by_region
)
where pop_rnk_by_region <= 3


--Objective 4
--Explore unique names in the dataset
--Your final objective is to find the most popular androgynous names, 
--the shortest and longest names, 
--and the state with the highest percent of babies named "Chris".

--Find the 10 most popular androgynous names (names given to both females and males)
with androgynous_names as (
  select distinct m.name
  from names_data m join names_data F	
  on m.Name = f.Name 
  where m.Gender = 'M'
  and f.Gender = 'F'
  --limit 10
),
andro_pattern as (
  select n.name, sum(n.births) as sum_births
  from names_data as n join androgynous_names as an
  on n.Name = an.name
  group by n.name
)
SELECT * from (
  select name, sum_births, 
  rank() over(order by sum_births desc) as pop_rnk_androgynous
  from andro_pattern
)
where pop_rnk_androgynous <= 10;

--Find the length of the shortest and longest names, ---- shortest = 2, longest = 15
--and identify the most popular short names (those with the fewest characters) and long names (those with the most characters)
with name_length as (
  select distinct name, length(name) as name_len
  from names_data
),
name_len_range as (
  select min(name_len) as min_len,
  max(name_len) as max_len
  from name_length
),
pop_pattern as (
  select name, sum(births) as sum_births
  from names_data 
  group by name
)
select * FROM
(  
  select nlen.name, pat.sum_births, name_len,
  rank() over(partition by name_len order by sum_births desc) pop_rnk_by_length
  from pop_pattern pat join name_length nlen
  on pat.Name = nlen.name
) pop_pattern_by_length, name_len_range nrange
where pop_rnk_by_length = 1
and name_len in (nrange.min_len, nrange.max_len);

--Find the state with the highest percent of babies named "Chris"
with state_total as (
  select state, sum(births) as sum_births
  from names_data
  group by state
),
chris_total as (
  select state, sum(births) as chris_births
  from names_data
  where name = 'Chris'
  group by state
)
select state, sum_births, cleaned_births as chris_births,
(cleaned_births * 100.0)/sum_births as name_pcnt 
from (
  select s.state, s.sum_births, cast(coalesce(c.chris_births, 0) as int) as cleaned_births 
  from state_total as s LEFT join chris_total as c
  on s.state = c.state
)
order by name_pcnt desc
LIMIT 1
