



    SELECT 
	SY01400.USERID AS [sep=,' + CHAR(13) + CHAR(10) + 'USERID]
	,ISNULL(CONVERT(VARCHAR(20), MAX(LoginSuccess.StartTime), 101), '') AS MostRecentLogin
	FROM DYNAMICS.dbo.SY01400
	LEFT OUTER JOIN Traces2005_Breakout.dbo.LoginSuccess ON SY01400.USERID = LoginSuccess.SessionLoginName
	WHERE (LoginSuccess.IPAddress IS NULL OR LoginSuccess.IPAddress <> '127.0.0.1')
	GROUP BY SY01400.USERID
	ORDER BY MAX(LoginSuccess.StartTime) DESC


	SELECT count('') 
	FROM Traces2005_Breakout.dbo.LoginSuccess

	select USERID, CREATDDT FROM DYNAMICS.dbo.SY01400 where userid like 'okt[0-9]%'


	select max (login_time)as last_login_time, login_name from sys.dm_exec_sessions 
group by login_name;


