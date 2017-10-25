-- Query 1: LA Dodgers
--List the first name and last name of every player 
--that has played at any time in their career for the
--Los Angeles Dodgers. List each player only once. 


SELECT DISTINCT "nameFirst" "First Name", LOWER("nameLast") "Last Name"
FROM master m
        JOIN appearances a ON m."masterID" = a."masterID"
        JOIN teams t ON t."teamID" = a."teamID" 
WHERE t."name" = 'Los Angeles Dodgers'
ORDER BY LOWER("nameLast"), "nameFirst" ASC



--Query 2: LA Dodgers Only
-- List the first name and last name of every player 
--that has played only for the Los Angeles Dodgers 
--(i.e., they did not play for any other team including 
--the Brooklyn Dodgers, note that the Brooklyn Dodgers 
--became the Los Angeles Dodgers in the 1950s). 
--List each player only once.


with dodger_player as (
        SELECT m."masterID", m."nameFirst", m."nameLast", t.name
        FROM master m
            JOIN appearances a ON m."masterID" = a."masterID"
            JOIN teams t ON t."yearID" = a."yearID" AND t."teamID" = a."teamID"
        WHERE t.name = 'Los Angeles Dodgers'
),
multi_player as (
        SELECT dp.*, t.name
        FROM dodger_player dp
            JOIN master m ON dp."masterID" = m."masterID"
            JOIN appearances a ON m."masterID" = a."masterID"
            JOIN teams t ON a."teamID" = t."teamID" AND a."yearID" = t."yearID"
        WHERE t.name != 'Los Angeles Dodgers'
        ORDER BY dp."nameLast"
)
SELECT DISTINCT dp."nameFirst", dp."nameLast"
FROM dodger_player dp
    LEFT JOIN multi_player mp ON dp."masterID" = mp."masterID"
WHERE mp."masterID" IS NULL
ORDER BY dp."nameLast"
;



--Query 3: Expos Pitchers 
-- List the first name and last name of every player 
--that has pitched for the team named the 
--"Montreal Expos". List each player only once.


SELECT DISTINCT "nameFirst", "nameLast" 
FROM master m
        JOIN pitching p ON p."masterID" = m."masterID"
        JOIN teams t ON t."teamID" = p."teamID" 
WHERE p."teamID" = 'MON'
ORDER BY "nameLast", "nameFirst" ASC 



--Query 4: Error Kings - List the name of the team, year,
-- and number of errors (the number is the "E" column in 
--the "teams" table) for every team that has had 160 or 
--more errors in a season.


SELECT t.name, t."yearID", t."E"
FROM teams t
WHERE t."E" >= 160
;



--Query 5: USU batters - List the first name, last name,
-- year played, and batting average (h/ab) of every player 
--from the school named "Utah State University".


WITH "Average" AS (
        SELECT "yearID", b."masterID", 
        CASE WHEN (b."AB" >= 1) AND (b."H" = 0) THEN ROUND (('0')::DECIMAL, 4)
             WHEN (b."AB" > 1) AND (b."H" > 0) THEN ROUND ((b."H")  / (b."AB")::DECIMAL, 4)   END AS "aver" 
        FROM batting b 
        )

SELECT DISTINCT a."aver" "Average", "H" "Hits", "AB" "At Bats","nameFirst" "First Name", "nameLast" "Last Name", b."yearID" "Year" 
        FROM schools s
        JOIN schoolsplayers sp ON sp."schoolID" = s."schoolID"
        JOIN master m ON m."masterID" = sp."masterID"
        JOIN batting b ON b."masterID" = sp."masterID"
        JOIN "Average" a ON a."masterID" = b."masterID"
        JOIN "Average" ON a."yearID" =  b."yearID"
WHERE s."schoolName" = 'Utah State University' AND "AB" >= 0 
ORDER BY b."yearID","nameLast", a."aver", "H", "AB","nameFirst"



--Query 6: Yankee Run Kings - List the name, year, and 
--number of home runs hit for each New York Yankee batter,
-- but only if they hit the most home runs for any 
--player in that season. 


SELECT m."nameFirst", m."nameLast", t."yearID" as year, hr.hr as home_runs
    FROM master m
    JOIN batting b ON m."masterID" = b."masterID"
    JOIN teams t ON b."teamID" = t."teamID" AND b."yearID" = t."yearID"
    JOIN         
    (
        SELECT max(b."HR") OVER (PARTITION BY b."yearID") as hr, b."yearID", b."masterID"
            FROM batting b 
        GROUP BY b."HR", b."yearID", b."masterID"
        
    ) hr ON b."yearID" = hr."yearID" AND b."masterID" = hr."masterID" AND hr.hr = b."HR"  
