-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF3](
	-- Add the parameters for the stored procedure here
    @CUR_CLM_UNIQ_ID varchar(26),
	@BENE_HIC_NUM varchar(22) ,
	@CLM_TYPE_CD varchar(5) ,
	@CLM_VAL_SQNC_NUM varchar(5),
	@CLM_PRCDR_CD varchar(7),
	@CLM_PRCDR_PRFRM_DT varchar(10) ,
	@BENE_EQTBL_BIC_HICN_NUM varchar(11),
	@PRVDR_OSCAR_NUM varchar(6),
	@CLM_FROM_DT varchar(10) ,
	@CLM_THRU_DT varchar(10) ,
    @DGNS_PRCDR_ICD_IND varchar(1),
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@originalFileName varchar(100) ,
    --[CreateDate] ,
	@CreateBy varchar(20),
	@BENE_MBI_ID varchar(11)

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
INSERT INTO [adi].[CCLF3]
(
    [CUR_CLM_UNIQ_ID],
	[BENE_HIC_NUM] ,
	[CLM_TYPE_CD],
	[CLM_VAL_SQNC_NUM] ,
	[CLM_PRCDR_CD],
	[CLM_PRCDR_PRFRM_DT],
	[BENE_EQTBL_BIC_HICN_NUM] ,
	[PRVDR_OSCAR_NUM] ,
	[CLM_FROM_DT] ,
	[CLM_THRU_DT] ,
	[DGNS_PRCDR_ICD_IND] ,
	[SrcFileName] ,
	[FileDate] ,
	[originalFileName],
	[CreateDate] ,
	[CreateBy] ,
	[BENE_MBI_ID] 
    

)
  VALUES
(
    @CUR_CLM_UNIQ_ID ,
	@BENE_HIC_NUM ,
	@CLM_TYPE_CD ,
	@CLM_VAL_SQNC_NUM ,
	@CLM_PRCDR_CD ,
	CASE WHEN (@CLM_PRCDR_PRFRM_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_PRCDR_PRFRM_DT)
	END ,
	@BENE_EQTBL_BIC_HICN_NUM ,
	@PRVDR_OSCAR_NUM ,
	CASE WHEN (@CLM_FROM_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_FROM_DT)
	END ,
	CASE WHEN (@CLM_THRU_DT  = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_THRU_DT )
	END ,
    @DGNS_PRCDR_ICD_IND ,
	@SrcFileName  ,
	CASE WHEN (@FileDate = '')
	THEN NULL
	ELSE CONVERT(date,  @FileDate)
	END ,
	@originalFileName  ,
    --[CreateDate] ,
	GETDATE(),
	@CreateBy ,
	@BENE_MBI_ID 

)
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF3] TO [BoomiDbUser]
    AS [dbo];

