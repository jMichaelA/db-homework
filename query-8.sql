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