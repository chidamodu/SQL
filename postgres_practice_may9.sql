To count the number of results where users have bought items

SELECT COUNT(*) FROM users u
JOIN events e
ON u.userid=e.userid
WHERE e.event='bought';

To count the number of users who have bought items via each campaign
SELECT COUNT(u.userid), u.campaign_id
FROM users u
JOIN events e
ON u.userid=e.userid
WHERE e.event='bought'
GROUP BY u.campaign_id;

output:
count | campaign_id
-------+-------------
25299 | FB
 6443 | PI
10088 | RE
22439 | TW
(4 rows)


For each day, get the total number of users who have registered as of that day.
You should get a table that has a dt and a cnt column. This is a cumulative sum. You wouldn't be able to compare a column to the distinct values of the same column
within the same query. It's because the query would only be able to figure out that you referencing the column twice after executing once. And that's the reason
to use subquery consisting of the same column within a query to refer to it outside the subquery but within the same query. Here COUNT(b.dt) is finding the cumulative sum
according to the condition b.dt <= a.dt
SELECT a.dt, COUNT(b.dt)
FROM(SELECT DISTINCT dt FROM users) a
JOIN users b
ON b.dt <= a.dt
GROUP BY a.dt
ORDER BY a.dt;


To find total number of buys per day
SELECT date_part('day', users.dt) AS day_max_buys, COUNT(users.userid) AS buys
FROM users
JOIN events
ON users.userid=events.userid AND events.event='bought'
GROUP BY day_max_buys;


What day of the week gets meals with the most buys?
SELECT date_part('dow', meals.dt) AS day_of_week, COUNT(meals.meal_id) AS num_meals
FROM meals
JOIN events
ON meals.meal_id=events.meal_id AND event='bought'
GROUP BY day_of_week
ORDER BY num_meals DESC;


Which month had the highest percent of users who visited the site purchase a meal?
SELECT t2.month, CAST(t1.num_buy AS REAL)/(t2.num_visit) AS average_meals
FROM
(
SELECT COUNT(*) AS num_visit, date_part('month', visits.dt) AS month
FROM visits
GROUP BY month
)t2
JOIN
(
SELECT COUNT(*) AS num_buy, date_part('month', events.dt) AS month
FROM events
GROUP BY month
)t1
ON t1.month=t2.month
ORDER BY average_meals;

output
 month |   average_meals
-------+-------------------
     1 | 0.612538298373792
     7 | 0.612587556654306
     5 | 0.614529325381365
    12 |  0.61512311203924
     2 | 0.615749306197965
     8 | 0.618001160429359
    11 | 0.619259117971634
     3 |  0.61969145432484
    10 |  0.62119207245354
     6 | 0.621959002374084
     4 | 0.622408178408014
     9 | 0.623877752328089
(12 rows)

Same question as above but rounded to two decimals in output
SELECT t2.month, ROUND((CAST(t1.num_buy AS FLOAT)/(t2.num_visit))::numeric, 2) AS average_meals
FROM
(
SELECT COUNT(*) AS num_visit, date_part('month', visits.dt) AS month
FROM visits
GROUP BY month
)t2
JOIN
(
SELECT COUNT(*) AS num_buy, date_part('month', events.dt) AS month
FROM events
GROUP BY month
)t1
ON t1.month=t2.month
ORDER BY average_meals;
 month | average_meals
-------+---------------
     1 |          0.61
     5 |          0.61
     7 |          0.61
     4 |          0.62
    11 |          0.62
     6 |          0.62
    12 |          0.62
     8 |          0.62
     9 |          0.62
    10 |          0.62
     2 |          0.62
     3 |          0.62
(12 rows)
