SELECT DISTINCT "nameFirst" "First Name", LOWER("nameLast") "Last Name"
FROM master m
        JOIN appearances a ON m."masterID" = a."masterID"
        JOIN teams t ON t."teamID" = a."teamID" 
WHERE t."name" = 'Los Angeles Dodgers'
ORDER BY LOWER("nameLast"), "nameFirst" ASC
