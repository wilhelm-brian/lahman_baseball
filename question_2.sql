--Q2: Find the name and height of the shortest player in the database. How many games did he play in?
	--What is the name of the team for which he played?
SELECT*
FROM people;

SELECT namegiven, height, teams.name, g_all AS num_games_played
FROM people INNER JOIN appearances USING(playerid)
			INNER JOIN teams USING(teamid)
ORDER BY height ASC
LIMIT 1;
--Edward Carl, height 43 in. He played exactly 1 game, with the St. Louis Browns.

SELECT*
FROM appearances;