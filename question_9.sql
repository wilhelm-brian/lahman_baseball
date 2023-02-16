--Q9: Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)?
	--Give their full name and the teams that they were managing when they won the award.

WITH award_winners AS (SELECT playerid, yearid, lgid AS league
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year' AND lgid = 'AL'
	AND playerid IN
			(SELECT playerid
			FROM awardsmanagers
			WHERE awardid = 'TSN Manager of the Year' AND lgid = 'NL')
UNION		
SELECT playerid, yearid, lgid AS league
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year' AND lgid = 'NL'
	AND playerid IN
			(SELECT playerid
			FROM awardsmanagers
			WHERE awardid = 'TSN Manager of the Year' AND lgid = 'AL'))
SELECT namegiven, name, award_winners.yearid, league
FROM award_winners LEFT JOIN people USING(playerid)
 				   LEFT JOIN managers USING(playerid, yearid)
 				   LEFT JOIN teams USING(teamid, yearid);
