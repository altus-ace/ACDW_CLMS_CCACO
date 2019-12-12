-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [amd].[sp_AceEtlAudit_Close](
      @AuditId int
    , @ActionStopTime DATETIME 
    , @SourceCount int = 0
    , @DestinationCount int = 0
    , @ErrorCount int = 0    
    , @JobStatus tinyInt = 2

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
	--SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', '[ACECARDW].[adi].[copUhcPcor]', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
   EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditId, @ActionStopTime,@SourceCount,@DestinationCount,@ErrorCount,@JobStatus;   

 END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END
GO
GRANT EXECUTE
    ON OBJECT::[amd].[sp_AceEtlAudit_Close] TO [BoomiDbUser]
    AS [dbo];

