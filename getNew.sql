/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	DISTINCT
	METRO.serial_no,
	LOT.misc_2 AS ST_CATEGORY,
	LOT.misc_5 AS SUBDIVISION
	--LOT.misc_1 AS Boundary,
FROM [Springbrook0].[dbo].[ub_srv_req] SR
	INNER JOIN
		[Springbrook0].[dbo].[ub_meter_hist] HIST
		ON SR.cust_no = HIST.cust_no
		AND SR.cust_sequence = HIST.cust_sequence
	INNER JOIN
		[Springbrook0].[dbo].[lot] LOT
		ON LOT.lot_no = SR.lot_no
	INNER JOIN
		[dbo].[ub_srv_req_dev] DEV
		ON SR.ub_srv_req_id = DEV.ub_srv_req_id
	INNER JOIN
		[dbo].[ub_meter_con] CON
		ON CON.ub_device_id = DEV.ub_device_id
	INNER JOIN
		[dbo].[ub_device] METRO
		ON METRO.ub_device_id = CON.ub_device_id
WHERE
	SR.CODE = 'METR01' AND
	YEAR(SR.service_date) = 2020
	and con.con_status = 'active'
	--AND (SR.req_description LIKE '%Register Changeout%' OR SR.req_description LIKE '%METR%' OR SR.req_description LIKE '%METR02%' OR SR.req_description LIKE '%METR03%')
ORDER BY
	LOT.misc_2 ASC,
	LOT.misc_5 ASC
	--LOT.MISC_1 ASC