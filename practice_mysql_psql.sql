MYSQL:
To create a table in mysql:
CREATE TABLE sales1(product VARCHAR(20), quantity INT, brand VARCHAR(20), price FLOAT, social_media VARCHAR(5));

To insert values into the table: sales1
INSERT INTO sales1(product, quantity, brand, price, social_media) VALUES ('cellphone', 500, 'Apple', 869.67, 'FB'),('balloon', 1009, 'mixed_party', 37.45, 'TWT'), ('tees', 2000, 'American Aparrel', 256.87, 'FB'),('surf boards', 600, 'Hurley', 678.89, 'INSTG'),('dinner bookings', 5, 'Yelp_reservation', 115.90, 'Yelp');

CREATE TABLE sales_account(product VARCHAR(20), name VARCHAR(20), city VARCHAR(15), age MEDIUMINT, member_since DATE);

INSERT INTO sales_account(product, name, city, age, member_since) VALUES ('cellphone', 'Odi', 'SF', 5, '2017-2-12'), ('balloon', 'Rara', 'AZ', 45, '2016-8-25'), ('tees', 'Beyonce', 'TX', 40, '2015-4-16'), ('surf boards', 'Kiki', 'CN', 72, '2014-7-31'), ('dinner bookings', 'Momo', 'WA', 32, '2013-5-22');

Left Join: Will get the selected values from the table in the left for all the records (given that the table in the left has more values than the table in the right), but only for the common records from the table in the right
Right Join: Opposite of Left Join
P.S.: order which the tables are mentioned in a query matters!


Postgres:
To find the median of a table/dataset using Postgres:
For a given table:

order_id | date       | item_count | order_value  
------------------------------------------------
50003    | 2016-09-02 | 1          | 4.99  
50006    | 2016-09-02 | 1          | 5.99  
50002    | 2016-09-02 | 1          | 5.99  
50008    | 2016-09-02 | 1          | 5.99  
50001    | 2016-09-02 | 2          | 7.98  
50009    | 2016-09-02 | 2          | 12.98  
50007    | 2016-09-02 | 2          | 19.98  
50010    | 2016-09-02 | 1          | 20.99  
50000    | 2016-09-02 | 3          | 35.97  
50004    | 2016-09-02 | 7          | 78.93  


SELECT ROUND(AVG(item_count), 2) AS median_item_count  
FROM (  
  SELECT item_count
  FROM (
    SELECT item_count,
           COUNT(*) OVER() AS row_count,#the window funciton over() without using partition inside will have a single partition, meaning the entire row will be considered as one partition/group
           ROW_NUMBER() OVER(ORDER BY item_count) AS row_number#window function over() with order by 
    FROM orders
    WHERE item_count <> 0
  ) x
WHERE row_number IN ((row_count + 1)/2, (row_count + 2)/2)#for odd number it gives the middle row_number and for even number it gives middle and the next to middle row_numbers
) y
;




Here the window function OVER() is used without PARTITION BY or ORDER BY. The entire column of item_count is considered as one group and there
are not any partitions or divisions within the group
SELECT item_count, COUNT(*) OVER() AS row_count
FROM orders;
 item_count | row_count 
------------+-----------
          1 |         6
          1 |         6
          1 |         6
          1 |         6
          2 |         6
          2 |         6


Here ORDER BY arranges the item_count in ascending order(by default) and the count function counts the number of item_count according to
two types of item_count
SELECT item_count, COUNT(*) OVER(ORDER BY item_count) AS row_count
FROM orders;
 item_count | row_count 
------------+-----------
          1 |         4
          1 |         4
          1 |         4
          1 |         4
          2 |         6
          2 |         6

The above query but used with PARTITION BY. As can be seen PARTITION BY always divides or creates partitions according to different types of field value mentioned
in the partition expression
SELECT item_count, COUNT(*) OVER(PARTITION BY item_count) AS rc FROM orders;
 item_count | rc 
------------+----
          1 |  4
          1 |  4
          1 |  4
          1 |  4
          2 |  2
          2 |  2

Window function OVER() used with ORDER BY: here ORDER BY arranges the item_count in ascending order(by default) and because ROW_NUMBER assigns unique number
incrementing by one the rwo_number output can be seen incremented starting the beginning of the column
SELECT item_count, ROW_NUMBER() OVER(ORDER BY item_count) AS row_number
FROM orders;
 item_count | row_number 
------------+------------
          1 |          1
          1 |          2
          1 |          3
          1 |          4
          2 |          5
          2 |          6

The window function ROW_NUMBER assigns a unique number to every row. When used with PARTITION BY the row numbers are assigned incrementing by 1 within partitions. 
So separate increment can be seen in the partition item_count: 1 and item_count: 2

SELECT item_count, ROW_NUMBER() OVER(PARTITION BY item_count) As row_n
FROM orders;
 item_count | row_n 
------------+-------
          1 |     1
          1 |     2
          1 |     3
          1 |     4
          2 |     1
          2 |     2
