-- From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
-- What is the smallest number of wins for a team that did win the world series? 
-- Doing this will probably result in an unusually small number of wins for a world series champion – 
-- determine why this is the case. Then redo your query, excluding the problem year. 
-- How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?


--largest # wins without world series win
SELECT teamid, 
		w, 
		yearid,
		wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016 AND wswin = 'N'
GROUP BY teamid,w,yearid,wswin
ORDER BY w DESC;

--lowest # wins and win world series - 1981 basball had a strike
SELECT teamid, 
		w,
		yearid,
		wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016 AND wswin = 'Y'
GROUP BY teamid,w,yearid,wswin
ORDER BY w;

--removed 1981 strike year
SELECT teamid, 
		w,
		yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016 AND wswin = 'Y' AND yearid <> 1981
GROUP BY teamid,w,yearid
ORDER BY w;

--team with most wins AND won world series
--How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 

WITH teams_ws AS (SELECT DISTINCT yearid, MAX(w) AS highest_win_total, wswin
					FROM teams
					WHERE yearid BETWEEN 1970 AND 2016
					GROUP BY yearid, wswin
					ORDER BY yearid),
	max_win AS (SELECT yearid,
					MAX(w) AS highest_win_total
				FROM teams
				WHERE yearid BETWEEN 1970 AND 2016
				GROUP BY yearid
				ORDER BY yearid)
SELECT *
FROM teams_ws INNER JOIN max_win USING(yearid, highest_win_total)

--What percentage of the time?

WITH teams_ws AS (SELECT DISTINCT yearid, MAX(w) AS highest_win_total, wswin
					FROM teams
					WHERE yearid BETWEEN 1970 AND 2016
					GROUP BY yearid, wswin
					ORDER BY yearid),
	max_win AS (SELECT yearid,
					MAX(w) AS highest_win_total
				FROM teams
				WHERE yearid BETWEEN 1970 AND 2016
				GROUP BY yearid
				ORDER BY yearid)
SELECT ROUND(COUNT(CASE WHEN wswin = 'Y' THEN 1 END)::numeric/COUNT(wswin) * 100,0) AS most_regseason_wins_and_world_series_perct
FROM teams_ws INNER JOIN max_win USING(yearid, highest_win_total)
WHERE wswin IS NOT NULL
















SELECT teamid, 
yearid,
w AS reg_season_wins,
wswin AS world_series_wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid,wswin,teamid,w
ORDER BY yearid,w DESC

WITH teams_most_wins AS (SELECT teamid, 
yearid,
w AS reg_season_wins,
wswin AS world_series_wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid,wswin,teamid,w
ORDER BY yearid,w DESC)

SELECT DISTINCT yearid, MAX(w)
FROM teams_most_wins

46 years total
