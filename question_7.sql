-- From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
-- What is the smallest number of wins for a team that did win the world series? 
-- Doing this will probably result in an unusually small number of wins for a world series champion – 
-- determine why this is the case. Then redo your query, excluding the problem year. 
-- How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?




--largest # wins without world series win
SELECT teamid, 
		w, 
		yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016 AND wswin = 'N'
GROUP BY teamid,w,yearid
ORDER BY w DESC;

--lowest # wins and win world series - 1981 basball had a strike
SELECT teamid, 
		w,
		yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016 AND wswin = 'Y'
GROUP BY teamid,w,yearid
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
--What percentage of the time?

SELECT teamid,w,yearid,wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY teamid,w,yearid,wswin
ORDER BY yearid,w DESC

46 years total
