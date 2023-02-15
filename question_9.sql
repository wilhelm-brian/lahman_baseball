--Q9: Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)?
	--Give their full name and the teams that they were managing when they won the award.
--tables: awardsmanagers, managers

SELECT*
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year'
	AND lgid <> 'ML'

SELECT *
FROM awardsmanagers AS am1 INNER JOIN awardsmanagers AS am2 USING(playerid)
WHERE am1.awardid = 'TSN Manager of the Year' AND am2.awardid = 'TSN Manager of the Year'
	  AND am1.lgid <> am2.lgid
	  AND am1.lgid <> 'ML'
	  AND am2.lgid <> 'ML';



SELECT playerid, yearid, lgid
FROm awardsmanagers
WHERE awardid = 'TSN Manager of the Year';


SELECT am1.playerid, am1.yearid, am2.yearid, am1.lgid, am2.lgid
FROM awardsmanagers AS am1 INNER JOIN awardsmanagers AS am2 USING(playerid)
WHERE am1.awardid = 'TSN Manager of the Year' AND am2.awardid = 'TSN Manager of the Year'
	  AND am1.lgid <> am2.lgid
	  AND am1.lgid <> 'ML'
	  AND am2.lgid <> 'ML';
--find a way to eliminate duplicates
--team name of the exact year they received the awards

WITH duplicates AS (SELECT am1.playerid, am1.yearid AS year1, am2.yearid AS year2, am1.lgid, am2.lgid
FROM awardsmanagers AS am1 INNER JOIN awardsmanagers AS am2 USING(playerid)
WHERE am1.awardid = 'TSN Manager of the Year' AND am2.awardid = 'TSN Manager of the Year'
	  AND am1.lgid <> am2.lgid
	  AND am1.lgid <> 'ML'
	  AND am2.lgid <> 'ML')
SELECT DISTINCT namegiven --teams.name
FROM duplicates INNER JOIN people USING(playerid)
				INNER JOIN managers USING(playerid)
				INNER JOIN teams USING(teamid);
-- WHERE duplicates.year1 = 2006 OR duplicates.year1 = 1997;

SELECT*
FROM managers


SELECT*
FROM people

SELECT*
FROM awardsmanagers;