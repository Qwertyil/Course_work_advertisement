SELECT r.*
FROM rentor r
JOIN `order` o ON r.id_rentor = o.Rentor
WHERE year(o.Date) = ${year} AND month(o.Date) = ${month};