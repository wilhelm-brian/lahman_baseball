-- Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.


WITH all_players AS (SELECT DISTINCT playerid,
									namefirst AS first_name,
									namelast AS last_name,
									COUNT(DISTINCT yearid) AS years_played,
									MAX(hr) AS max_hr_total
						FROM batting INNER JOIN people USING(playerid)
						GROUP BY playerid, namefirst, namelast
						HAVING COUNT(DISTINCT yearid) > 9),
	players_2016 AS (SELECT playerid, SUM(hr) AS max_hr_total
						FROM batting
						WHERE yearid = 2016
						GROUP BY playerid)
SELECT first_name,
		last_name,
		max_hr_total
FROM players_2016 INNER JOIN all_players USING(playerid, max_hr_total)
WHERE max_hr_total > 0
ORDER BY max_hr_total DESC







