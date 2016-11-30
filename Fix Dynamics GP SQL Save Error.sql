



/*
	Use the following stored procedure to fix issues related to saving actions on tables in GP. For example you can receive a modal window with sql error messages
	If there is something wrong with the users login syncronization

	Reference URL: http://blog.sqlauthority.com/2007/02/15/sql-server-fix-error-15023-user-already-exists-in-current-database/ 
*/

USE <database>;

--Enter the user's userid, password as the needed parameters.
EXEC sp_change_users_login 'Auto_Fix', '<username>', NULL, '<user's password>'


