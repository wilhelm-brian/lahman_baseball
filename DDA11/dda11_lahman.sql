-- 1. What range of years for baseball games played does the provided database cover? 
SELECT MIN(yearid) AS first_year, MAX(yearid) AS last_year
FROM teams;

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT CONCAT(namefirst, ' ', namelast) AS player_name,
		height,
		name As team_name,
		g_all AS games_played
FROM people LEFT JOIN appearances USING(playerid)
			INNER JOIN teams USING(teamid, yearid)
WHERE height = (SELECT MIN(height)
			   FROM people);

-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT CONCAT(MIN(namefirst), ' ', MIN(namelast)) AS player_name,
		'Vanderbilt University' As school_name,
		COALESCE(SUM(salary)::numeric::money, '0') AS total_money_earned
FROM salaries FULL JOIN people USING(playerid)
WHERE playerid IN (SELECT DISTINCT(playerid) As playerid
				   FROM people INNER JOIN collegeplaying USING(playerid)
				   LEFT JOIN schools USING(schoolid)
				   WHERE schoolname ILIKE 'Vanderbilt%')
GROUP BY namefirst, namelast
ORDER BY total_money_earned DESC;

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
SELECT SUM(CASE WHEN pos IN ('P', 'C') THEN po END) AS battery_putouts,
		SUM(CASE WHEN pos IN ('1B', '2B', '3B', 'SS') THEN po END) AS infield_putouts,
		SUM(CASE WHEN pos = 'OF' THEN po END) AS outfield_putouts
FROM fielding
WHERE yearid = 2016;

SELECT position_groups, SUM(po) As total_putouts 
FROM (SELECT po, CASE WHEN pos IN ('P', 'C') THEN 'battery'
			 		  WHEN pos = 'OF' THEN 'outfield'
			 		  ELSE 'infield' END AS position_groups
	  FROM fielding
	  WHERE yearid = 2016) AS positions
GROUP BY position_groups
ORDER BY total_putouts DESC;

-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
SELECT decade, ROUND(SUM(hr::numeric)/SUM(g),2)*2 AS hr_per_game, ROUND(SUM(so::numeric)/SUM(g),2)*2 AS k_per_game
FROM (SELECT CONCAT(LEFT(yearid::text, 3), '0s') AS decade, yearid, teamid, g, hr, so, hra, soa
	  FROM  teams 
	  WHERE yearid > 1919) AS stats
GROUP BY decade
ORDER BY decade;

-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
SELECT CONCAT(namefirst, ' ', namelast) AS player_name, 
			stolen_bases, total_attempts, ROUND(sb_percent,2) AS sb_percent
FROM (SELECT playerid, SUM(sb) AS stolen_bases, SUM(cs+sb) total_attempts, SUM(sb::numeric)/SUM(sb+cs) * 100 AS sb_percent, 
	  								  MIN(namefirst) AS namefirst, MIN(namelast) AS namelast
	  FROM batting INNER JOIN people USING(playerid)
	  WHERE yearid = 2016
	  GROUP BY playerid
	  HAVING SUM(sb+cs) > 19) AS players
ORDER BY sb_percent DESC;

-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
(SELECT name, yearid, w, 'Most Wins (NO WS)' AS significance
FROM teams
WHERE (yearid, w) IN(SELECT yearid, w
					 FROM teams
					 WHERE yearid > 1969 AND wswin = 'N' 
					 ORDER BY w DESC
					 LIMIT 1))
UNION
(SELECT name, yearid, w, 'Least Wins (YES WS) (excl. 1981)' AS significance
FROM teams
WHERE (yearid, w) IN(SELECT yearid, w
					 FROM teams
					 WHERE yearid > 1969 AND wswin = 'Y' AND yearid <> 1981 
					 ORDER BY w 
					 LIMIT 1));


SELECT ROUND(SUM(CASE WHEN wswin = 'Y' THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2) AS perc_most_w_and_ws
FROM (SELECT yearid, MAX(w) AS w
	  FROM teams
	  WHERE yearid > 1969
	  GROUP BY yearid) AS years INNER JOIN teams USING(yearid, w)
WHERE wswin IS NOT NULL;

-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
(SELECT teams.name AS team_name, park_name, 
 			homegames.attendance/homegames.games AS avg_attendance, 
 			'Top 5' AS attendance_rank
FROM homegames INNER JOIN parks USING(park)
			   LEFT JOIN teams ON (homegames.year=teams.yearid) AND (homegames.team=teams.teamid)
WHERE year = 2016
		AND games > 9
ORDER BY avg_attendance DESC
LIMIT 5)
UNION
(SELECT teams.name AS team_name, park_name, 
 			homegames.attendance/homegames.games AS avg_attendance, 
 			'Bottom 5' AS attendance_rank
FROM homegames INNER JOIN parks USING(park)
			   LEFT JOIN teams ON (homegames.year=teams.yearid) AND (homegames.team=teams.teamid)
WHERE year = 2016
		AND games > 9
ORDER BY avg_attendance 
LIMIT 5)
ORDER BY avg_attendance DESC;

-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
SELECT CONCAT(namefirst, ' ', namelast) AS coach_name, yearid AS year, teams.name AS team_name, awardid AS award
FROM awardsmanagers INNER JOIN people USING(playerid)
					INNER JOIN managers USING(playerid, yearid)
					LEFT JOIN teams USING(yearid, teamid)
WHERE awardid = 'TSN Manager of the Year' 
		AND playerid IN (SELECT DISTINCT playerid
				   		 FROM awardsmanagers
				   		 WHERE awardid = 'TSN Manager of the Year' 
						 	AND lgid = 'NL' 
						 	AND playerid IN (SELECT playerid
											 FROM awardsmanagers
											 WHERE awardid = 'TSN Manager of the Year'
											 AND lgid = 'AL'))
ORDER BY coach_name;



-- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.
WITH hr_2016 AS (SELECT playerid, SUM(hr) AS hr
			  FROM batting
			  WHERE yearid = 2016
			  GROUP BY playerid),
	hr_max_year AS (SELECT playerid, MAX(hr) AS hr
			   FROM (SELECT playerid, yearid, SUM(hr) As hr
					 FROM batting
					 GROUP BY playerid, yearid) AS hr_totals
			   GROUP BY playerid)

SELECT CONCAT(namefirst, ' ', namelast) AS player_name, MAX(hr_2016.hr) AS hr_2016
FROM hr_2016 INNER JOIN hr_max_year USING(playerid, hr)
			 LEFT JOIN batting USING(playerid)
			 INNER JOIN people USING(playerid)
WHERE hr_2016.hr > 0
GROUP BY namefirst, namelast
HAVING COUNT(CASE WHEN stint = 1 THEN playerid END) > 9
ORDER BY hr_2016 DESC;

-- **Open-ended questions**

-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

-- 12. In this question, you will explore the connection between number of wins and attendance.
-- a. Does there appear to be any correlation between attendance at home games and number of wins? </li>
-- b. Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.

-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?









