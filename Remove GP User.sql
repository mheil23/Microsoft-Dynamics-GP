

/*
	When removing a user from GP, sometimes it will yell at you and not really remove the user.
	Follow the following steps to get that unruly user out of there!

	reference url: https://support.microsoft.com/en-us/kb/943027 
*/



--Before a user is removed, make sure all of their sessions are removed from the following tables:

SELECT * FROM DYNAMICS..ACTIVITY --DELETE FROM DYNAMICS..ACTIVITY WHERE USERID IN ('oktbennet2','oknsweeney2')
SELECT * FROM DYNAMICS..SY00800  --DELETE FROM DYNAMICS..SY00800 WHERE USERID IN ('oktbennet2','oknsweeney2')
SELECT * FROM DYNAMICS..SY00801 --DELETE FROM DYNAMICS..SY00801 WHERE USERID IN ('oktbennet2','oknsweeney2')
SELECT * FROM TEMPDB..DEX_LOCK --this one might be a little tickier if the user has records in here.
SELECT * FROM TEMPDB..DEX_SESSION -- use sp_who2 to identify which sql_svrid correlates in this tables to the user

delete from tempb..dex_lock

select * from tempdb..dex_session where session_id IN (1872,1393)


select ba.* 
from DYNAMICS..SY00800 ba
left join DYNAMICS..ACTIVITY a ON ba.USERID = a.USERID
where a.USERID is null

IF NOT OBJECT_ID('tempdb..#sp_who2') IS NULL
	DROP TABLE #sp_who2
CREATE TABLE #sp_who2 (SPID INT,Status VARCHAR(255),
      Login  VARCHAR(255),HostName  VARCHAR(255), 
      BlkBy  VARCHAR(255),DBName  VARCHAR(255), 
      Command VARCHAR(255),CPUTime INT, 
      DiskIO INT,LastBatch VARCHAR(255), 
      ProgramName VARCHAR(255),SPID2 INT, 
      REQUESTID INT) 
INSERT INTO #sp_who2 EXEC sp_who2
SELECT      * 
FROM        #sp_who2
-- Add any filtering of the results here :
WHERE       DBName <> 'master'
-- Add any sorting of the results here :
ORDER BY    DBName ASC

DELETE
FROM TEMPDB..DEX_SESSION
WHERE sqlsvr_spid IN (
select SPID
from #sp_who2
WHERE Login IN ('oktbennet2','oknsweeney2') )


'oktbennett2'

DELETE FROM TEMPDB..DEX_SESSION WHERE sqlsvr_spid IN (
select *
from #sp_who2
WHERE SPID IN (143,106)
WHERE Login IN ('oktbennett2','oknsweeney2')
)


--reset any batches
UPDATE SY00500 SET MKDTOPST=0, BCHSTTUS=0 where BACHNUMB='RET07/19/169TJ'

select * from sy00500 where bachnumb = 'RET07/19/169TJ'



--Make sure User is deleted from the following tables:

USE ABS;
-- Ctrl+H to find and replace  the 6 occurances of the user's name
DECLARE @USER as varchar(30)
SET @USER = 'jhamel'
--DELETE ABS..SY01401  WHERE USERID = @USER
--DELETE MOBIA..SY01401  WHERE USERID = @USER
--DELETE UBS..SY01401  WHERE USERID = @USER
DELETE TESTA..SY01401  WHERE USERID = @USER
DELETE DYNAMICS..ACTIVITY WHERE USERID = @USER
DELETE DYNAMICS..SY10500  WHERE USERID = @USER
DELETE DYNAMICS..SY08000  WHERE USERID = @USER
DELETE DYNAMICS..SY60100  WHERE USERID = @USER
DELETE DYNAMICS..SY01600  WHERE USERID = @USER
DELETE DYNAMICS..SY01400  WHERE USERID = @USER
DELETE DYNAMICS..SY01403  WHERE USERID = @USER
DELETE DYNAMICS..SY60100  WHERE USERID = @USER
DELETE DYNAMICS..SY10550  WHERE USERID = @USER
USE DYNAMICS
DROP USER jhamel
GO
USE ABS
DROP USER jhamel
GO
USE MOBIA
DROP USER jhamel
GO
USE UBS
DROP USER jhamel
GO
USE TESTA
DROP USER jhamel
GO
/*
Only run this if you're still having an issue adding user back to GP as this will
remove the SQL login and affect this user's access to all databases on this instance.
*/
--DROP LOGIN dchoing
--GO



