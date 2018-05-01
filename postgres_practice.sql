#Maybe you're just interested in what the campaign ids are. Use 'SELECT DISTINCT' to figure out all the possible values of that column.
SELECT DISTINCT(campaign_id) FROM users;

SELECT COUNT(DISTINCT userid) AS distinct_users, date_part('month', dt) AS num_users_month FROM users
WHERE campaign_id='FB'
GROUP BY num_users_month;

#Write a query to get the count of just the users who came from Facebook.
SELECT COUNT(*) FROM users
WHERE campaign_id='FB';

#Now, count the number of users coming from each service. Here you'll have to group by the column you're selecting with a GROUP BY clause.
SELECT COUNT(*) AS users, campaign_id AS media_channel FROM users
GROUP BY media_channel
ORDER BY users DESC;

#Use COUNT (DISTINCT columnname) to get the number of unique dates that appear in the users table.
SELECT COUNT(DISTINCT dt) FROM users;

#There's also MAX and MIN functions, which do what you might expect. Write a query to get the first and last registration date from the users table.
SELECT MAX(dt) AS last_registration_date FROM users;
output: 2013-12-31

SELECT MIN(dt) AS last_registration_date FROM users;
output: 2013-01-01

#what I want to achieve is that select max num_users per month. find the month with max value and then expand the month and find the date with max value per
#campaign_id. P.S.: this is from users table in readychef database.


SELECT avg(price) AS mean_price FROM meals;
output: 10.6522829904666332

Can round the decimal to 2 digits. what we are doing is changing the decimal type to text or char and that's why we have type as TEXT? answer to your question: If you're formatting
#for display to the user, don't use round.
#Use to_char (see: data type formatting functions in the manual), which lets you specify a format and gives you a text
#result that isn't affected by whatever weirdness your client language might do with numeric values.
SELECT (round (avg(price)::DECIMAL, 2)::TEXT) AS mean_price FROM meals;
output: 10.65

Another format to round the decimal
SELECT to_char (avg(price)::float, 'FM999999990.00') FROM meals;
output: 10.65

Another format and why is it a good idea to not use this while displaying to customers had been explained above
SELECT round(avg(price)::numeric,2) FROM meals; #here we are casting the type as numeric in order to round it
output: 10.65

Now get the average price, the min price and the max price for each meal type. Don't forget the group by statement!
SELECT round(avg(price)::numeric,2) AS mean_price, MAX(price) AS max_meal_price, MIN(price) AS min_meal_price, type AS type_meal FROM meals
GROUP BY type_meal;
