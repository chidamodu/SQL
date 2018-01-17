1. Let us assume the following table:
 follower | followee 
----------+----------
        1 |        2
        2 |        1
        1 |        3
        1 |        4
(4 rows)

Query the table to find out the friend relationships or in other words find the follower and followee that are friends to each other.

SELECT u1.follower FROM user_follower u1#I am selecting from the common friends from follower column
INNER JOIN user_follower u2
ON u1.followee=u2.follower
WHERE u1.follower=u2.followee;
 
outcome:
 follower 
----------
        2
        1
(2 rows)


2. I have two tables:
 
TABLE: users
 u_id | fname  | lname  
------+--------+--------
    1 | Sugar  | Salt
    2 | Humpty | Dumpty
    3 | Maui   | Hawaii
    4 | Angry  | Bird
(4 rows)

TABLE: follows#it means 1, 2, 3, 4 are following: 4, 3, 2, 2 respectively
 user_id | follow_id 
---------+-----------
       1 |         4
       2 |         3
       3 |         2
       4 |         2
(4 rows)

#Trying to query the users and the names of the ones(followee) they are following:
SELECT users.u_id, users.fname, users.lname, u.u_id, u.fname, u.lname FROM users
INNER JOIN follows f 
ON (f.user_id=users.u_id)
INNER JOIN users u ON (u.u_id=f.follow_id);

#for example: as can be seen below, Sugar Salt is following Angry Bird. And Angry Bird is following Humpty Dumpty :)
 u_id | fname  | lname  | u_id | fname | lname  
------+--------+--------+------+-------+--------
    1 | Sugar  | Salt   |    4 | Angry  | Bird
    2 | Humpty | Dumpty |    3 | Maui   | Hawaii
    3 | Maui   | Hawaii |    2 | Humpty | Dumpty
    4 | Angry  | Bird   |    2 | Humpty | Dumpty
(4 rows)


Question: 
Amber conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 
Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.
Note:
The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.

Input Format
The following tables contain company data:
Company: The company_code is the code of the company and founder is the founder of the company. 
Lead_Manager: The lead_manager_code is the code of the lead manager, and the company_code is the code of the working company. 
Senior_Manager: The senior_manager_code is the code of the senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 
Manager: The manager_code is the code of the manager, the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 
Employee: The employee_code is the code of the employee, the manager_code is the code of its manager, the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 
Sample Input
Company Table: Lead_Manager Table: Senior_Manager Table: Manager Table: Employee Table: 
Sample Output
C1 Monika 1 2 1 2
C2 Samantha 1 1 2 2


POSTGRES VERSION:
WITH t1 AS
(
SELECT COUNT(DISTINCT e.employee_code) AS emp, e.company_code AS cmp
    FROM employee e
    GROUP BY e.company_code
)
WITH t2 AS
(
SELECT COUNT(DISTINCT m.manager_code) AS mp, t1.emp, t1.cmp AS comp
    FROM manager m
    JOIN t2
    ON t1.cmp=m.company_code
    GROUP BY m.company_code
)
WITH t3 AS
(
SELECT COUNT(DISTINCT s.senior_manager_code) AS senior, t2.mp, t1.emp, t1.cmp AS compy
    FROM senior_manager s
    JOIN t2
    ON t2.comp=s.company_code
    GROUP BY s.company_code
)
WITH t4 AS
(
SELECT COUNT(DISTINCT l.lead_manager_code), t3.senior AS senr, t2.mp AS manager, t1.emp AS employee, t1.cmp AS comp_final
    FROM lead_manager l
    JOIN t3
    ON t3.compy=l.company_code
    GROUP BY l.company_code
)

SELECT c.company_code, c.founder, t4.senr, t4.manager, t4.employee
FROM company c
JOIN t4
ON t4.comp_final=c.company_code
GROUP BY c.company_code
ORDER BY c.company_code;

MYSQL VERSION
select c.company_code, c.founder, count(distinct lm.lead_manager_code), 
count(distinct sm.senior_manager_code), count(distinct m.manager_code), 
count(distinct e.employee_code)
from Company c, Lead_Manager lm, Senior_Manager sm, Manager m, Employee e
where c.company_code = lm.company_code
	and lm.lead_manager_code = sm.lead_manager_code
	and sm.senior_manager_code = m.senior_manager_code
	and m.manager_code = e.manager_code
group by c.company_code, c.founder
order by c.company_code