WHERE t.name = 'New York Yankees'
ORDER BY b."yearID"
;



--Query 7: Bumper Salary Teams - List the total salary 
--for two consecutive years, team name, and year for every 
--team that had a total salary which was 1.5 times as much 
--as for the previous year.


with sal as (
        SELECT "teamID", "yearID", "lgID", sum(salary) as sal_sum
            FROM salaries
        GROUP BY "teamID", "yearID", "lgID"
),
consec as (
    SELECT s1."teamID", s1."yearID" as prev_year, s1."lgID", s1.sal_sum as prev_sal, s2."yearID", s2.sal_sum, (floor(s2.sal_sum/s1.sal_sum*100))::int as percent
        FROM sal s1
        JOIN sal s2 ON s1."teamID" = s2."teamID" AND s1."lgID" = s2."lgID" AND s1."yearID" = s2."yearID"-1
)
SELECT DISTINCT t.name, c.prev_year, c.prev_sal, c."yearID", c.sal_sum, c.percent
    FROM consec c
    JOIN teams t ON c."teamID" = t."teamID" AND c.prev_year = t."yearID"
WHERE c.percent > 149
ORDER BY c.prev_year, name
;


--Query 8: Montreal Expos Three - List the first name 
--and last name of every player that has batted for the 
--Montreal Expos in at least three consecutive years. 
--List each player only once. 


with mont_ply as (
    SELECT m."masterID", b."yearID" as year
        FROM master m
        JOIN batting b ON m."masterID" = b."masterID"
        JOIN teams t ON b."teamID" = t."teamID" AND b."yearID" = t."yearID"
    WHERE t.name = 'Montreal Expos'
)

SELECT DISTINCT m."nameFirst", m."nameLast"
    FROM master m
    JOIN mont_ply mp1 ON m."masterID" = mp1."masterID"
    JOIN mont_ply mp2 ON mp1."masterID" = mp2."masterID"
    JOIN mont_ply mp3 ON mp1."masterID" = mp3."masterID"
WHERE mp1.year = (mp2.year - 1)
    AND mp1.year = (mp3.year - 2)
ORDER BY m."nameLast", m."nameLast"
;



--Query 9: Home Run Kings - List the first name, 
--last name, year, and number of HRs of every player 
--that has hit the most home runs in a single season. 
--Order by the year. Note that the "batting" table has
--a column "HR" with the number of home runs hit by
--a player in that year. 


SELECT  rk."yearID" "Year", rk."nameFirst" "First Name", rk."nameLast" "Last Name", rk."HR" "Home Runs" 
   FROM (
        SELECT m."nameFirst", m."nameLast", b."HR", b."yearID", dense_rank() OVER (PARTITION BY b."yearID" ORDER BY b."HR" desc) as rank
            FROM master m
            JOIN batting b ON m."masterID" = b."masterID"
        WHERE b."HR" IS NOT NULL
        GROUP BY b."HR", b."yearID", m."nameLast", m."nameFirst"
   ) as rk
   WHERE rk.rank = 1
   ORDER BY rk."yearID", rk."nameLast", rk."nameFirst"
 ;
 

--Query 10: Third best home runs each year - List 
--the first name, last name, year, and number of HRs
--of every player that hit the third most home runs for 
--that year. Order by the year.


SELECT  rk."nameFirst", rk."nameLast", rk."yearID", rk."HR", rk."rank"
   FROM (
        SELECT m."nameFirst", m."nameLast", b."HR", b."yearID", dense_rank() OVER (PARTITION BY b."yearID" ORDER BY b."HR" desc) as rank
            FROM master m
            JOIN batting b ON m."masterID" = b."masterID"
        WHERE b."HR" IS NOT NULL
        GROUP BY b."HR", b."yearID", m."nameLast", m."nameFirst"
   ) as rk
   WHERE rk.rank = 3
   ORDER BY rk."yearID", rk."nameLast", rk."nameFirst"
 ;
 
 

--Query 11: Triple happy team mates - List the team name,
--year, names of player, the number of triples hit 
--(column "3B" in the batting table), in which two 
--or more players on the same team hit 10 or more triples each. 




--Query 12: Ranking the teams - Rank each team in terms of 
--the winning percentage (wins divided by (wins + losses)) 
--over its entire history. Consider a "team" to be a team
--with the same name, so if the team changes name, it is 
--considered to be two different teams. Show the team name, 
--win percentage, and the rank. 


