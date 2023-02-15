--Question 4

WITH player_category_table AS (SELECT playerid, pos,po, yearid,
												CASE WHEN pos = 'OF' THEN 'Outfield'
												WHEN pos = 'SS' OR pos= '1B' OR pos = '2B' OR pos = '3B' THEN 'Infield'
												WHEN pos = 'P' OR pos = 'C' THEN 'Battery' END AS player_category
								FROM fielding
								WHERE yearid = 2016)
SELECT player_category,
		SUM(po) AS total_po
FROM player_category_table
GROUP BY player_category;


	