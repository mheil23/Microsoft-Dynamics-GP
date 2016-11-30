SELECT
a.USERID GP_User_ID,
um.USERNAME [User_Name],
a.CMPNYNAM Company_Name,
a.LOGINDAT+a.LOGINTIM Login_Date_and_Time,
coalesce(b.batch_count,0) Batch_Activity_Records,
coalesce(r.resource_count,0) Resource_Activity_Records,
coalesce(t.table_locks,0) Table_Lock_Records

FROM DYNAMICS..ACTIVITY a

LEFT OUTER JOIN
(SELECT USERID, count(*) batch_count
 FROM DYNAMICS..SY00800
 GROUP BY USERID) b -- batch activity
ON a.USERID = b.USERID

LEFT OUTER JOIN
(SELECT USERID, count(*) resource_count
 FROM DYNAMICS..SY00801
 GROUP BY USERID) r -- resource activity
ON a.USERID = r.USERID

LEFT OUTER JOIN
(SELECT Session_ID, COUNT(*) table_locks
 FROM tempdb..DEX_LOCK
 GROUP BY Session_ID) t -- table locks
ON a.SQLSESID = t.Session_ID

LEFT OUTER JOIN
DYNAMICS..SY01400 um -- user master
ON a.USERID = um.USERID
ORDER BY User_Name



select * from DYNAMICS..SY00800 WHERE BACHNUMB = 'DW111716PO' --batch locks
select * FROM DYNAMICS..SY00801 --active resources being used by userid
select * from tempdb..DEX_LOCK 
select * FROM tempdb..DEX_SESSION 

