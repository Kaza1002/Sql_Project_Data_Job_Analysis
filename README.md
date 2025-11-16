# SQL Project: Data Analyst Job Market Exploration #

# Introduction
Dive into the data job market. This project focuses on data analyst roles, exploring:

Top-paying jobs

In-demand skills

Where skill demand meets salary potential


All SQL queries used in this project are available in: project_sql folder

# Background
This project was born from my desire to better understand the data analyst job market—
specifically which skills truly matter and where the best opportunities are.


Using real job posting data from my SQL course, I analyzed:

Job titles

Salary ranges


Locations

Required skills

Industry demand & salary relationships


# Questions I set out to answer:
What are the top-paying data analyst jobs?

What skills do these high-paying jobs require?

What skills are most in demand overall?

Which skills are associated with higher salaries?

What are the most optimal skills to learn today?


# Tools I Used
SQL:	Core analysis, querying, aggregations

PostgreSQL: 	Database engine for structured data

Visual Studio Code: 	SQL execution & project management

Git & GitHub: 	Version control, sharing analysis


# The Analysis
Below is a breakdown of each analytical step, the SQL queries used, and the insights generated.


# 1.Top-Paying Data Analyst Jobs
 SQL Query
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' 
  AND job_location = 'Anywhere' 
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

# Key Insights
Salaries range from $184,000 to $650,000 — massive earning potential.

Companies like SmartAsset, Meta, and AT&T lead high-paying roles.

Roles vary widely:

Data Analyst → Senior Analyst → Analytics Director

Remote-friendly positions dominate high-salary listings.

<img width="1030" height="539" alt="image" src="https://github.com/user-attachments/assets/e2515be6-1d7e-4199-8665-06f30b9dce6c" />


# 2.Skills for Top-Paying Data Analyst Jobs
SQL Query
WITH top_paying_jobs AS (
    SELECT job_id, job_title, salary_year_avg, name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
      AND job_location = 'Anywhere'
      AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*, skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;


# Skill Breakdown (Top-Paying Roles)

Skill	Count

SQL	8

Python	7

Tableau	6

R, Snowflake, Pandas, Excel	~3–5

These skills show employers expect data analysts to have strong programming + BI + data manipulation abilities.

<img width="1031" height="640" alt="image" src="https://github.com/user-attachments/assets/27f6451e-d458-4c31-84c4-966d59883438" />


# 3.Most In-Demand Skills for Data Analysts
SQL Query
SELECT skills, COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;


# Top 5 Most Demanded Skills
Skill	Demand Count

SQL	7,291

Excel	4,611

Python	4,330

Tableau	3,745

Power BI	2,609

SQL + Excel + Python remain the holy trinity for analysts.

<img width="294" height="286" alt="image" src="https://github.com/user-attachments/assets/175de04d-2d10-4dcb-bd89-74a6234ee10c" />


# 4. Skills Associated With Higher Salaries
SQL Query
SELECT skills, ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;


# Highest-Paying Skills (Top 10)

Skill	Avg Salary ($)

PySpark	208,172

Bitbucket	189,155

Couchbase	160,515

Watson	160,515

DataRobot	155,486

GitLab	154,500

Swift	153,750

Jupyter	152,777

Pandas	151,821

Elasticsearch	145,000

These highlight the premium placed on big data, ML infrastructure, cloud, and dev-ops skills.

<img width="344" height="517" alt="image" src="https://github.com/user-attachments/assets/483350e0-61c1-45a1-8e08-47dc7d54ce0f" />


# 5.Most Optimal Skills to Learn (Demand × Salary)
SQL Query
SELECT skills_dim.skill_id,
       skills_dim.skills,
       COUNT(skills_job_dim.job_id) AS demand_count,
       ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 25;


# Top 10 Optimal Skills (High Salary × High Demand)
Skill	Demand	Avg Salary ($)

Go	27	115,320

Confluence	11	114,210

Hadoop	22	113,193

Snowflake	37	112,948

Azure	34	111,225

BigQuery	13	109,654

AWS	32	108,317

Java	17	106,906

SSIS	12	106,683

Jira	20	104,918

These represent the best skills to learn for maximum job-market value.

<img width="599" height="511" alt="image" src="https://github.com/user-attachments/assets/5c7ca331-38a2-43fa-845c-293b78512497" />


# What I Learned
Complex Query Crafting — CTEs, joins, subqueries

Aggregation Mastery — COUNT(), AVG(), GROUP BY

Real-world Analytical Thinking — turning questions into insights

End-to-End Workflow — from raw CSVs → DB → SQL → insights


# Conclusions
Top-Paying Jobs: Remote data analyst salaries can reach $650,000.

Top Skills for High Pay: SQL and Python dominate high-paying roles.

Most Demanded Skills: SQL is #1 across all job postings.

Highest-Paying Skills: Tools like PySpark, Couchbase, and DataRobot command top salaries.

Optimal Skills: SQL + Cloud (AWS, Azure, Snowflake) + Big Data tools offer the best market value.

#  Closing Thoughts
This project significantly strengthened my SQL capabilities and expanded my understanding of the data analyst job landscape.

These insights provide clear guidance for:

Skill prioritization

Job search focus

Career planning

Continuous learning remains essential as the field evolves rapidly — and this project marks a solid step in that journey.




