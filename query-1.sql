SELECT DISTINCT "nameFirst", "nameLast" 
FROM master m
        JOIN appearances a ON m."masterID" = a."masterID"
        JOIN teams t ON t."teamID" = a."teamID" 
WHERE t."name" = 'Los Angeles Dodgers'
ORDER BY "nameLast", "nameFirst" ASC