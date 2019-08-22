CREATE PROCEDURE adw.UM_MASTER
AS 
    Exec adw.sp_Load_ClaimsNotReversedNotDenied;
