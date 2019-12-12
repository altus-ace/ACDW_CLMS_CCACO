-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF2](
	-- Add the parameters for the stored procedure here
    @CUR_CLM_UNIQ_ID varchar(26),
	@CLM_LINE_NUM varchar(5),
	@BENE_HIC_NUM varchar(22) ,
	@CLM_TYPE_CD varchar(5) ,
	@CLM_LINE_FROM_DT varchar(10),
	@CLM_LINE_THRU_DT varchar(10),
	@CLM_LINE_PROD_REV_CTR_CD varchar(4) ,
	@CLM_LINE_INSTNL_REV_CTR_DT varchar(10) ,
	@CLM_LINE_HCPCS_CD varchar(5),
	@BENE_EQTBL_BIC_HICN_NUM varchar(11),
	@PRVDR_OSCAR_NUM varchar(6),
	@CLM_FROM_DT varchar(10) ,
	@CLM_THRU_DT varchar(10) ,
	@CLM_LINE_SRVC_UNIT_QTY varchar(20) ,
	@CLM_LINE_CVRD_PD_AMT varchar(10),
	@HCPCS_1_MDFR_CD varchar(2) ,
	@HCPCS_2_MDFR_CD varchar(2) ,
	@HCPCS_3_MDFR_CD varchar(2) ,
	@HCPCS_4_MDFR_CD varchar(2) ,
    @HCPCS_5_MDFR_CD varchar(2) ,
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@originalFileName varchar(100) ,
    --[CreateDate] ,
	@CreateBy varchar(20),
	@BENE_MBI_ID varchar(11),
	@CLM_REV_APC_HIPPS_CD varchar(5)

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
INSERT INTO [adi].[CCLF2]
(
    [CUR_CLM_UNIQ_ID],
	[CLM_LINE_NUM] ,
	[BENE_HIC_NUM] ,
	[CLM_TYPE_CD], 
	[CLM_LINE_FROM_DT],
	[CLM_LINE_THRU_DT],
	[CLM_LINE_PROD_REV_CTR_CD] ,
	[CLM_LINE_INSTNL_REV_CTR_DT] ,
	[CLM_LINE_HCPCS_CD] ,
	[BENE_EQTBL_BIC_HICN_NUM] ,
	[PRVDR_OSCAR_NUM] ,
	[CLM_FROM_DT] ,
	[CLM_THRU_DT] ,
	[CLM_LINE_SRVC_UNIT_QTY] ,
	[CLM_LINE_CVRD_PD_AMT] ,
	[HCPCS_1_MDFR_CD] ,
	[HCPCS_2_MDFR_CD] ,
	[HCPCS_3_MDFR_CD] ,
	[HCPCS_4_MDFR_CD] ,
	[HCPCS_5_MDFR_CD] ,
	[SrcFileName] ,
	[FileDate] ,
	[originalFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[BENE_MBI_ID] ,
	[CLM_REV_APC_HIPPS_CD]

)
  VALUES
(
    @CUR_CLM_UNIQ_ID ,
	@CLM_LINE_NUM ,
	@BENE_HIC_NUM  ,
	@CLM_TYPE_CD ,
	CASE WHEN (@CLM_LINE_FROM_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_LINE_FROM_DT)
	END,
	CASE WHEN (@CLM_LINE_THRU_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_LINE_THRU_DT)
	END,
	@CLM_LINE_PROD_REV_CTR_CD ,
	CASE WHEN (@CLM_LINE_INSTNL_REV_CTR_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_LINE_INSTNL_REV_CTR_DT)
	END,
	@CLM_LINE_HCPCS_CD ,
	@BENE_EQTBL_BIC_HICN_NUM ,
	@PRVDR_OSCAR_NUM ,
	CASE WHEN (@CLM_FROM_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_FROM_DT)
	END,
	CASE WHEN (@CLM_THRU_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_THRU_DT)
	END,
	CASE WHEN (@CLM_LINE_SRVC_UNIT_QTY = '')
	THEN NULL
	ELSE CONVERT(numeric, @CLM_LINE_SRVC_UNIT_QTY)
	END,
	CASE WHEN (@CLM_LINE_CVRD_PD_AMT = '')
	THEN NULL
	ELSE CONVERT(money, @CLM_LINE_CVRD_PD_AMT)
	END,
	@HCPCS_1_MDFR_CD ,
	@HCPCS_2_MDFR_CD ,
	@HCPCS_3_MDFR_CD  ,
	@HCPCS_4_MDFR_CD  ,
    @HCPCS_5_MDFR_CD  ,
	@SrcFileName  ,
	@FileDate  ,
	@originalFileName  ,
    --[CreateDate] ,
	GETDATE(),
	@CreateBy ,
	@BENE_MBI_ID ,
	@CLM_REV_APC_HIPPS_CD

)
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF2] TO [BoomiDbUser]
    AS [dbo];

