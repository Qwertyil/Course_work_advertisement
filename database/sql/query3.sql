SELECT r.Name AS RentorName, COUNT(o.id_order) AS OrderCount
FROM rentor r
LEFT JOIN `order` o ON r.id_rentor = o.Rentor
WHERE year(o.Date) = ${year} AND month(o.Date) = ${month}
GROUP BY r.id_rentor
ORDER BY OrderCount DESC;
