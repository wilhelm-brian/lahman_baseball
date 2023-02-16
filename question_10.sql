-- Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.


--List of ALL players with number of seasons played and highest HR total in a season--
WITH all_players AS (SELECT DISTINCT playerid,
							COUNT(playerid)OVER(PARTITION BY playerid) AS num_seasons_played,
							MAX(hr)OVER(PARTITION BY playerid) AS hr
					FROM batting
					ORDER BY hr DESC),
--List of ALL players (2016) and HR total 
	players_2016 AS (SELECT DISTINCT playerid,
								namefirst,
								namelast,
								SUM(hr) AS hr
					FROM batting INNER JOIN people USING(playerid)
					WHERE yearid = 2016
 							AND hr > 0
					GROUP BY playerid, namefirst, namelast
					ORDER BY hr DESC)
--JOINED both CTE having them match on both playerid AND hr 
SELECT namefirst AS first_name,
		namelast AS last_name,
		players_2016.hr AS hr_total_2016	
FROM players_2016 LEFT JOIN all_players USING(playerid, hr)
WHERE num_seasons_played > 9;


SELECT DISTINCT playerid,
			COUNT(DISTINCT yearid) AS num_seasons_played,
			MAX(hr) AS hr
FROM batting
GROUP BY playerid
ORDER BY hr DESC;

SELECT DISTINCT playerid,
			namefirst AS first_name,
			namelast AS last_name,
			COUNT(DISTINCT yearid) AS years_played,
			MAX(hr) AS max_hr_total
FROM batting INNER JOIN people USING(playerid)
GROUP BY playerid, namefirst, namelast
HAVING COUNT(DISTINCT yearid) > 9;


SELECT playerid, SUM(hr)
FROM batting
WHERE yearid = 2016
GROUP BY playerid;


SELECT *
FROM batting INNER JOIN people USING(playerid);



