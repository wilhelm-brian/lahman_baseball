--Q12: In this question, you will explore the connection between number of wins and attendance.
	--Does there appear to be any correlation between attendance at home games and number of wins?
SELECT yearid,
			teamid,
			w AS wins,
			attendance AS home_attendance,
			DENSE_RANK()OVER(PARTITION BY yearid ORDER BY w DESC) AS wins_rank,
			DENSE_RANK()OVER(PARTITION BY yearid ORDER BY attendance DESC) AS attendance_rank
FROM teams
WHERE attendance IS NOT NULL;

	--Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs?
--world series winners attendance:
WITH attendance_years AS (SELECT yearid, teamid, attendance
						  FROM teams
						  WHERE attendance IS NOT NULL)
SELECT teamid, attendance_years.yearid AS next_year, teams.yearid AS win_year,
	   teams.attendance AS win_attendance,
	   attendance_years.attendance AS next_year_attendance
FROM attendance_years LEFT JOIN teams USING(teamid)
WHERE wswin = 'Y'
	  AND teams.yearid+1 = attendance_years.yearid
ORDER BY win_year ASC

	--Making the playoffs means either being a division winner or a wild card winner.
--playoffs winner attendance:

(WITH attendance_years AS (SELECT yearid, teamid, attendance
						  FROM teams
						  WHERE attendance IS NOT NULL)
SELECT teamid, attendance_years.yearid AS next_year, teams.yearid AS win_year,
	   teams.attendance AS win_attendance,
	   attendance_years.attendance AS next_year_attendance
FROM attendance_years LEFT JOIN teams USING(teamid)
WHERE divwin = 'Y'
	  AND teams.yearid+1 = attendance_years.yearid)
UNION
(WITH attendance_years AS (SELECT yearid, teamid, attendance
						  FROM teams
						  WHERE attendance IS NOT NULL)
SELECT teamid, attendance_years.yearid AS next_year, teams.yearid AS win_year,
	   teams.attendance AS win_attendance,
	   attendance_years.attendance AS next_year_attendance
FROM attendance_years LEFT JOIN teams USING(teamid)
WHERE wcwin = 'Y'
	  AND teams.yearid+1 = attendance_years.yearid)
ORDER BY win_year ASC
