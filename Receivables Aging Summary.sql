-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
-- view_Current_Receivables_Aging_Summary
-- Created Jan 25, 2012 by Victoria Yudin, Flexible Solutions Inc
-- For updates see https://victoriayudin.com/gp-reports/
-- Shows current AR aging with hard-coded aging buckets
-- Tables used:
--     CM - RM00101 - Customer Master
--     CS - RM00103 – Customer Master Summary
--     RM - RM20101 - Open Transactions
-- Updated May 1, 2013 to fix aging for credit docs
-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
 USE <database>;

 GO
 --the getdate() could be switched with the date in question, however, the tables might have to be changed to historical transactions... not sure yet.
 GO
select
CM.CUSTNMBR Customer_ID, CM.CUSTNAME Customer_Name,
CM.PYMTRMID Customer_Terms, CM.CUSTCLAS Customer_Class,
CM.PRCLEVEL Price_Level,
 
sum(case
when RM.RMDTYPAL < 7 then RM.CURTRXAM  --RMDTYPAL 0-Reserved for balanve carried forward records, 1-sale/invoice, 2-reserved for scheduled payments, 3-debit memo, 4-finance charge, 5-service/repair, 6-warranty, 7-credit memo, 8-return, 9-payment
else RM.CURTRXAM * -1
end) Total_Due,
 
sum(case
when DATEDIFF(d, RM.DUEDATE, getdate()) < 31 
     and RM.RMDTYPAL < 7 then RM.CURTRXAM
when DATEDIFF(d, RM.DOCDATE, getdate()) < 31 
     and RM.RMDTYPAL > 6 then RM.CURTRXAM *-1
else 0
end) [Current],
 
sum(case
when DATEDIFF(d, RM.DUEDATE, getdate()) between 31 and 60 
     and RM.RMDTYPAL < 7 then RM.CURTRXAM
when DATEDIFF(d, RM.DOCDATE, getdate()) between 31 and 60 
     and RM.RMDTYPAL > 6 then RM.CURTRXAM * -1
else 0
end) [31_to_60_Days],
 
sum(case
when DATEDIFF(d, RM.DUEDATE, getdate()) between 61 and 90 
     and RM.RMDTYPAL < 7 then RM.CURTRXAM
when DATEDIFF(d, RM.DOCDATE, getdate()) between 61 and 90 
     and RM.RMDTYPAL > 6 then RM.CURTRXAM * -1
else 0
end) [61_to_90_Days],
 
sum(case
when DATEDIFF(d, RM.DUEDATE, getdate()) between 91 and 120 
     and RM.RMDTYPAL < 7 then RM.CURTRXAM
when DATEDIFF(d, RM.DOCDATE, getdate()) between 91 and 120  
     and RM.RMDTYPAL > 6 then RM.CURTRXAM *-1
else 0
end) [91_and_120],

sum(case
when DATEDIFF(d, RM.DUEDATE, getdate()) > 120 
     and RM.RMDTYPAL < 7 then RM.CURTRXAM
when DATEDIFF(d, RM.DOCDATE, getdate()) > 120 
     and RM.RMDTYPAL > 6 then RM.CURTRXAM *-1
else 0
end) [120_and_Over],
 
CS.LASTPYDT Last_Payment_Date,
CS.LPYMTAMT Last_Payment_Amount
 
from RM20101 RM
 
inner join RM00101 CM
     on RM.CUSTNMBR = CM.CUSTNMBR
inner join RM00103 CS
     on RM.CUSTNMBR = CS.CUSTNMBR
 
where RM.VOIDSTTS = 0 and RM.CURTRXAM <> 0 and CM.CUSTNMBR = '3498749'
 
group by CM.CUSTNMBR, CM.CUSTNAME, CM.PYMTRMID, CM.CUSTCLAS, 
         CM.PRCLEVEL, CS.LASTPYDT,CS.LPYMTAMT
		 GO
-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
		 --historical transactions
--RM30101
select
CM.CUSTNMBR Customer_ID, CM.CUSTNAME Customer_Name,
CM.PYMTRMID Customer_Terms, CM.CUSTCLAS Customer_Class,
CM.PRCLEVEL Price_Level,
 
