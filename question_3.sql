-- Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?



--CTE gives list of all players in salary table with the sum of their combined salaries--
WITH player_salary AS (SELECT DISTINCT playerid,
										namefirst,
										namelast,
										SUM(salary) AS total_salary_earned
						FROM people LEFT JOIN salaries USING(playerid)
						GROUP BY playerid)
--Combining CTE with schools+collegeplaying table to get schools attached to players
SELECT namefirst AS first_name,
			namelast AS last_name,
			total_salary_earned::numeric::money
FROM player_salary INNER JOIN collegeplaying USING(playerid)
					INNER JOIN schools USING(schoolid)
WHERE schoolname ILIKE '%vanderbilt%'
GROUP BY namelast, namefirst, total_salary_earned
ORDER BY total_salary_earned DESC NULLS LAST;

--24 players are associated with Vanderbilt University
--ONLY 15 of those have earned a salary at the major league level
--David Price is the highest earner through the 2016 MLB season (81 million+)












