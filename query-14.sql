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