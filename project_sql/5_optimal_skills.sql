/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles.
- Concentrates on remote positions with specified salaries.
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis.
*/

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
