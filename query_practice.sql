
You have a SQL database which contains information about what jobs students have applied to. You have three tables with this structure:

    companies: id, name
    students: id, name
    applications: comp_id, stud_id, date

The data is stored the SQL dump `applications.sql`. Recall that the steps for loading the database into postgres:

* Make sure the Postgres server is running (open Postgres.app)
* In the command line, run `psql` to open postgres command line.
* In postgres run: `CREATE DATABASE applications;`
* Exit postgres and in the command line run: `psql applications < applications.sql`
* Open the postgres database: `psql applications`

Don't read too much into the "data". It was created randomly.

1. Write a SQL query which gives all of the students who applied to a job before June 1 (dates are in the form "2014-06-01").
Your result should have these columns: `id, name`.

SELECT s.id, s.name FROM students s
INNER JOIN applications
ON s.id=applications.stud_id
WHERE applications.date < '2014-06-01';
 id |  name   
----+---------
  1 | wini
  1 | wini
  2 | jonny
  2 | jonny
  4 | erin
  7 | ethan
  7 | ethan
 10 | stephen
 10 | stephen
 10 | stephen
 11 | bruno
 12 | jana
 12 | jana
 13 | ajay
 14 | adam
 15 | michael
(16 rows)


2. Write a SQL query which gives a count of how many students applied to each company.
Your result should contain three columns: `id, name, cnt`. You should include companies in your result which have 0 applicants.

SELECT c.id, c.name, COUNT(DISTINCT a.stud_id) FROM companies c
INNER JOIN applications a
ON c.id=a.comp_id
GROUP BY c.id, c.name
ORDER BY c.name;
 id |     name     | count 
----+--------------+-------
  5 | facebook     |     4
  6 | heroku       |     2
  9 | keen io      |     3
 10 | khan academy |     6
  7 | looker       |     5
  2 | lumiata      |    10
  4 | radius       |     3
  3 | stripe       |     4
  1 | tesla        |     3
(9 rows)




