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