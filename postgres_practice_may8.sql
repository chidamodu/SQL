Maybe you only want to consider the meals which occur in the first quarter (January through March).
Use date_part to get the month like this: date_part('month', dt).
Add a WHERE clause to the above query to consider only meals in the first quarter of 2013 (month<=3 and year=2013).
SELECT type, round(AVG(price)::numeric, 2) AS average_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM meals
WHERE date_part('year', dt)=2013 AND
date_part('month', dt)<=3
GROUP BY type;


There are also scenarios where you'd want to group by two columns.
Modify the above query so that we get the aggregate values for each month and type.
You'll need to add the month to both the select statement and the group by statement.
It'll be helpful to alias the month column and give it a name like month so you don't have to call the date_time function again in the GROUP BY clause.
SELECT type, round(AVG(price)::numeric, 2) AS average_price, MIN(price) AS min_price, MAX(price) AS max_price, date_part('month', dt) AS month_det
FROM meals
WHERE date_part('month', dt)<=3
GROUP BY type, month_det;

From the events table, write a query that gets the total number of buys, likes and shares for each meal id.
From the events table, write a query that gets the total number of buys, likes and shares for each meal id.
SELECT COUNT(event) AS sum_event, meal_id
FROM events
GROUP BY meal_id;


To find the count on each event, you could do like this: SUM(CASE WHEN event='bought' THEN 1 ELSE 0 END).
SELECT meal_id,
SUM(CASE WHEN event='bought' THEN 1 ELSE 0 END) AS num_bought,
SUM(CASE WHEN event='like' THEN 1 ELSE 0 END) AS num_likes,
SUM(CASE WHEN event='share' THEN 1 ELSE 0 END) AS num_shares
FROM events
GROUP BY meal_id
ORDER BY meal_id DESC;

To figure out how many distinct years are in the dt column
SELECT DISTINCT(date_part('year', dt)) AS year_det
FROM events;

To get a count on number of boughts from campaigns
SELECT COUNT(campaign_id) AS campaign
FROM users
JOIN events
ON users.userid=events.userid
WHERE event='bought';


Answer the question, "What user from each campaign bought the most items?"
SELECT
    campaign_id, userid, buys
FROM
    (SELECT
        campaign_id, userid, buys, MAX(buys) OVER (PARTITION BY campaign_id) AS max_buys
    FROM
        (SELECT
        events.userid, users.campaign_id, COUNT(0) AS buys
    FROM
        events
    JOIN users ON users.userid = events.userid
        AND events.event = 'bought'
    GROUP BY events.userid , users.campaign_id) inner_query) outer_query
WHERE
    buys = max_buys;

An alternative query form for the same question is as follows:
WITH user_campaign_counts AS (
    SELECT campaign_id, users.userid, COUNT(users.userid) AS num_buyers
    FROM users
    JOIN events
    ON users.userid=events.userid and events.event='bought'
    GROUP BY campaign_id, users.userid)

SELECT u.campaign_id, u.userid, u.num_buyers
FROM user_campaign_counts u
JOIN (SELECT campaign_id, MAX(num_buyers) AS num_buyers2
      FROM user_campaign_counts
      GROUP BY campaign_id) m
ON u.campaign_id=m.campaign_id AND u.num_buyers=m.num_buyers2
ORDER BY u.campaign_id, u.userid;
