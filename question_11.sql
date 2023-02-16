-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. 
-- As you do this analysis, 
-- keep in mind that salaries across the whole league tend to increase together, 
-- so you may want to look on a year-by-year basis.

WITH team_wins AS (SELECT DISTINCT teamid, yearid,
					SUM(w) AS total_team_wins
					FROM teams
					WHERE yearid > 1999
					GROUP BY teamid,yearid),
	team_salary AS (SELECT DISTINCT teamid, yearid,
					SUM (salary::numeric::money) AS total_team_salary
					FROM salaries
					WHERE yearid > 1999
					GROUP BY teamid,yearid)
SELECT *,
		RANK()OVER(PARTITION BY yearid ORDER BY total_team_wins DESC) AS wins_rank,
		RANK()OVER(PARTITION BY yearid ORDER BY total_team_salary DESC) AS total_salary_rank
FROM team_wins
INNER JOIN team_salary
USING (teamid, yearid)
GROUP BY teamid,yearid,total_team_wins,total_team_salary
ORDER BY yearid;