sum(case
when RM.RMDTYPAL < 7 then RM.CURTRXAM  --RMDTYPAL 0-Reserved for balanve carried forward records, 1-sale/invoice, 2-reserved for scheduled payments, 3-debit memo, 4-finance charge, 5-service/repair, 6-warranty, 7-credit memo, 8-return, 9-payment
else RM.CURTRXAM * -1
end) Total_Due,
 
sum(case
when DATEDIFF(d, RM.DUEDATE, '2016-06-30') < 31 
     and RM.RMDTYPAL < 7 then RM.ORTRXAMT
when DATEDIFF(d, RM.DOCDATE, '2016-06-30') < 31 
     and RM.RMDTYPAL > 6 then RM.ORTRXAMT *-1
else 0
end) [Current],
 
sum(case
when DATEDIFF(d, RM.DUEDATE, '2016-06-30') between 31 and 60 
     and RM.RMDTYPAL < 7 then RM.ORTRXAMT
when DATEDIFF(d, RM.DOCDATE, '2016-06-30') between 31 and 60 
     and RM.RMDTYPAL > 6 then RM.ORTRXAMT * -1
else 0
end) [31_to_60_Days],
 
sum(case
when DATEDIFF(d, RM.DUEDATE, '2016-06-30') between 61 and 90 
     and RM.RMDTYPAL < 7 then RM.ORTRXAMT
when DATEDIFF(d, RM.DOCDATE, '2016-06-30') between 61 and 90 
     and RM.RMDTYPAL > 6 then RM.ORTRXAMT * -1
else 0
end) [61_to_90_Days],
 
sum(case
when DATEDIFF(d, RM.DUEDATE, '2016-06-30') between 91 and 120 
     and RM.RMDTYPAL < 7 then RM.ORTRXAMT
when DATEDIFF(d, RM.DOCDATE, '2016-06-30') between 91 and 120  
     and RM.RMDTYPAL > 6 then RM.ORTRXAMT *-1
else 0
end) [91_and_120],

sum(case
when DATEDIFF(d, RM.DUEDATE, '2016-06-30') > 120 
     and RM.RMDTYPAL < 7 then RM.ORTRXAMT
when DATEDIFF(d, RM.DOCDATE, '2016-06-30') > 120 
     and RM.RMDTYPAL > 6 then RM.ORTRXAMT *-1
else 0
end) [120_and_Over]--,
 
--CS.LASTPYDT Last_Payment_Date,
--CS.LPYMTAMT Last_Payment_Amount
 
from RM30101 RM
 
inner join RM00101 CM
     on RM.CUSTNMBR = CM.CUSTNMBR
--inner join RM00103 CS
--     on RM.CUSTNMBR = CS.CUSTNMBR
 
where RM.VOIDSTTS = 0 and CM.CUSTNMBR = '3083432' --and RM.CURTRXAM <> 0 
group by CM.CUSTNMBR, CM.CUSTNAME, CM.PYMTRMID, CM.CUSTCLAS, 
         CM.PRCLEVEL--, CS.LASTPYDT,CS.LPYMTAMT



select top 10 * 
from RM30101
where custnmbr = '3083432' AND GLPOSTDT < = '2016-06-30'
order by GLPOSTDT DESC
----------------------------------------------------------------------------------

DECLARE @RC int
DECLARE @I_dAgingDate datetime
DECLARE @I_cStartCustomerNumber char(15)
DECLARE @I_cEndCustomerNumber char(15)
DECLARE @I_cStartCustomerName char(65)
DECLARE @I_cEndCustomerName char(65)
DECLARE @I_cStartClassID char(15)
DECLARE @I_cEndClassID char(15)
DECLARE @I_cStartSalesPersonID char(15)
DECLARE @I_cEndSalesPersonID char(15)
DECLARE @I_cStartSalesTerritory char(15)
DECLARE @I_cEndSalesTerritory char(15)
DECLARE @I_cStartShortName char(15)
DECLARE @I_cEndShortName char(15)
DECLARE @I_cStartState char(5)
DECLARE @I_cEndState char(5)
DECLARE @I_cStartZipCode char(11)
DECLARE @I_cEndZipCode char(11)
DECLARE @I_cStartPhoneNumber char(21)
DECLARE @I_cEndPhoneNumber char(21)
DECLARE @I_cStartUserDefined char(15)
DECLARE @I_cEndUserDefined char(15)
DECLARE @I_tUsingDocumentDate tinyint
DECLARE @I_dStartDate datetime
DECLARE @I_dEndDate datetime
DECLARE @I_sIncludeBalanceTypes smallint
DECLARE @I_tExcludeNoActivity tinyint
DECLARE @I_tExcludeMultiCurrency tinyint
DECLARE @I_tExcludeZeroBalanceCustomer tinyint
DECLARE @I_tExcludeFullyPaidTrxs tinyint
DECLARE @I_tExcludeCreditBalance tinyint
DECLARE @I_tExcludeUnpostedAppldCrDocs tinyint
DECLARE @I_tConsolidateNAActivity tinyint
 
 -- TODO: Set parameter values here.
