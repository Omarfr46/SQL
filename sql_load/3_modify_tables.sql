/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding


SELECT * FROM company_dim;


COPY company_dim
FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\sql_load\3_modify_tables.sql'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\Users\Usuario\Desktop\Trainings\SQL\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT *
FROM skills_job_dim
LIMIT 100;

SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

SELECT'2023-02-19'::DATE;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM   
    job_postings_fact

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date_time
FROM    
    job_postings_fact;
LIMIT 5;

SELECT  
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM 
    job_postings_fact
LIMIT 5;

SELECT  
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM 
    job_postings_fact
LIMIT 5;

SELECT 
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM    
    job_postings_fact
WHERE   
    job_title_short LIKE '%Data%'
GROUP BY
    month
ORDER BY
    month;


/*

Label new column as follow:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;