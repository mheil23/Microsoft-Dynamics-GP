


USE <database>;
SELECT *
FROM SY00500
WHERE BACHNUMB = 'WEBORDERS'


SELECT TOP 10 *
FROM MS273516


SELECT TOP 100 *
FROM CCA_Work
WHERE BACHNUMB LIKE 'Rbk%'

USE ABS;
SELECT TOP 100 *
FROM MS273505 --MSO_TRX
WHERE BACHNUMB LIKE 'Rbk%'

select top 100 * FROM MS273516 --MSO_Book_Expr_Duration

---------------------------------------------------------------------------
--inspector information
SELECT TOP 10 * FROM SY03100 --Credit Card Master
--SELECT TOP 10 * FROM MS273501 --MSO_Engine_SETP
SELECT TOP 10 * FROM MS273512 WHERE BACHNUMB LIKE 'Rbk%'--MSO_History
SELECT TOP 10 * FROM MS273505 --MSO_TRX
--SELECT TOP 10 * FROM temp --MSO_TRX_TEMP
SELECT TOP 10 * FROM RM00101 -- Customer Master



SELECT CAST(REPLACE(BACHNUMB,'Exp-', '') AS Date)
FROM MS273512 --MSO_History
WHERE MSO_Capture_Amount = '433.85' OR MSO_Auth_Amount = '433.85' AND MSO_InstanceGUID = '3c88186e-039d-4c76-9cc7-0270ac2e500f'


--the MSO_History table is what is used by the CCA credit card reports to display information. We can use this to get what we want.


CREATE VIEW vCCATransactionResearch AS
SELECT TOP 100 PERCENT
	MSO_Doc_Number, 
	CUSTNMBR, 
	BACHNUMB, 
	CAST(REPLACE(REPLACE(REPLACE(BACHNUMB,'Exp-',''),'Rebk-',''),'DEN--','') AS DATE) AS [Date],
	MSO_FirstName AS FirstName, 
	MSO_LastName AS LastName, 
	MSO_CardExpDate AS ExpirationDate, 
	MSO_CardName AS CardType, 
	CRCRDAMT AS Amount, 
	MSO_RespAuthCode AS RespAuthCode, 
	MSO_RespMSG AS ResponseMessage, 
	MSO_BookExpDate AS RebookExpiration 
FROM MS273512 --MSO_History
WHERE ((
	   BACHNUMB LIKE 'Exp-%'
	   AND ISDATE(REPLACE(BACHNUMB,'Exp-','')) = 1
	   AND CAST(REPLACE(BACHNUMB,'Exp-','') AS DATE) >= CAST(DATEADD(MM, -3,GETDATE()) AS DATE)
	  )
	OR
	  (
	   BACHNUMB LIKE 'Rebk-%'
	   AND ISDATE(REPLACE(BACHNUMB,'Rebk-','')) = 1
	   AND CAST(REPLACE(BACHNUMB,'Rebk-','') AS DATE) >= CAST(DATEADD(MM, -3,GETDATE()) AS DATE)
	  )
	OR
	  (
	   BACHNUMB LIKE 'DEN--%'
	   AND ISDATE(REPLACE(BACHNUMB,'DEN--','')) = 1
	   AND CAST(REPLACE(BACHNUMB,'DEN--','') AS DATE) >= CAST(DATEADD(MM, -3,GETDATE()) AS DATE)
	  ))
ORDER BY [Date] DESC, MSO_Doc_Number


