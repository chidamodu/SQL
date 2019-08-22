How many customers bought product A and did not buy product B? 

SELECT COUNT(*) AS customers_bought_A
FROM
company_oders o
INNER JOIN 
company_customers c
ON o.user_id=c.user_id
WHERE ('A' in o.product) AND ('B' NOT IN o.product)
GROUP BY o.user_id;


How many customers only bought product A?
SELECT COUNT(*) AS customers_bought_A
FROM
company_oders o
INNER JOIN 
company_customers c
ON o.user_id=c.user_id
WHERE o.product LIKE "%A%" AND o.product NOT LIKE ("%B%" OR "%C%" OR "%D%" OR "%E%" OR "%F%")
GROUP BY o.user_id;



How many customers only bought product A, B and C?
SELECT COUNT(*) AS customers_bought_A
FROM
company_oders o
INNER JOIN 
company_customers c
ON o.user_id=c.user_id
WHERE o.product NOT LIKE ("%D%" OR "%E%" OR "%F%")
GROUP BY o.user_id;



