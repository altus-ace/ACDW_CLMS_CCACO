CREATE PROCEDURE [amd].[sp_AceEtlAudit_Open](
	  @AuditID INT output
	, @AuditStatus SmallInt= 0
	, @JobType SmallInt = 2
	, @ClientKey varchar(5)  
	--, @ClientKey INT 
	, @JobName VARCHAR(200) = 'No Job Name'
	, @ActionStartTime DATETIME2 
	, @InputSourceName VARCHAR(200) = 'No Input Source Name Provided'	
	, @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	, @ErrorName VARCHAR(200) = 'No Error Name Provided'	
	)
AS 
BEGIN
 
DECLARE @CKey int = CONVERT(int,@ClientKey) ;

EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Open] @AuditID OUTPUT,  @AuditStatus, @JobType, @ClientKey, @JobName, @ActionStartTime, @InputSourceName, @DestinationName, @ErrorName 

 
END
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Close]
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_sp_AceEtlAuditLogError]
GO
GRANT EXECUTE
    ON OBJECT::[amd].[sp_AceEtlAudit_Open] TO [BoomiDbUser]
    AS [dbo];

