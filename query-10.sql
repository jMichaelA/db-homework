

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
