-- Objective 3: Compare popularity across regions
-- To find the number of babies born in each region, 
-- and also return the top 3 girl names and top 3 boy names within each region.

-- Return the number of babies born in each of the six regions 
-- Data cleaning and handling missing data 
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
from sum_births_by_region;

-- Return the 3 most popular girl names and 3 most popular boy names within each region
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
