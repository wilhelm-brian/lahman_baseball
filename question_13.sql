-- It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?

--Number of pitchers (right handed compared to left handed)
SELECT COUNT(CASE WHEN throws = 'R' THEN 1 END) AS right_handed,
		COUNT(CASE WHEN throws = 'L' THEN 1 END) AS left_handed
FROM pitching LEFT JOIN people USING(playerid)
WHERE throws IS NOT NULL;


--Winners of CY YOUNG award (right handed compared to left handed)
SELECT ROUND(COUNT(CASE WHEN throws = 'R' THEN 1 END)::numeric/COUNT(*) * 100,2) AS perc_right_handed_winners,
		ROUND(COUNT(CASE WHEN throws = 'L' THEN 1 END)::numeric/COUNT(*) * 100, 2) AS perc_left_handed_winners
FROM awardsplayers LEFT JOIN people USING(playerid)
WHERE awardid ILIKE '%cy young%';


--HOF Pitchers (right handed cmompared to left handed)
WITH hof_pitchers AS (SELECT Distinct playerid, namefirst AS first_name, namelast AS name_last, throws
						FROM pitching INNER JOIN halloffame USING(playerid)
									INNER JOIN people USING(playerid)
						GROUP BY playerid, namefirst, namelast, throws
						HAVING SUM(ipouts) >= 27)
SELECT ROUND(COUNT(CASE WHEN throws = 'R' THEN 1 END)::numeric/COUNT(*) * 100,2) AS perc_right_handed_hof,
		ROUND(COUNT(CASE WHEN throws = 'L' THEN 1 END)::numeric/COUNT(*) * 100, 2) AS perc_left_handed_hof
FROM hof_pitchers;



SELECT throws,
		ROUND(SUM(w)::numeric/(SUM(w)+SUM(l)),3)*100 AS win_perc
FROM pitching INNER JOIN people USING(playerid)
WHERE throws IN ('L', 'R')
GROUP BY throws


