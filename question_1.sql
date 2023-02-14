--Checked multiple tables for min and max years

SELECT MIN(yearid)
FROM batting;
--ANSWER 1871

SELECT MAX(yearid)
FROM batting;
--ANSWER 2016

SELECT MIN(yearid)
FROM pitching;
--ANSWER 1871

SELECT MAX(yearid)
FROM pitching;
--ANSWER 2016