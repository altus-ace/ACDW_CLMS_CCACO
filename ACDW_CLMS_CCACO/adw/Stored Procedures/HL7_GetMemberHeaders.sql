
CREATE PROCEDURE adw.HL7_GetMemberHeaders 
			@ID varchar(12)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER(ORDER BY LASTNAME ASC) AS [Row],LASTNAME[Last Name],FIRSTNAME,[SubscriberNo],[PCP_LastName]
									,[DOB],[CurrentAge] ,[Gender],[Address1],[Address2],[City],[State],[Zip],[PracticeName]
	FROM dbo.tmp_AHR_HL7_Report_Header
	WHERE SubscriberNo = @ID


END
