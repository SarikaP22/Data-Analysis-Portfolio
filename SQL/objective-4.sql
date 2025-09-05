-- Objective 4: Explore unique names in the dataset
-- To find the most popular androgynous names, 
-- the shortest and longest names, 
-- and the state with the highest percent of babies named "Chris".


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
LIMIT 1;
