SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS yearly_avg,
    AVG(salary_hour_avg) as hour_avg

from job_postings_fact

WHERE job_posted_date > '2023-05-01'

GROUP BY job_schedule_type

ORDER BY job_schedule_type DESC;



SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS MONTH,
    COUNT(job_id) AS POSTINGS

from job_postings_fact

WHERE 
    EXTRACT(YEAR FROM job_posted_date  AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') =2023

GROUP BY MONTH
ORDER BY MONTH ;

9 
SELECT
  c.name AS company_name,
  COUNT(*) AS total_postings
FROM job_postings_fact j
JOIN company_dim c ON j.company_id = c.company_id
WHERE j.job_health_insurance = TRUE
  AND EXTRACT(QUARTER FROM j.job_posted_date) = 2
  AND EXTRACT(YEAR FROM j.job_posted_date) = 2023
GROUP BY c.name
ORDER BY total_postings DESC;


--CTE:

WIth company_job_count as (
select 
  company_id,
  count(*) as total_jobs
from job_postings_fact
GROUP BY company_id 
)

select 
  company_dim.name as comp_name,
  company_job_count.total_jobs
from company_dim
left join company_job_count on company_job_count.company_id = company_dim.company_id 
order by total_jobs DESC;


-- CTE PRACTISE

WITH skill_counts AS (
  SELECT
    sjd.skill_id,
    COUNT(*) AS mentions
  FROM skills_job_dim AS sjd
  GROUP BY sjd.skill_id
)
SELECT
  sd.skill_id,
  sd.skills       AS skill_name,
  sc.mentions
FROM skill_counts sc
JOIN skills_dim sd
  ON sd.skill_id = sc.skill_id
ORDER BY sc.mentions DESC
LIMIT 5;



--2

with per_comp as (
  select
    company_id,
    count(*) as job_count
  from job_postings_fact
  group by company_id
)

select
  cd.company_id,
  cd.company_name,
  pc.job_count,

CASE
  when pc.job_count < 10 then 'small'
  when pc.job_count BETWEEN 10 and 50 then 'medium'
  else 'large'
end as size

from per_comp pc
join company_dim as cd on cd.company_id=pc.company_id
order by pc.job_count desc 
