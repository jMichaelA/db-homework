SELECT perc.name, rank() OVER (ORDER BY perc.percentage desc) as rank, perc.percentage, perc.wins, perc.losses 
FROM (
    SELECT wl.name, round(wl.wins::numeric/(wl.losses::numeric + wl.wins::numeric), 4) as percentage, wl.wins, wl.losses
    FROM (
        SELECT t.name, sum(t."W") as wins, sum(t."L") as losses
            FROM teams t
        GROUP BY t.name
        ) wl
    ) perc
ORDER BY percentage desc