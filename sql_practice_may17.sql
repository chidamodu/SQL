#may-17
Which month had the highest percent of users who visited the site purchase a meal?
SELECT v.month, v.year, CAST(e.cnt AS REAL) / v.cnt AS avg
FROM (
    SELECT
        date_part('month', dt) AS month,
        date_part('year', dt) AS year,
        COUNT(1) AS cnt
    FROM visits
    GROUP BY 1, 2) v
JOIN (
    SELECT
        date_part('month', dt) AS month,
        date_part('year', dt) AS year,
        COUNT(1) AS cnt
    FROM events
    WHERE event='bought'
    GROUP BY 1, 2) e
ON v.month=e.month AND v.year=e.year
ORDER BY avg DESC;


Find all the meals that are above the average price of the previous 7 days.
SELECT a.meal_id
FROM meals a
JOIN meals b
ON b.dt<=a.dt AND b.dt>a.dt-7
GROUP BY a.meal_id, a.price
HAVING a.price > AVG(b.price);


What percent of users have shared more meals than they have liked?
SELECT CAST(COUNT(a.userid) AS REAL)/(SELECT COUNT(userid) FROM events) AS percent_share_more
FROM
(
SELECT userid FROM events
GROUP BY userid
HAVING
SUM(CASE WHEN event='share' THEN 1 ELSE 0 END)>SUM(CASE WHEN event='like' THEN 1 ELSE 0 END)
)a;

To check whether a column has Null values or not
SELECT event
FROM events
WHERE event IS Null;

For every day, count the number of users who have visited the site and done no action. (amongst the visitors that had not done any action you can try to find how many
of them had visited most often and understand their behavior for example - business use case)
SELECT COUNT(visits.userid), visits.dt
FROM visits
LEFT JOIN events
ON visits.userid=events.userid and visits.dt=events.dt
WHERE events.userid IS  NULL
GROUP BY visits.dt;

Find all the dates with a greater than average number of meals.(it wouldnt make sense to average the meal_id because meal_id could be 900 or could be 2000
and thats why we gotta count dates as number of dates correspond to the number of meal_id that appear)
SELECT dt
FROM meals
GROUP BY dt
HAVING
COUNT(1) > (SELECT COUNT(1) FROM meals) / (SELECT COUNT(DISTINCT dt) FROM meals);

Find all the users who bought a meal before liking or sharing a meal.
SELECT bought.userid
FROM
(
SELECT MIN(dt) AS f1, userid
FROM events
WHERE event='bought'
GROUP BY userid
)bought
JOIN
(
SELECT MIN(dt) AS f2, userid
FROM events
WHERE event='like' OR event='share'
GROUP BY userid
)like_share
ON bought.userid=like_share.userid
WHERE bought.f1 < like_share.f2;
