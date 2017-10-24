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
