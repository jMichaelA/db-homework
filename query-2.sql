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