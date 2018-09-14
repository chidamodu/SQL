To find the customers that has bought most orders

SELECT * from orders o, customer c 
WHERE o.cusId = c.cusId and o.cusId IN (SELECT cusId from orders GROUP BY cusId HAVING count(*) = 
(SELECT count(*) from orders 
GROUP BY or.cusId 
ORDER BY count(*) DESC limit 1));


SELECT * FROM (
  SELECT cid,COUNT(*) 
  FROM placed
  GROUP BY cid
  ORDER BY COUNT(*) DESC
  ) a
WHERE rownum = 1

