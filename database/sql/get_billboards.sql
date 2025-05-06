SELECT
    b.id_billboard,
    b.Price * datediff('${end}', '${start}'),
    b.Size,
    b.Address,
    b.Quality
FROM
    billboard b
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            string s
        WHERE
            s.Billboard = b.id_billboard
            AND (
                (s.Date_start between '${start}' and '${end}' or
                s.Date_end between '${start}' and '${end}' or
                s.Date_start >= '${start}' and s.Date_end >= '${end}')
            )
    );
