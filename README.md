# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytices.

SQL queries? Check them out here: [project_sql folder](/project_sql/).

# Background
With the rapid expansion of data-driven decision-making, companies are increasingly seeking talented data analysts. To support job seekers and professionals in navigating this field, this project analyzes a dataset containing job postings, salary data, and required skills from companies hiring data analysts. The dataset is structured across multiple relational tables, linking job posts to companies and required skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?


# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.


# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opprotunities in the field.



```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact AS jpfTable
LEFT JOIN company_dim ON jpfTable.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```



### 2. Top Paying Job Skills Job
To uncover the most lucrative technical skills for Data Analyst roles, I focused on the top 10 highest-paying job postings, filtered by remote positions with known salary data. By joining these roles to their associated skills, we get a clear picture of which skills are most commonly required in top-paying positions.
This analysis reveals the strategic technical capabilities that employers value most in high-compensation roles, highlighting where aspiring or active analysts should invest their time to boost their earning potential.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact AS jpfTable
    LEFT JOIN company_dim ON jpfTable.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT top_paying_jobs.*,
        skills
FROM top_paying_jobs 
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
ORDER BY 
    salary_year_avg DESC
```

### 3. Top Demanded Skills
This query identifies the skills that appear most frequently across remote data analyst job postings. By counting how many times each skill is listed, we highlight the top 5 most in-demand proficiencies in the current job market.
Understanding these high-demand skills provides essential guidance for job seekers, as focusing on these areas can significantly increase employability and match candidate profiles with a high volume of open roles.

```sql
-- Option 1 to solve the problem
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

-- Option 2 to solve the problem
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

### 4. Top Paying Skills
This query focuses on the average salary associated with each skill across remote Data Analyst job postings by calculating the average salary for jobs requiring specific skills.
The results show which skills not only appear in job descriptions but are also associated with higher-paying positions. This insight is especially useful for prioritizing skill development that directly correlates to financial reward in data analytics roles.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

### 5. Optimal Skills
To determine the most strategic skills to learn, we combine insights from both demand and salary data. The "optimal" skills are those which appear frequently in job postings and also offer high average salaries.
This balanced approach helps define the "sweet spot" for career growth, guiding analysts toward skills that yield both job security and financial benefits. Whether you're upskilling or planning your learning journey, focusing on these skills maximizes return on investment in the competitive data analytics market.

```sql
WITH skills_demand AS(
    SELECT 
        sd.skill_id,
        sd.skills,
        COUNT(DISTINCT j.job_id) AS demand_count
    FROM job_postings_fact j
    INNER JOIN skills_job_dim sj ON j.job_id = sj.job_id
    INNER JOIN skills_dim sd ON sj.skill_id = sd.skill_id
    WHERE
        j.job_title_short = 'Data Analyst' 
        AND j.salary_year_avg IS NOT NULL
        AND j.job_work_from_home = TRUE
    GROUP BY sd.skill_id, sd.skills
), average_salary AS (
    SELECT
        sj.skill_id,
        sd.skills,
        ROUND(AVG(j.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact j
    INNER JOIN skills_job_dim sj ON j.job_id = sj.job_id
    INNER JOIN skills_dim sd ON sj.skill_id = sd.skill_id
    WHERE
        j.job_title_short = 'Data Analyst' 
        AND j.salary_year_avg IS NOT NULL
        AND j.job_work_from_home = TRUE
    GROUP BY sj.skill_id, sd.skills
)
SELECT
    d.skill_id,
    d.skills,
    d.demand_count,
    a.avg_salary
FROM skills_demand d
INNER JOIN average_salary a 
  ON d.skill_id = a.skill_id AND d.skills = a.skills
WHERE
    demand_count>10
ORDER BY a.avg_salary DESC, d.demand_count DESC;
```

# What I Learned
Throughout this project, I strengthened both my technical and analytical skills. Writing and testing multiple SQL queries deepened my understanding of how relational databases interconnect through JOINs, CTEs, and filtering logic, while also teaching me how to extract meaningful insights from large datasets.

I also learned the importance of data interpretation — translating raw query results into actionable conclusions about the job market. Beyond just SQL syntax, this process helped me think like a data professional, identifying not just what the data says, but what it means for career strategy in the data analytics field.

Additionally, managing this project through Git and GitHub improved my workflow organization and version control practices, simulating a real-world data analytics environment.

# Conclusions
This analysis revealed several key insights about the data analytics job market:

- The highest-paying Data Analyst roles are strongly tied to remote positions, reflecting the global shift toward flexibility in the tech industry.

- SQL, Python, and Tableau emerged as both high-demand and high-paying skills, confirming their importance as foundational tools for analysts.

- Skills related to cloud computing (AWS, Azure) and machine learning showed strong correlations with higher salaries, suggesting that blending analytics with engineering knowledge offers a competitive advantage.

- The overlap between in-demand and high-paying skills defined the most optimal skill set — one that ensures employability, professional growth, and strong earning potential.

In summary, mastering a combination of core analytics skills (SQL, Python, visualization tools) and emerging technologies (cloud, AI) positions a data analyst for long-term success in a rapidly evolving job market.