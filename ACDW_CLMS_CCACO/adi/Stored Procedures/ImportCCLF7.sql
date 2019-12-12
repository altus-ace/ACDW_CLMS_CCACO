-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF7](
	-- Add the parameters for the stored procedure here
  
    @CUR_CLM_UNIQ_ID VARCHAR(13),
	@BENE_MBI_ID VARCHAR(11),
	@BENE_HIC_NUM VARCHAR(11),
	@CLM_LINE_NDC_CD VARCHAR(11),
	@CLM_TYPE_CD VARCHAR(2),
	@CLM_LINE_FROM_DT VARCHAR(10),
	@PRVDR_SRVC_ID_QLFYR_CD VARCHAR(2),
	@CLM_SRVC_PRVDR_GNRC_ID_NUM VARCHAR(20),
	@CLM_DSPNSNG_STUS_CD CHAR(1),
	@CLM_DAW_PROD_SLCTN_CD CHAR(1),
	@CLM_LINE_SRVC_UNIT_QTY varchar(10),
	@CLM_LINE_DAYS_SUPLY_QTY VARCHAR(10),
	@PRVDR_PRSBNG_ID_QLFYR_CD varchar(2),
	@CLM_PRSBNG_PRVDR_GNRC_ID_NUM varchar(10),
	@CLM_LINE_BENE_PMT_AMT varchar(10),
	@CLM_ADJSMT_TYPE_CD VARCHAR(2),
	@CLM_EFCTV_DT VARCHAR(10),
	@CLM_IDR_LD_DT VARCHAR(10),
	@CLM_LINE_RX_SRVC_RFRNC_NUM VARCHAR(12),
	@CLM_LINE_RX_FILL_NUM VARCHAR(9),
	@CLM_PHRMCY_SRVC_TYPE_CD VARCHAR(2),
	@SrcFileName varchar(100),
	@FileDate VARCHAR(10),
	@OriginalFileName VARCHAR(100),
--	@CreateDate] [datetime] NULL,
	@CreateBy varchar(100),
--	@AstCreatedDate] [datetime,
	@AstCreatedBy varchar(100)
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
INSERT INTO [adi].[CCLF7]
(
    [CUR_CLM_UNIQ_ID],
	[BENE_MBI_ID],
	[BENE_HIC_NUM],
	[CLM_LINE_NDC_ CD] ,
	[CLM_TYPE_CD] ,
	[CLM_LINE_FROM_DT] ,
	[PRVDR_SRVC_ID_QLFYR_CD] ,
	[CLM_SRVC_PRVDR_GNRC_ID_NUM] ,
	[CLM_DSPNSNG_STUS_CD] ,
	[CLM_DAW_PROD_SLCTN_CD] ,
	[CLM_LINE_SRVC_UNIT_QTY] ,
	[CLM_LINE_DAYS_SUPLY_QTY] ,
	[PRVDR_PRSBNG_ID_QLFYR_CD] ,
	[CLM_PRSBNG_PRVDR_GNRC_ID_NUM] ,
	[CLM_LINE_BENE_PMT_AMT],
	[CLM_ADJSMT_TYPE_CD] ,
	[CLM_EFCTV_DT] ,
	[CLM_IDR_LD_DT] ,
	[CLM_LINE_RX_SRVC_RFRNC_NUM] ,
	[CLM_LINE_RX_FILL_NUM] ,
	[CLM_PHRMCY_SRVC_TYPE_CD] ,
	[SrcFileName] ,
	[FileDate],
	[OriginalFileName] ,
	[CreateDate] ,
	[CreateBy],
	[AstCreatedDate],
	[AstCreatedBy]

)
  VALUES
(
    @CUR_CLM_UNIQ_ID,
	@BENE_MBI_ID ,
	@BENE_HIC_NUM,
	@CLM_LINE_NDC_CD ,
	@CLM_TYPE_CD,

    CASE WHEN (@CLM_LINE_FROM_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_LINE_FROM_DT) 
	END,
	@PRVDR_SRVC_ID_QLFYR_CD,

	@CLM_SRVC_PRVDR_GNRC_ID_NUM ,
	@CLM_DSPNSNG_STUS_CD ,
	@CLM_DAW_PROD_SLCTN_CD ,
	CASE WHEN (	@CLM_LINE_SRVC_UNIT_QTY = '')
	THEN NULL
	ELSE CONVERT(numeric, 	@CLM_LINE_SRVC_UNIT_QTY) 
	END,
	CASE WHEN (@CLM_LINE_DAYS_SUPLY_QTY = '')
	THEN NULL
	ELSE CONVERT(numeric, @CLM_LINE_DAYS_SUPLY_QTY) 
	END,
	@PRVDR_PRSBNG_ID_QLFYR_CD ,
	CASE WHEN (@CLM_PRSBNG_PRVDR_GNRC_ID_NUM = '')
	THEN NULL
	ELSE CONVERT(numeric, @CLM_PRSBNG_PRVDR_GNRC_ID_NUM) 
	END,
	CASE WHEN (@CLM_LINE_BENE_PMT_AMT = '')
	THEN NULL
	ELSE CONVERT(numeric, @CLM_LINE_BENE_PMT_AMT) 
	END,
	@CLM_ADJSMT_TYPE_CD ,
    CASE WHEN (@CLM_EFCTV_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_EFCTV_DT) 
	END,
	CASE WHEN (@CLM_IDR_LD_DT  = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_IDR_LD_DT ) 
	END,
	@CLM_LINE_RX_SRVC_RFRNC_NUM ,
	@CLM_LINE_RX_FILL_NUM ,
	@CLM_PHRMCY_SRVC_TYPE_CD ,
	@SrcFileName ,
	CASE WHEN (@FileDate  = '')
	THEN NULL
	ELSE CONVERT(date, 	@FileDate) 
	END,
	@OriginalFileName,
--	@CreateDate] [datetime] NULL,
	GETDATE(),
	@CreateBy ,
--	@AstCreatedDate] [datetime,
    GETDATE(),
	@AstCreatedBy
)
END


GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF7] TO [BoomiDbUser]
    AS [dbo];

