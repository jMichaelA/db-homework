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