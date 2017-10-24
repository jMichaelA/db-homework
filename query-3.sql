SELECT DISTINCT "nameFirst", "nameLast" 
FROM master m
        JOIN pitching p ON p."masterID" = m."masterID"
        JOIN teams t ON t."teamID" = p."teamID" 
WHERE p."teamID" = 'MON'
ORDER BY "nameLast", "nameFirst" ASC 