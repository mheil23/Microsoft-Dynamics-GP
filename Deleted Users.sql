
--Deleted Users

--ABS\hdoucet------------------------------------------------------------------------------------------------------
USE [master]
GO

/****** Object:  Login [ABS\hdoucet]    Script Date: 9/16/2016 1:20:13 PM ******/
CREATE LOGIN [ABS\hdoucet] FROM WINDOWS WITH DEFAULT_DATABASE=[DYNAMICS], DEFAULT_LANGUAGE=[us_english]
GO


USE [ABS]
GO

/****** Object:  User [ABS\hdoucet]    Script Date: 9/16/2016 1:20:42 PM ******/
CREATE USER [ABS\hdoucet] FOR LOGIN [ABS\hdoucet] WITH DEFAULT_SCHEMA=[dbo]
GO
--ABS\lschlissel------------------------------------------------------------------------------------------------------
USE [master]
GO

/****** Object:  Login [ABS\lschlissel]    Script Date: 9/16/2016 1:24:07 PM ******/
CREATE LOGIN [ABS\lschlissel] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO



USE [ABS]
GO

/****** Object:  User [ABS\lschlissel]    Script Date: 9/16/2016 1:23:22 PM ******/
CREATE USER [ABS\lschlissel] FOR LOGIN [ABS\lschlissel] WITH DEFAULT_SCHEMA=[ABS\lschlissel]
GO

--ABS\sberryhill------------------------------------------------------------------------------------------------------
USE [ABS]
GO

/****** Object:  User [ABS\sberryhill]    Script Date: 9/16/2016 1:26:29 PM ******/
CREATE USER [ABS\sberryhill] WITH DEFAULT_SCHEMA=[dbo]
GO

--ABS\ukumar------------------------------------------------------------------------------------------------------
USE [master]
GO

/****** Object:  Login [ABS\ukumar]    Script Date: 9/16/2016 1:29:26 PM ******/
CREATE LOGIN [ABS\ukumar] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

USE [ABS]
GO

/****** Object:  User [ABS\ukumar]    Script Date: 9/16/2016 1:29:09 PM ******/
CREATE USER [ABS\ukumar] FOR LOGIN [ABS\ukumar] WITH DEFAULT_SCHEMA=[dbo]
GO

--ABS\ehelm2------------------------------------------------------------------------------------------------------

USE [master]
GO

/****** Object:  Login [ABS\ehelm2]    Script Date: 9/16/2016 3:35:52 PM ******/
CREATE LOGIN [ABS\ehelm2] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO





/*
--use the following to script out what roles the user had for each database, all you have to do is switch out the user's Login, and comment out the second 
--section that is using the temp table to compare two users.

IF NOT OBJECT_ID('tempdb..#temp') IS NULL
	DROP TABLE #temp
DECLARE @DB_USers TABLE
(ServerLogin VARCHAR(255), DBUser VARCHAR(255), DBName VARCHAR(255), DatabaseRole varchar(max))
 
INSERT @DB_USers
EXEC sp_MSforeachdb
 
'
use [?]
SELECT 
	susers.[name] AS LogInAtServerLevel,
	users.[name] AS UserAtDBLevel,
	DB_NAME() AS [Database],              
	roles.name AS DatabaseRoleMembership
 from sys.database_principals users
  inner join sys.database_role_members link
   on link.member_principal_id = users.principal_id
  inner join sys.database_principals roles
   on roles.principal_id = link.role_principal_id
   inner join sys.server_principals susers
   on susers.sid = users.sid
   WHERE susers.[name] LIKE ''ABS\ehelm%'''
 
SELECT ServerLogin, DBUser , DBName,
STUFF((SELECT ',' + CONVERT(VARCHAR(500),DatabaseRole) FROM @DB_USers user2 WHERE user1.DBName=user2.DBName AND user1.DBUser=user2.DBUser FOR XML PATH('')),1,1,'') AS Permissions_user, GETDATE() AS DeletedDate
INTO #temp
FROM @DB_USers user1
GROUP BY ServerLogin, DBUser, DBName
ORDER BY DBName, DBUser


;WITH ehelm AS
(
	SELECT *
	FROM #temp
	WHERE ServerLogin = 'ABS\ehelm'
), ehelm2 AS
(
	SELECT *
	FROM #temp
	WHERE ServerLogin = 'ABS\ehelm2'
)
SELECT a.*, b.Permissions_user as ehelm
FROM ehelm2 a
LEFT JOIN ehelm b ON a.DBName = b.DBName
WHERE a.Permissions_user <> b.Permissions_user
*/