
/*
	Orders failed Great Plains Insert Attempt Investigation

	There is a diagram that outlines the flow of data through the integration into the GP SOP tables called Bibles.com Order Integration
	in the azure documentation.

	If there is a failed insert, the first thing to do is look at the ProcReturnCode node in the xml body within the message queue.
	See if you can gather any information from there. If you determined that it's an issue with an item number (most likely)
	You can have Operations look into the Bibles.com admin side of things to check the item setup. While they are doing that,
	look into the BCOM tables, as well as the xml documents on CSGINT01. You can use the weborderid to find the original csv file
	that was pulled from the web server to see if the data came down corrupt, or got mishandled along the way.

*/


USE ABS;

--Order Header Information
SELECT *
FROM [ABS].[dbo].[BCOM_GP_Order_Headers]
WHERE WEBORDERID IN (24732) --use the weborderid from the email
ORDER BY WEBORDERID DESC

--Order Detail Information
SELECT d.*, COALESCE(iv.ITEMNMBR, 'DNE') AS IV_ITEMNMBR
FROM [ABS].[dbo].[BCOM_GP_Order_Items] d
LEFT JOIN [ABS].[dbo].[IV00101] iv ON d.SKU = iv.ITEMNMBR
WHERE WEBORDERID IN () --use the weborderid from the email
ORDER BY WEBORDERID


--To fix a order with a bad item, update the BCOM Order Items table to correct the item numbers
--and then null out the insert attempt field in the header table. You can also change the values in the xml
--on VMAZ-CSGINT01 located at C:\tmp\PROD\<GPORDERID>.xml
 
 BEGIN TRAN
 DECLARE @WebOrderID INT
 SET @WebOrderID = 12345
 UPDATE [ABS].[dbo].[BCOM_GP_Order_Items] SET SKU = '' WHERE WEBORDERID = @WebOrderID AND SKU = ''
 UPDATE [ABS].[dbo].[BCOM_GP_Order_Items] SET SKU = '' WHERE WEBORDERID = @WebOrderID AND SKU = ''
 UPDATE [ABS].[dbo].[BCOM_GP_Order_Items] SET SKU = '' WHERE WEBORDERID = @WebOrderID AND SKU = ''
 UPDATE [ABS].[dbo].[BCOM_GP_Order_Items] SET SKU = '' WHERE WEBORDERID = @WebOrderID AND SKU = ''
 --commit rollback

 BEGIN TRAN
 UPDATE [ABS].[dbo].BCOM_GP_Order_Headers
 SET GPINSERTATTEMPT = NULL
 WHERE WEBORDERID = 123245 --weborderid
 --commit rollback
 