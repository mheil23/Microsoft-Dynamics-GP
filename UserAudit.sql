


--last login date, user name, any other helpfull-plain language columns

Use DYNAMICS


IF NOT OBJECT_ID('tempdb..#logins') IS NULL
	DROP TABLE #logins
SELECT 	
	SY01400.USERID
	,ISNULL(CONVERT(VARCHAR(20), MAX(LoginSuccess.StartTime), 101), '') AS MostRecentLogin
	INTO #logins
FROM DYNAMICS.dbo.SY01400
LEFT OUTER JOIN <TraceSchema>.dbo.<TraceTable> ON SY01400.USERID = <TraceTable>.SessionLoginName
WHERE (<TraceTable>.IPAddress IS NULL OR <TraceTable>.IPAddress <> '127.0.0.1')
GROUP BY SY01400.USERID
ORDER BY MAX(<TraceTable>.StartTime) DESC

SELECT	
	 U.USERNAME
	,S.USERID UserID
	,S.CMPANYID CompanyID
	,C.CMPNYNAM CompanyName
	,S.SecurityRoleID
	,coalesce(T.SECURITYTASKID,'') SecurityTaskID
	,coalesce(TM.SECURITYTASKNAME,'') SecurityTaskName
	,coalesce(TM.SECURITYTASKDESC,'') SecurityTaskDescription
	--,L.MostRecentLogin
FROM SY01400 U --User Master
LEFT JOIN SY10500 S ON U.USERID = S.USERID  -- security assignment user role
LEFT OUTER JOIN SY01500 C   ON S.CMPANYID = C.CMPANYID  --Company Master
LEFT OUTER JOIN SY10600 T  ON S.SECURITYROLEID = T.SECURITYROLEID -- tasks in roles
LEFT OUTER JOIN SY09000 TM  ON T.SECURITYTASKID = TM.SECURITYTASKID -- tasks master
--LEFT JOIN #logins L ON u.USERID = L.USERID
WHERE S.CMPANYID <> 15 --AND T.SECURITYTASKID IN ('<security task>')--,'ANYVIEW_CREATOR_OBJECTS' S.USERID IS NULL OR U.USERNAME IS NULL AND TM.SECURITYTASKNAME NOT lIKE 'View%' AND TM.SECURITYTASKNAME NOT lIKE 'Find%' AND TM.SECURITYTASKNAME NOT lIKE '%reports' AND TM.SECURITYTASKNAME NOT lIKE 'Lookup%' AND 
AND C.CMPNYNAM = '<Company Name>' --AND TM.SECURITYTASKNAME LIKE '%Administrator%' --AND S.SECURITYROLEID = '<roleid>' AND TM.SECURITYTASKNAME LIKE '%post%'
AND S.SECURITYROLEID = '<security role>'
GROUP BY U.USERNAME
	,S.USERID
	,S.CMPANYID
	,C.CMPNYNAM
	,S.SecurityRoleID
	----,L.MostRecentLogin
	,T.SECURITYTASKID
	,TM.SECURITYTASKNAME
	,TM.SECURITYTASKDESC
ORDER BY U.USERNAME, C.CMPNYNAM, S.SECURITYROLEID, T.SECURITYTASKID

select top 10 *
from DYNAMICS..SY09400


select top 10 * from SY09100