SELECT perc.name, rank() OVER (ORDER BY perc.percentage desc) as rank, perc.percentage, perc.wins, perc.losses 
FROM (
    SELECT wl.name, round(wl.wins::numeric/(wl.losses::numeric + wl.wins::numeric), 4) as percentage, wl.wins, wl.losses
    FROM (
        SELECT t.name, sum(t."W") as wins, sum(t."L") as losses
            FROM teams t
        GROUP BY t.name
        ) wl
    ) perc
ORDER BY percentage desc



--Query 13: Pitchers for Mangaer Casey Stengel - List the 
--year, first name, and last name of each pitcher who was 
--a on a team managed by Casey Stengel (pitched in the 
--same season on a team managed by Casey). 


with casey as (
    SELECT mn."yearID", mn."teamID", ms."nameFirst", ms."nameLast"
        FROM managers mn
        JOIN master ms ON ms."masterID" = mn."masterID"
    WHERE ms."nameFirst" = 'Casey'
    AND ms."nameLast" = 'Stengel'
)

SELECT DISTINCT t.name, c."yearID", m."nameFirst", m."nameLast", c."nameFirst", c."nameLast"
   FROM pitching p
   JOIN casey c ON p."teamID" = c."teamID" AND p."yearID" = c."yearID"
   JOIN teams t ON c."teamID" = t."teamID" AND c."yearID" = t."yearID"
   JOIN master m ON p."masterID" = m."masterID"
ORDER BY c."yearID", t.name, m."nameLast", m."nameFirst" 
    
;



--Query 14: Two degrees from Yogi Berra - List the name 
--of each player who appeared on a team with a player 
--that was at one time was a teamate of Yogi Berra. So 
--suppose player A was a teamate of Yogi Berra. Then player 
--A is one-degree of separation from Yogi Berra. Let player 
--B be related to player A because A played on a team in
--the same year with player A. Then player A is two-degrees 
--of separation from player A. 


with yogi as (
    SELECT t."teamID", t."yearID", m."masterID"
        FROM master m
        JOIN appearances a ON m."masterID" = a."masterID"
        JOIN teams t ON a."teamID" = t."teamID" AND a."yearID" = t."yearID"
    WHERE m."nameFirst" = 'Yogi' 
    AND m."nameLast" = 'Berra'
),
degree_sep as (
    SELECT t."teamID", t."yearID", m."masterID"
        FROM master m
        JOIN appearances a ON m."masterID" = a."masterID"
        JOIN teams t ON a."teamID" = t."teamID" AND a."yearID" = t."yearID"
        JOIN (
              SELECT DISTINCT m."masterID"
              FROM master m
              JOIN appearances a ON m."masterID" = a."masterID"
              JOIN teams t ON a."teamID" = t."teamID" AND a."yearID" = t."yearID"
              JOIN yogi y ON t."teamID" = y."teamID" AND t."yearID" = y."yearID" AND m."masterID" != y."masterID"
        ) yt ON m."masterID" = yt."masterID"
)

SELECT DISTINCT m."nameFirst", m."nameLast"
    FROM master m
    JOIN appearances a ON m."masterID" = a."masterID"
    JOIN teams t ON a."teamID" = t."teamID" AND a."yearID" = t."yearID"
    JOIN degree_sep ds ON t."teamID" = ds."teamID" AND t."yearID" = ds."yearID" AND m."masterID" != ds."masterID"
    LEFT JOIN yogi y ON t."teamID" = y."teamID" AND t."yearID" = y."yearID" AND m."masterID" = y."masterID"
WHERE y.* IS NULL
ORDER BY m."nameLast", m."nameFirst";



--Query 15: Median team wins - For the 1970s, list the team 
--name for teams in the National League ("NL") that had the 
--median number of total wins in the decade (1970-1979 inclusive). 


with ranking as (
    SELECT row_number() OVER (ORDER BY tw.wins desc) as rank, tw."teamID"
        FROM (
              SELECT sum(t."W") as wins, t."teamID", t."lgID"
                   FROM teams t
              WHERE t."yearID" >= 1970
              AND t."yearID" <= 1979
              AND t."lgID" = 'NL'
              GROUP BY "teamID", t."lgID"
             ) tw
)

SELECT DISTINCT t.name, rk.rank -1 as rank
    FROM ranking rk
    JOIN 
    (
        SELECT CASE WHEN (count(*)%2=0) THEN count(*)/2+1 ELSE COUNT(*)/2 END as half FROM ranking
    ) cnt ON rk.rank = cnt.half
    JOIN teams t ON rk."teamID" = t."teamID"
WHERE t."yearID" >= 1970
AND t."yearID" <= 1979;

