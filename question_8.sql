-- Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.


--Top 5 Parks in Attendance(2016)
(SELECT park_name,
		team,
		attendance/games AS avg_attendance_per_game,
		'top 5' AS stadium_attendance_rank_2016
FROM homegames INNER JOIN parks USING(park)
WHERE year = 2016
	AND games >= 10
ORDER BY avg_attendance_per_game DESC
LIMIT 5)
UNION
--Combining with Bottom 5 Parks in Attendance(2016)
(SELECT park_name,
		team,
		attendance/games AS avg_attendance_per_game,
		'bottom 5' AS stadium_attendance_rank_2016
FROM homegames INNER JOIN parks USING(park)
WHERE year = 2016
	AND games >= 10
ORDER BY avg_attendance_per_game 
LIMIT 5)
ORDER BY avg_attendance_per_game DESC;
