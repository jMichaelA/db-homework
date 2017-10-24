with sal as (
        SELECT "teamID", "yearID", "lgID", sum(salary) as sal_sum
            FROM salaries
        GROUP BY "teamID", "yearID", "lgID"
),
consec as (
    SELECT s1."teamID", s1."yearID" as prev_year, s1."lgID", s1.sal_sum as prev_sal, s2."yearID", s2.sal_sum, (floor(s2.sal_sum/s1.sal_sum*100))::int as percent
        FROM sal s1
        JOIN sal s2 ON s1."teamID" = s2."teamID" AND s1."lgID" = s2."lgID" AND s1."yearID" = s2."yearID"-1
)
SELECT DISTINCT t.name, c.prev_year, c.prev_sal, c."yearID", c.sal_sum, c.percent
    FROM consec c
    JOIN teams t ON c."teamID" = t."teamID" AND c.prev_year = t."yearID"
WHERE c.percent > 149
ORDER BY c.prev_year, name
;

