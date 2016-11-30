





USE TESTA;
DECLARE @output NVARCHAR(MAX) = N'';
SELECT @output += CHAR(13) + CHAR(10) 
  + 'DROP VIEW [ABS\ehelm2].[' + t.name + '];'
  FROM sys.views AS t
  WHERE schema_id = schema_id('ABS\ehelm2')
EXEC sp_executesql @output;


select * from sys.tables where schema_id = schema_id('ABS\ehelm2')



