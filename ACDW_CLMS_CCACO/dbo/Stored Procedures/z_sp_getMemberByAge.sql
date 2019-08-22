-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<List Members that are at a current age>
-- =============================================
CREATE PROCEDURE z_sp_getMemberByAge @FromAge int, @ThruAge int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT SUBSCRIBER_ID 
	FROM adw.Claims_Member
	WHERE  (DATEDIFF(yy, DOB, GETDATE()) >= @FromAge) AND (DATEDIFF(yy, DOB, GETDATE()) <= @ThruAge)
END