Set @I_dAgingDate='6/30/16'
Set @I_cStartCustomerNumber='3083432'
Set @I_cEndCustomerNumber='3083432'
Set @I_cStartCustomerName=''
Set @I_cEndCustomerName='ZZZZZZZZ'
Set @I_cStartClassID=''
Set @I_cEndClassID='ZZZZZZZZ'
Set @I_cStartSalesPersonID=''
Set @I_cEndSalesPersonID='ZZZZZZZZ'
Set @I_cStartSalesTerritory=''
Set @I_cEndSalesTerritory='ZZZZZZZZ'
Set @I_cStartShortName=''
Set @I_cEndShortName='ZZZZZZZZ'
Set @I_cStartState=''
Set @I_cEndState='ZZZZZZZZ'
Set @I_cStartZipCode=''
Set @I_cEndZipCode='ZZZZZZZZ'
Set @I_cStartPhoneNumber=''
Set @I_cEndPhoneNumber='ZZZZZZZZ'
Set @I_cStartUserDefined=''
Set @I_cEndUserDefined='ZZZZZZZZ'
Set @I_tUsingDocumentDate=0
Set @I_dStartDate='1/1/1900'
Set @I_dEndDate='6/30/16'
Set @I_sIncludeBalanceTypes=0
Set @I_tExcludeNoActivity=1
Set @I_tExcludeMultiCurrency=1
Set @I_tExcludeZeroBalanceCustomer=1
Set @I_tExcludeFullyPaidTrxs=1
Set @I_tExcludeCreditBalance=0
Set @I_tExcludeUnpostedAppldCrDocs=1
Set @I_tConsolidateNAActivity=0
 
 

EXECUTE @RC = [dbo].[seermHATBSRSWrapper]
   @I_dAgingDate
  ,@I_cStartCustomerNumber
  ,@I_cEndCustomerNumber
  ,@I_cStartCustomerName
  ,@I_cEndCustomerName
  ,@I_cStartClassID
  ,@I_cEndClassID
  ,@I_cStartSalesPersonID
  ,@I_cEndSalesPersonID
  ,@I_cStartSalesTerritory
  ,@I_cEndSalesTerritory
  ,@I_cStartShortName
  ,@I_cEndShortName
  ,@I_cStartState
  ,@I_cEndState
  ,@I_cStartZipCode
  ,@I_cEndZipCode
  ,@I_cStartPhoneNumber
  ,@I_cEndPhoneNumber
  ,@I_cStartUserDefined
  ,@I_cEndUserDefined
  ,@I_tUsingDocumentDate
  ,@I_dStartDate
  ,@I_dEndDate
  ,@I_sIncludeBalanceTypes
  ,@I_tExcludeNoActivity
  ,@I_tExcludeMultiCurrency
  ,@I_tExcludeZeroBalanceCustomer
  ,@I_tExcludeFullyPaidTrxs
  ,@I_tExcludeCreditBalance
  ,@I_tExcludeUnpostedAppldCrDocs
  ,@I_tConsolidateNAActivity
  
  SELECT * INTO #MyTempTable FROM OPENROWSET('SQLNCLI', 'Server=(local)\SQL2008;Trusted_Connection=yes;',
     'EXEC getBusinessLineHistory')

SELECT * FROM #MyTempTable
