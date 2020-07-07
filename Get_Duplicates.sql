/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	distinct
	dev.serial_no
	,lot.misc_2
	,lot.misc_16
	--,mast.lot_no
	--,mast.cust_no
	--,mast.cust_sequence
	--,hist.[cust_no]
	--,hist.[cust_sequence]
	--,hist.[read_dt]
	--,hist.[reading]
	--,hist.[consumption]
	--,hist.[reading_period]
	--,hist.[reading_year]
	,lot.street_name
	,replicate('0', 6 - len(mast.cust_no)) + cast (mast.cust_no as varchar)+ '-'+replicate('0', 3 - len(mast.cust_sequence)) + cast (mast.cust_sequence as varchar) as AccountNum
--into #temporaryCounter
  FROM [Springbrook0].[dbo].[ub_meter_hist] hist
  inner join
	ub_meter_con con
	on hist.ub_meter_con_id = con.ub_meter_con_id
  inner join
	ub_master mast
	on mast.cust_no = hist.cust_no 
	and mast.cust_sequence = hist.cust_sequence
  inner join
	ub_device dev
	on con.ub_device_id = dev.ub_device_id
  inner join
	lot 
	on lot.lot_no = mast.lot_no
  where
	hist.reading_year = 2018
	and convert(date, hist.read_dt) between '12/1/2018' and '12/31/2018'
	and hist.reading_period = 12
	--and year(con.install_date) < 2019
	--and (lot.street_name like '%hyd%' or lot.street_directional like '%hyd%')

	GROUP BY 
		dev.serial_no,
		lot.misc_2,
		lot.misc_16,
		replicate('0', 6 - len(mast.cust_no)) + cast (mast.cust_no as varchar)+ '-'+replicate('0', 3 - len(mast.cust_sequence)) + cast (mast.cust_sequence as varchar),
		lot.street_name
	having
	count(dev.serial_no) > 1
	order by
dev.serial_no asc