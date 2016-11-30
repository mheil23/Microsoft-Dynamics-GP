
--Determine What Permissions are required to use particular windows based on the exact display name on the top of the window example: 'Print Blank Checks (Payables)'
SELECT  ISNULL(A.SECURITYROLEID,'') AS SECURITYROLEID, ISNULL(M.SECURITYROLENAME,'') AS SECURITYROLENAME, ISNULL(M.SECURITYROLEDESC,'') AS SECURITYROLEDESC,
 ISNULL(O.SECURITYTASKID,'') AS SECURITYTASKID, ISNULL(T.SECURITYTASKNAME,'') AS SECURITYTASKNAME, ISNULL(T.SECURITYTASKDESC,'') AS SECURITYTASKDESC, 
 R.PRODNAME, R.TYPESTR, R.DSPLNAME, R.RESTECHNAME, R.DICTID, R.SECRESTYPE, R.SECURITYID
FROM DYNAMICS.dbo.SY09400 R
FULL JOIN DYNAMICS.dbo.SY10700 O ON R.DICTID = O.DICTID AND O.SECRESTYPE = R.SECRESTYPE AND O.SECURITYID = R.SECURITYID
FULL JOIN DYNAMICS.dbo.SY09000 T ON T.SECURITYTASKID = O.SECURITYTASKID
FULL JOIN DYNAMICS.dbo.SY10600 A ON A.SECURITYTASKID = T.SECURITYTASKID
FULL JOIN DYNAMICS.dbo.SY09100 M ON M.SECURITYROLEID = A.SECURITYROLEID
WHERE R.DSPLNAME = 'Payables Summary Inquiry'