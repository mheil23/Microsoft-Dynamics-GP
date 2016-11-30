




/*
Orders To Investigate:

	Order		Inv				Item
	SO00397634	STINV00314619	124351	24 vs 15
	SO00397078	STINV00314217   122966	20 vs 5
								122967	10 vs 5
								122968	10 vs 5

Notes:
	1. Both were created by okrrascon at the warehouse (not web orders).
	2. The Orders at the Warehouse are created directly in GP.

TODO:
	1. Create a script that identifies all of the problem orders for Finance team, they will have to create adjustments
	2. Understand from start to finish the entire pick ticket process.

*/


--Sales Order Header - History
---------------------------------------------------------------------------
--SO
SELECT SOPTYPE, 
	   SOPNUMBE, 
	   ORIGNUMB, 
	   DOCDATE, 
	   GLPOSTDT, 
	   ReqShipDate, 
	   FUFILDAT, 
	   USDOCID1, 
	   BCHSOURC, 
	   BACHNUMB, 
	   CUSTNMBR, 
	   CUSTNAME, 
	   CSTPONBR, 
	   EXTDCOST, 
	   USER2ENT, 
	   CREATDDT, 
	   SOPSTATUS 
FROM SOP30200 
WHERE SOPNUMBE = 'SO00397634'

--INV
SELECT SOPTYPE, 
	   SOPNUMBE, 
	   ORIGNUMB, 
	   DOCDATE, 
	   GLPOSTDT, 
	   ReqShipDate, 
	   FUFILDAT, 
	   USDOCID1, 
	   BCHSOURC, 
	   BACHNUMB, 
	   CUSTNMBR, 
	   CUSTNAME, 
	   CSTPONBR, 
	   EXTDCOST, 
	   USER2ENT, 
	   CREATDDT, 
	   SOPSTATUS  
FROM SOP30200 
WHERE ORIGNUMB = 'SO00397634'
---------------------------------------------------------------------------
--Sales Order Detail - History

SELECT 
	SOPTYPE,
	SOPNUMBE,
	ITEMNMBR, 
	ITEMDESC,
	UOFM,
	UNITCOST,
	UNITPRCE,
	QUANTITY,
	ATYALLOC AllocatedQTY,
	QTYPRINV PreInvoicedQTY,
	QTYFULFI FulfilledQTY,
	QTYTOINV,
	QTYONHND,
	QTYTBAOR
FROM SOP30300 
WHERE SOPNUMBE = 'SO00397634' AND ITEMNMBR = '124351'

SELECT SOPTYPE,
	SOPNUMBE,
	ITEMNMBR, 
	ITEMDESC,
	UOFM,
	UNITCOST,
	UNITPRCE,
	QUANTITY,
	ATYALLOC AllocatedQTY,
	QTYPRINV PreInvoicedQTY,
	QTYFULFI FulfilledQTY,
	QTYTOINV,
	QTYONHND,
	QTYTBAOR
FROM SOP30300 
WHERE SOPNUMBE = 'STINV00314619' AND ITEMNMBR = '124351'

---------------------------------------------------------------------------


USE NodusEncryption;
select top 100 *
from [dbo].[_NodusAuditLog]
where message not like 'eTransaction Entry%'

