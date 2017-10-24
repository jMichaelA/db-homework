with ranking as (
    SELECT row_number() OVER (ORDER BY tw.wins desc) as rank, tw."teamID"
        FROM (
              SELECT sum(t."W") as wins, t."teamID"
                   FROM teams t
              WHERE t."yearID" >= 1970
              AND t."yearID" <= 1979
              GROUP BY "teamID"
             ) tw
)

SELECT DISTINCT t.name
    FROM ranking rk
    JOIN 
    (
        SELECT count(*)/2 as half FROM ranking
    ) cnt ON rk.rank = cnt.half
    JOIN teams t ON rk."teamID" = t."teamID"
WHERE t."yearID" >= 1970
AND t."yearID" <= 1979;