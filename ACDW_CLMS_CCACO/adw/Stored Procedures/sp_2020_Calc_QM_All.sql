

CREATE PROCEDURE [adw].[sp_2020_Calc_QM_All]
AS 
  /* 
  **Set Logging Parameters
  */
    --Declare @batchDate Date	= '2019-03-17';    
    DECLARE @InsertCount INT = 0;
    DECLARE @QueryCount INT = 0;    
    DECLARE @Audit_ID INT	   = 0;
    DECLARE @ClientKey INT;
    SELECT @ClientKey = ClientKey FROM Lst.List_client WHERE ClientShortName = 'CCACO';
    
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
	SET @qmFx = 'sp_2020_Calc_QM_ABA'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_ABA		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_ART'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_ART		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_AWC'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_AWC		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_BCS'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_BCS		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CBP'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CBP		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CCS'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CCS		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CDC_0'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CDC_0		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CDC_7_9'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CDC_7_9		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CDC_BP'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CDC_BP		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CDC_E'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CDC_E		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CDC_HB'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CDC_HB		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CDC_N'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CDC_N		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_COA'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_COA		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_COL'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_COL		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_DPR_12'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC [adw].[sp_2020_Calc_QM_DPR_12] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_FUH'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_FUH		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_PCE'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_PCE		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_SPD'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_SPD		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	
	
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_SPR'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_SPR		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_W15'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_W15		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  


	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_W36'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_W36		'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  



	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_WCC'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_WCC	'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_PPC'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_PPC	'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;  

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_CHL'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'N/A' 
	EXEC adw.sp_2020_Calc_QM_CHL'[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = 0, @DestinationCount = 0,@ErrorCount = 0;