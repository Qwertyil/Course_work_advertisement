call report${number}_creator(${year}, ${month});


/*
delimiter //

CREATE procedure report1_creator (in yearr int, in monthh int)
begin
 declare amount_of_reports int;
 declare amount_of_records int;

 select count(*) into amount_of_reports
    from report1
    where report_year = yearr and report_month = monthh;

 select count(*) into amount_of_records
	FROM
		invoice inv
	INNER JOIN
		invoice_line il ON inv.id_invoice = il.id_invoice
	INNER JOIN
		piece dt ON il.id_piece = dt.id_piece
	WHERE
		MONTH(inv.invoice_date) = monthh AND YEAR(inv.invoice_date) = yearr;

  if amount_of_reports > 0 then
	select 'report already exists' as message;

  elseif amount_of_records = 0 then
	select 'nothing to create a report from' as message;

  else
	insert into report1
	SELECT
		yearr,
		monthh,
		dt.id_piece,
		dt.name AS detail_name,
		SUM(il.count) AS total_quantity,
		SUM(il.count * dt.price) AS total_price
	FROM
		invoice inv
	INNER JOIN
		invoice_line il ON inv.id_invoice = il.id_invoice
	INNER JOIN
		piece dt ON il.id_piece = dt.id_piece
	WHERE
		MONTH(inv.invoice_date) = monthh AND YEAR(inv.invoice_date) = yearr
	GROUP BY
		dt.id_piece, dt.name
	ORDER BY
		dt.id_piece;

	select 'report successfully created' as message;

    end if;
end //

delimiter ;
*/