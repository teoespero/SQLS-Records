/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	distinct
    bill.[cust_no],
    bill.[cust_sequence],
	case 
		when ltrim(lot.misc_2) = null or ltrim(lot.misc_2) = '' then 'Unknown'
		else
			ltrim(lot.misc_2) 
	end
	as ST_Category
FROM [Springbrook0].[dbo].[ub_bill_detail] bill
inner join 
	[Springbrook0].[dbo].[ub_master] mast
	on mast.cust_no = bill.cust_no
	and mast.cust_sequence = bill.cust_sequence
inner join
	[Springbrook0].[dbo].[lot] lot
	on lot.lot_no = mast.lot_no
where
  service_code in ('WF03','WF037')
  and tran_type = 'Billing'
  and year(tran_date) = 2019
  and month(tran_date) = 12
	