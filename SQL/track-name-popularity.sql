-- Objective 1: Track changes in name popularity
--To see how the most popular names have changed over time, 
--and also to identify the names that have jumped the most in terms of popularity.

-- how the most popular names have changed over time
with pop_3_cte as (
  -- top 3 most popular boy and girl baby names of all the time
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
