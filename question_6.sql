-- Q7. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.


--List of ALL players (2016) with at least 20 Stolen Base ATTEMPTS
WITH players_2016 AS (SELECT DISTINCT playerid,	
									SUM(sb) AS stolen_bases,
									SUM(cs) AS caught_stealing,
					  				(sb+cs) AS total_sb_attempts
						FROM batting 
						WHERE yearid = 2016
						GROUP BY playerid, cs, sb
						HAVING (cs + sb) >= 20)
--JOINING with people table to get name information
SELECT namefirst AS first_name,
		namelast AS last_name,
		ROUND(stolen_bases::numeric/total_sb_attempts::numeric, 2) * 100 AS perc_successful_sb
FROM players_2016 LEFT JOIN people USING(playerid)
ORDER BY perc_successful_sb DESC;

--Chris Owings had highest stolen base success rate at 91% 







