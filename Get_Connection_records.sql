/*  
	get the devices by Category
	conditions:
		- the read year should be 2019
		- the read period should be for 12
		- the device should be counted once if
			its the same SN and street even its for diff accts
		- its a new count if the same SN gets a hit on a different category

	we will be storing the results in a temporary table called '#tempDeviceCountByCat'
*/
SELECT 
	distinct
	--dev.serial_no as SerialNumber
	case 
		when ltrim(lot.misc_2) = null or ltrim(lot.misc_2) = '' then 'Unknown'
		else
			ltrim(lot.misc_2) 
	end
	as ST_Category
	--,mast.lot_no
	--,mast.cust_no
	--,mast.cust_sequence
	--,hist.[cust_no]
	--,hist.[cust_sequence]
	--,hist.[reading]
	--,hist.[consumption]
	--,hist.[reading_period]
	--,hist.[reading_year]
	--,replicate('0', 6 - len(mast.cust_no)) + cast (mast.cust_no as varchar)+ '-'+replicate('0', 3 - len(mast.cust_sequence)) + cast (mast.cust_sequence as varchar) as AccountNum
	--,hist.[read_dt]
	,ltrim(cast(lot.street_number as varchar)) + ' ' + ltrim(lot.street_name) as Address
	,1 as count
	--into #address2019
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
	--hist.reading_year = 2020
	--and convert(date, hist.read_dt) between '1/1/2020' and '05/31/2020'
	--con.con_status = 'Active'
	--and hist.reading_period = 12
	(
			year(con.install_date)<=2019
			or (year(con.install_date) is null 
			or year(con.install_date) = 9999)
		)
	--and ltrim(cast(lot.street_number as varchar)) + ' ' + ltrim(lot.street_name) not in (
	--	select Address from #address2019
	--)
	-- REGULAR CONNECTIONS
	and (
		lot.street_name not like '%hyd%' 
		and lot.street_directional not like '%hyd%' 
		and lot.addr_2 not like 'hyd%' 
		and lot.street_name not like '%irr%' 
		and lot.street_directional not like '%irr%' 
		and lot.addr_2 not like '%irrigation%' 
		and lot.misc_16 not like '%irr%'
	)
	-- HYDRANTS
	--and (
	--	lot.street_name like '%hyd%' 
	--	or lot.street_directional like '%hyd%' 
	--	or lot.addr_2 like 'hyd%' 
	--	or  lot.misc_16 like '%hyd%'
	--)
	-- IRRIGATION
	--and (
	--	lot.street_name like '%IRR%' 
	--	or lot.street_directional like '%IRR%' 
	--	or lot.addr_2 like 'IRR%' 
	--	or  lot.misc_16 like '%IRR%'
	--)

	--and lot.lot_no='012728'
	--and ltrim(cast(lot.street_number as varchar)) + ' ' + ltrim(lot.street_name) = '181 Paddon Place'
	--and mast.cust_no = 13280
order by
	ltrim(cast(lot.street_number as varchar)) + ' ' + ltrim(lot.street_name)


--select * from #Address2019 where Address = '181 Paddon Place - 101'
--drop table #Address2019