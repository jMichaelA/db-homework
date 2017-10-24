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

    