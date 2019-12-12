-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [adi].[ImportCCLF6](
	-- Add the parameters for the stored procedure here
    @CUR_CLM_UNIQ_ID varchar(13),
	@CLM_LINE_NUM varchar(10),
	@BENE_MBI_ID varchar(11),
	@BENE_HIC_NUM varchar(11),
	@CLM_TYPE_CD varchar(2),
	@CLM_FROM_DT varchar(10),
	@CLM_THRU_DT varchar(10),
	@CLM_FED_TYPE_SRVC_CD char(1),
	@CLM_POS_CD varchar(2),
	@CLM_LINE_FROM_DT varCHAR(10),
	--[date] NULL,
	@CLM_LINE_THRU_DT VARCHAR(10), 
	--[date] NULL,
	@CLM_LINE_HCPCS_CD varchar(5) ,
	@CLM_LINE_CVRD_PD_AMT varchar(15),
	@CLM_PRMRY_PYR_CD char(1),
	@PAYTO_PRVDR_NPI_NUM varchar(10),
	@ORDRG_PRVDR_NPI_NUM varchar(10),
	@CLM_CARR_PMT_DNL_CD varchar(2),
	@CLM_PRCSG_IND_CD varchar(2),
	@CLM_ADJSMT_TYPE_CD varchar(2),
	@CLM_EFCTV_DT varchar(10),
	@CLM_IDR_LD_DT varchar(10),
	@CLM_CNTL_NUM varchar(40),
	@BENE_EQTBL_BIC_HICN_NUM varchar(11),
	@CLM_LINE_ALOWD_CHRG_AMT varchar(17),
	@CLM_DISP_CD varchar(2),
	@SrcFileName varchar(100),
	@FileDate varchar(10),
	@OriginalFileName varchar(100),
	--@CreateDate ,
	@CreateBy varchar(100)

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
INSERT INTO [adi].[CCLF6]
(
    [CUR_CLM_UNIQ_ID] ,
	[CLM_LINE_NUM] ,
	[BENE_MBI_ID],
	[BENE_HIC_NUM] ,
	[CLM_TYPE_CD] ,
	[CLM_FROM_DT] ,
	[CLM_THRU_DT] ,
	[CLM_FED_TYPE_SRVC_CD],
	[CLM_POS_CD] ,
	[CLM_LINE_FROM_DT] ,
	[CLM_LINE_THRU_DT] ,
	[CLM_LINE_HCPCS_CD] ,
	[CLM_LINE_CVRD_PD_AMT] ,
	[CLM_PRMRY_PYR_CD] ,
	[PAYTO_PRVDR_NPI_NUM] ,
	[ORDRG_PRVDR_NPI_NUM],
	[CLM_CARR_PMT_DNL_CD] ,
	[CLM_PRCSG_IND_CD] ,
	[CLM_ADJSMT_TYPE_CD] ,
	[CLM_EFCTV_DT] ,
	[CLM_IDR_LD-DT] ,
	[CLM_CNTL_NUM] ,
	[BENE_EQTBL_BIC_HICN_NUM] ,
	[CLM_LINE_ALOWD_CHRG_AMT] ,
	[CLM_DISP_CD] ,
   
	[SrcFileName] ,
	[FileDate] ,
	[OriginalFileName] ,
	[CreateDate],
	[CreateBy] 

)
  VALUES
(
  
    @CUR_CLM_UNIQ_ID ,
	@CLM_LINE_NUM ,
	@BENE_MBI_ID ,
	@BENE_HIC_NUM ,
	@CLM_TYPE_CD ,
	@CLM_FROM_DT ,
	@CLM_THRU_DT,
	@CLM_FED_TYPE_SRVC_CD ,
	@CLM_POS_CD,
	CASE WHEN @CLM_LINE_FROM_DT = ''
	THEN NULL
	ELSE CONVERT(date,@CLM_LINE_FROM_DT)
	END,
	--[date] NULL,
	CASE WHEN @CLM_LINE_THRU_DT = ''
	THEN NULL
	ELSE CONVERT(date, @CLM_LINE_THRU_DT)
	END,
	--[date] NULL,
	@CLM_LINE_HCPCS_CD,
	@CLM_LINE_CVRD_PD_AMT ,
	@CLM_PRMRY_PYR_CD ,
	@PAYTO_PRVDR_NPI_NUM ,
	@ORDRG_PRVDR_NPI_NUM ,
	@CLM_CARR_PMT_DNL_CD ,
	@CLM_PRCSG_IND_CD ,
	@CLM_ADJSMT_TYPE_CD ,
	CASE WHEN @CLM_EFCTV_DT = ''
	THEN NULL
	ELSE CONVERT(date, @CLM_EFCTV_DT)
	END,
	CASE WHEN @CLM_IDR_LD_DT  = ''
	THEN NULL
	ELSE CONVERT(date, @CLM_IDR_LD_DT )
	END,
	@CLM_CNTL_NUM ,
	@BENE_EQTBL_BIC_HICN_NUM ,
	@CLM_LINE_ALOWD_CHRG_AMT ,
	@CLM_DISP_CD ,
	@SrcFileName ,
	CASE WHEN @FileDate  = ''
	THEN NULL
	ELSE CONVERT(date, @FileDate)
	END,
	@OriginalFileName ,
	--@CreateDate ,
	GETDATE(),
	@CreateBy 

)
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF6] TO [BoomiDbUser]
    AS [dbo];

