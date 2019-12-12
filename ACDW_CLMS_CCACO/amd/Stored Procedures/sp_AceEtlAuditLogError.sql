CREATE PROCEDURE [amd].[sp_AceEtlAuditLogError](
     @EtlAuditPKey int,
	 @Error varchar(1000),
	 @CreateBy varchar(20) 
	)
AS 
BEGIN

EXEC [AceMetaData].[amd].[sp_AceEtlAuditLogError] @EtlAuditPKey, @Error, @CreateBy

 
END
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Open]
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Close]
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_sp_AceEtlAuditLogError]
GO
GRANT EXECUTE
    ON OBJECT::[amd].[sp_AceEtlAuditLogError] TO [BoomiDbUser]
    AS [dbo];

