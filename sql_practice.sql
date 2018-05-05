#To find Median of a large dataset
#https://www.cs.rutgers.edu/~muthu/bquant.pdf

#Common Table Expressions: With + Recursive
#To find the sum of all the numbers starting from 1 to 100 but not including 100
WITH RECURSIVE t(n) AS (
     VALUES (1)
   UNION ALL
     SELECT n+1 FROM t WHERE n < 100
 )
 SELECT sum(n) FROM t;

#To find median of a dataset using Postgres
#First, a CTE to sort and number all of the rows with count
with ordered_purchases as (
  select
      price,
      row_number() over (order by price) as row_id,
      (select count(1) from purchases) as ct
  from purchases
)

#Then we find the middle one or two rows and average their values:
select avg(price) as median
from ordered_purchases
where row_id between ct/2.0 and ct/2.0 + 1

#Describe how to get the top k queries from a search log of terabytes of data. Memory/Disk per machine is limited but you can use multiple machines.
#Map reduce
