-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE z_sp_getMemberByGender @Gender varchar(1)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT SUBSCRIBER_ID 
	FROM adw.Claims_Member
	WHERE GENDER = @Gender
END
