

CREATE PROCEDURE [adw].[sp_Calc_QM_All]
AS 
  /* 
  **Set Logging Parameters
  */
    --Declare @batchDate Date	= '2019-03-17';    
    DECLARE @InsertCount INT = 0;
    DECLARE @QueryCount INT = 0;    
    DECLARE @Audit_ID INT	   = 0;
    DECLARE @ClientKey INT;
    SELECT @ClientKey = ClientKey FROM Lst.List_client where clientShortName = 'CCACO';
    
    DECLARE @qmFx VARCHAR(100);
    DECLARE @Destination VARCHAR(100) = 'adw.QM_ResultByMember_History';
    DECLARE @JobName VARCHAR(100);
    SELECT @JobName = (OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID));
    DECLARE @StartTime DATETIME2;
    /* 
   -- Audit Status     1	In process,     2	Success,    3	Fail
    -- Job Type        4	Move File,    5	ETL Data,     6	Export Data
   */
   
   /* 
   ***The logging calls is called inside the QM Procedure 
   ***Set Open logging
   ***Set Close logging
   */

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_ABA'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_ABA		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_ART'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_ART		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_AWC'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_AWC		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_BCS'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_BCS		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CBP'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CBP		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CCS'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CCS		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CDC_0'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CDC_0		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CDC_7_9'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CDC_7_9		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CDC_BP'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CDC_BP		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CDC_E'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CDC_E		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CDC_HB'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CDC_HB		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_CDC_N'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_CDC_N		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_COA'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_COA		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_COL'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_COL		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_FUH'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_FUH		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_PCE'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_PCE		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_SPD'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_SPD		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_SPR'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_SPR		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_W15'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_W15		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_W36'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_W36		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  



	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_19_Calc_QM_WCC'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_19_Calc_QM_WCC		2019, '6';
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	