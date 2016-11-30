



    SELECT 
	SY01400.USERID AS [sep=,' + CHAR(13) + CHAR(10) + 'USERID]
	,ISNULL(CONVERT(VARCHAR(20), MAX(LoginSuccess.StartTime), 101), '') AS MostRecentLogin
	FROM DYNAMICS.dbo.SY01400
	LEFT OUTER JOIN <trace shema>.dbo.<tracetable> ON SY01400.USERID = <tracetable>.SessionLoginName
	WHERE (<tracetable>.IPAddress IS NULL OR <tracetable>.IPAddress <> '127.0.0.1') --this is a generic IP that is used.
	GROUP BY SY01400.USERID
	ORDER BY MAX(<tracetable>.StartTime) DESC


	SELECT count('') 
	FROM <trace shema>.dbo.<tracetable>

	select USERID, CREATDDT FROM DYNAMICS.dbo.SY01400 where userid like 'okt[0-9]%' --or whatever wild card you need to use


	select max (login_time)as last_login_time, login_name from sys.dm_exec_sessions 
group by login_name;


