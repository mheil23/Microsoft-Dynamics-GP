




--in this case the schema was actually the name of a user, I was trying to remove the views associated with junk from the user.
USE <database>;
DECLARE @output NVARCHAR(MAX) = N'';
SELECT @output += CHAR(13) + CHAR(10) 
  + 'DROP VIEW [<Schema>].[' + t.name + '];'
  FROM sys.views AS t
  WHERE schema_id = schema_id('<schema>')
EXEC sp_executesql @output;


select * from sys.tables where schema_id = schema_id('<schema>')



