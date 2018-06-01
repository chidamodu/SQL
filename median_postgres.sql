For the following table find the median in number_of_staff field using POSTGRES

table: reportdata
	college_name 		| number_of_staff
	---------------------------------
	Sheffield		| 100
	Rotherham		| 150
	Leeds			| 300
	Manchester		| 400
	Newcastle		| 450

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP ( order by number_of_staff )
FROM reportdata;
Answer: 300

For table reportdata2: find the median number_of_staff within each college_type
college_name 	| number_of_staff 	| college_type
	----------------------------------------------------
	Sheffield	| 100				|FE
	Rotherham	| 150				|FE
	Leeds		| 300				|FE
	Manchester	| 400				|Sixth Form
	Newcastle	| 450				|Sixth Form


SELECT college_type, PERCENTILE_CONT(0.5) WITHIN GROUP ( order by number_of_staff )
FROM reportdata2
GROUP BY college_type

Answer:
FE 150
Sixth Form 425