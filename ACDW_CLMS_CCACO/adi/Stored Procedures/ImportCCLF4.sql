-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF4](
	-- Add the parameters for the stored procedure here
    @CUR_CLM_UNIQ_ID varchar(26),
	@BENE_HIC_NUM varchar(22),
	@CLM_TYPE_CD varchar(5),
	@CLM_PROD_TYPE_CD varchar(1) ,
	@CLM_VAL_SQNC_NUM varchar(5),
	@CLM_DGNS_CD varchar(7),
	@BENE_EQTBL_BIC_HICN_NUM varchar(1) ,
	@PRVDR_OSCAR_NUM varchar(6),
	@CLM_FROM_DT vARCHAR(10),
	@CLM_THRU_DT VARCHAR(10),
	@CLM_POA_IND VARCHAR(7) ,
	@DGNS_PRCDR_ICD_IND VARCHAR(1) ,
	@SrcFileName VARCHAR(100),
	@FileDate VARCHAR(10) ,
	@originalFileName VARCHAR(100) ,
	--CreateDate ,
	@CreateBy VARCHAR(20) ,
	@BENE_MBI_ID VARCHAR(11) 
)
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

    -- Insert statements for procedure here
INSERT INTO [adi].[CCLF4]
(
    [CUR_CLM_UNIQ_ID] ,
	[BENE_HIC_NUM] ,
	[CLM_TYPE_CD] ,
	[CLM_PROD_TYPE_CD] ,
	[CLM_VAL_SQNC_NUM],
	[CLM_DGNS_CD] ,
	[BENE_EQTBL_BIC_HICN_NUM] ,
	[PRVDR_OSCAR_NUM] ,
	[CLM_FROM_DT] ,
	[CLM_THRU_DT] ,
	[CLM_POA_IND] ,
	[DGNS_PRCDR_ICD_IND] ,
	[SrcFileName] ,
	[FileDate] ,
	[originalFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[BENE_MBI_ID] 
)
  VALUES
(
    @CUR_CLM_UNIQ_ID,
	@BENE_HIC_NUM ,
	@CLM_TYPE_CD ,
	@CLM_PROD_TYPE_CD  ,
	@CLM_VAL_SQNC_NUM ,
	@CLM_DGNS_CD ,
	@BENE_EQTBL_BIC_HICN_NUM  ,
	@PRVDR_OSCAR_NUM ,
	@CLM_FROM_DT ,
	@CLM_THRU_DT ,
	@CLM_POA_IND ,
	@DGNS_PRCDR_ICD_IND ,
	@SrcFileName ,
	@FileDate  ,
	@originalFileName, 
	GETdate() ,
	--CreateDate ,
	@CreateBy ,
	@BENE_MBI_ID  

)
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF4] TO [BoomiDbUser]
    AS [dbo];

