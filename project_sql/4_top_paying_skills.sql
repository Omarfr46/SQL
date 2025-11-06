/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve
*/

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

/*
Short Verdict:
The highest-paying skills in this list are Kubernetes, Golang, and Elasticsearch (all at $145,000), 
while the lowest-paying among the top 25 are BigQuery ($97,500), Looker ($98,128), and GitHub ($98,333). 
Skills tied to cloud platforms, data engineering, and high-performance languages dominate the upper range.

These reflect demand for:

Cloud-native infrastructure (e.g., Kubernetes)

Backend/performance languages (Golang, Swift)

Search and data analytics engines (Elasticsearch)

Python data libraries (Pandas, Scikit-learn, Numpy)

🔍 Skills Categories & Trends

Cloud Platforms (AWS, GCP, IBM Cloud): All present, with GCP leading at $123,750, 
while AWS is lower at $105,278—possibly due to broader supply of AWS talent.

Programming Languages: Golang and Swift lead strongly. Java and C++ are solid but less compensated in this dataset.

Data/ML Libraries: Pandas, Scikit-learn, Numpy—all in the $118–126K bracket, showing continued strength 
for ML engineers and data scientists.

BI/Analytics Tools (Qlik, Looker, BigQuery): Hover around $97K–$101K, indicating these may be more common 
in analyst roles vs. engineering.

🧠 Most Surprising

VBA at $115,000: Despite being an older automation tool, it's still compensated highly—likely for roles in finance 
or enterprise workflow automation.