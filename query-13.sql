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
    