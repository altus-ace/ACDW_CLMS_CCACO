-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF5](
	-- Add the parameters for the stored procedure here
    @BENE_MBI_ID varchar(11),
	@CUR_CLM_UNIQ_ID varchar(20), 
	--numeric](26, 0) NULL,
	@CLM_LINE_NUM varchar(50), 
	--int,
	@BENE_HIC_NUM varchar(22),
	@CLM_TYPE_CD varchar(10),
	-- smallint] NULL,
	@CLM_FROM_DT varchar(10),
	--[date] NULL,
	@CLM_THRU_DT varchar(10),
	--[date] NULL,
	@RNDRG_PRVDR_TYPE_CD varchar(3),
	@RNDRG_PRVDR_FIPS_ST_CD varchar(2),
	@CLM_PRVDR_SPCLTY_CD varchar(2),
	@CLM_FED_TYPE_SRVC_CD varchar(1),
	@CLM_POS_CD varchar(2),
	@CLM_LINE_FROM_DT varchar(10),
	--[date] NULL,
	@CLM_LINE_THRU_DT varchar(10),
	--[date] NULL,
	@CLM_LINE_HCPCS_CD varchar(5),
	@CLM_LINE_CVRD_PD_AMT varchar(15) ,
	@CLM_LINE_PRMRY_PYR_CD varchar(1),
	@CLM_LINE_DGNS_CD varchar(7),
	@RNDRG_PRVDR_NPI_NUM varchar(10),
	@CLM_CARR_PMT_DNL_CD varchar(2),
	@CLM_PRCSG_IND_CD varchar(2) ,
	@CLM_ADJSMT_TYPE_CD varchar(2),
	@CLM_EFCTV_DT varchar(10), 
	--[date],
	@CLM_IDR_LD_DT varchar(10), 
	--[date] NULL,
	@CLM_CNTL_NUM varchar(40),
	@BENE_EQTBL_BIC_HICN_NUM varchar(11) ,
	@CLM_LINE_ALOWD_CHRG_AMT varchar(17),
	@CLM_LINE_SRVC_UNIT_QTY varchar(20),
	--[numeric](18, 3) NULL,
	@HCPCS_1_MDFR_CD varchar(2),
	@HCPCS_2_MDFR_CD varchar(2),
	@HCPCS_3_MDFR_CD varchar(2),
	@HCPCS_4_MDFR_CD varchar(2),
	@HCPCS_5_MDFR_CD varchar(2) ,
	@CLM_DISP_CD varchar(2),
	@CLM_DGNS_1_CD varchar(7) ,
	@CLM_DGNS_2_CD varchar(7) ,
	@CLM_DGNS_3_CD varchar(7),
	@CLM_DGNS_4_CD varchar(7) ,
	@CLM_DGNS_5_CD varchar(7) ,
	@CLM_DGNS_6_CD varchar(7),
	@CLM_DGNS_7_CD varchar(7) ,
	@CLM_DGNS_8_CD varchar(7) ,
	@DGNS_PRCDR_ICD_IND varchar(1) ,
	@CLM_DGNS_9_CD varchar(7),
	@CLM_DGNS_10_CD varchar(7) ,
	@CLM_DGNS_11_CD varchar(7),
	@CLM_DGNS_12_CD varchar(7),
	@HCPCS_BETOS_CD varchar(3),
	@CLM_RNDRG_PRVDR_TAX_NUM varchar(10) ,

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
INSERT INTO [adi].[CCLF5]
(
    [BENE_MBI_ID] ,
	[CUR_CLM_UNIQ_ID] ,
	[CLM_LINE_NUM] ,
	[BENE_HIC_NUM] ,
	[CLM_TYPE_CD] ,
	[CLM_FROM_DT] ,
	[CLM_THRU_DT] ,
	[RNDRG_PRVDR_TYPE_CD] ,
	[RNDRG_PRVDR_FIPS_ST_CD] ,
	[CLM_PRVDR_SPCLTY_CD] ,
	[CLM_FED_TYPE_SRVC_CD],
	[CLM_POS_CD] ,
	[CLM_LINE_FROM_DT] ,
	[CLM_LINE_THRU_DT],
	[CLM_LINE_HCPCS_CD] ,
	[CLM_LINE_CVRD_PD_AMT] ,
	[CLM_LINE_PRMRY_PYR_CD] ,
	[CLM_LINE_DGNS_CD] ,
	[RNDRG_PRVDR_NPI_NUM] ,
	[CLM_CARR_PMT_DNL_CD] ,
	[CLM_PRCSG_IND_CD] ,
	[CLM_ADJSMT_TYPE_CD] ,
	[CLM_EFCTV_DT] ,
	[CLM_IDR_LD_DT] ,
	[CLM_CNTL_NUM] ,
	[BENE_EQTBL_BIC_HICN_NUM] ,
	[CLM_LINE_ALOWD_CHRG_AMT] ,
	[CLM_LINE_SRVC_UNIT_QTY] ,
	[HCPCS_1_MDFR_CD] ,
	[HCPCS_2_MDFR_CD] ,
	[HCPCS_3_MDFR_CD] ,
	[HCPCS_4_MDFR_CD] ,
	[HCPCS_5_MDFR_CD] ,
	[CLM_DISP_CD] ,
	[CLM_DGNS_1_CD],
	[CLM_DGNS_2_CD] ,
	[CLM_DGNS_3_CD] ,
	[CLM_DGNS_4_CD] ,
	[CLM_DGNS_5_CD] ,
	[CLM_DGNS_6_CD] ,
	[CLM_DGNS_7_CD] ,
	[CLM_DGNS_8_CD] ,
	[DGNS_PRCDR_ICD_IND],
	[CLM_DGNS_9_CD] ,
	[CLM_DGNS_10_CD] ,
	[CLM_DGNS_11_CD] ,
	[CLM_DGNS_12_CD] ,
	[HCPCS_BETOS_CD] ,
	[CLM_RNDRG_PRVDR_TAX_NUM] , 
	[SrcFileName] ,
	[FileDate] ,
	[OriginalFileName] ,
	[CreateDate],
	[CreateBy] 

)
  VALUES
(
    @BENE_MBI_ID ,
	CASE WHEN @CUR_CLM_UNIQ_ID = ''
	THEN NULL 
	ELSE CONVERT(numeric,  @CUR_CLM_UNIQ_ID)
	END, 
	--numeric](26, 0) NULL,
	CASE WHEN @CLM_LINE_NUM = ''
	THEN NULL 
	ELSE CONVERT(numeric, @CLM_LINE_NUM)
	END,
	--int,
	@BENE_HIC_NUM ,
	CASE WHEN @CLM_TYPE_CD = ''
	THEN NULL 
	ELSE CONVERT(numeric, @CLM_TYPE_CD)
	END,
	-- smallint] NULL,
	CASE WHEN @CLM_FROM_DT = ''
	THEN NULL 
	ELSE CONVERT(date, @CLM_FROM_DT)
	END,
	--[date] NULL,
	CASE WHEN @CLM_THRU_DT = ''
	THEN NULL 
	ELSE CONVERT(date, @CLM_THRU_DT)
	END,
	--[date] NULL,
	@RNDRG_PRVDR_TYPE_CD ,
	@RNDRG_PRVDR_FIPS_ST_CD ,
	@CLM_PRVDR_SPCLTY_CD ,
	@CLM_FED_TYPE_SRVC_CD ,
	@CLM_POS_CD ,
	CASE WHEN @CLM_LINE_FROM_DT = ''
	THEN NULL 
	ELSE CONVERT(date,@CLM_LINE_FROM_DT)
	END,
	--[date] NULL,
	CASE WHEN @CLM_LINE_THRU_DT  = ''
	THEN NULL 
	ELSE CONVERT(date,@CLM_LINE_THRU_DT )
	END,
	--[date] NULL,
	@CLM_LINE_HCPCS_CD ,
	@CLM_LINE_CVRD_PD_AMT  ,
	@CLM_LINE_PRMRY_PYR_CD ,
	@CLM_LINE_DGNS_CD ,
	@RNDRG_PRVDR_NPI_NUM ,
	@CLM_CARR_PMT_DNL_CD ,
	@CLM_PRCSG_IND_CD ,
	@CLM_ADJSMT_TYPE_CD ,
	CASE WHEN @CLM_EFCTV_DT = ''
	THEN NULL 
	ELSE CONVERT(date, @CLM_EFCTV_DT)
	END,
	--[date],
	CASE WHEN @CLM_IDR_LD_DT = ''
	THEN NULL 
	ELSE CONVERT(date, @CLM_IDR_LD_DT)
	END,
	--[date] NULL,
	
	@CLM_CNTL_NUM ,
	@BENE_EQTBL_BIC_HICN_NUM ,
	@CLM_LINE_ALOWD_CHRG_AMT ,
	CASE WHEN @CLM_LINE_SRVC_UNIT_QTY  = ''
	THEN NULL 
	ELSE CONVERT(numeric, @CLM_LINE_SRVC_UNIT_QTY)
	END,
	--[numeric](18, 3) NULL,
	@HCPCS_1_MDFR_CD ,
	@HCPCS_2_MDFR_CD ,
	@HCPCS_3_MDFR_CD ,
	@HCPCS_4_MDFR_CD,
	@HCPCS_5_MDFR_CD ,
	@CLM_DISP_CD ,
	@CLM_DGNS_1_CD ,
	@CLM_DGNS_2_CD ,
	@CLM_DGNS_3_CD,
	@CLM_DGNS_4_CD ,
	@CLM_DGNS_5_CD  ,
	@CLM_DGNS_6_CD ,
	@CLM_DGNS_7_CD ,
	@CLM_DGNS_8_CD ,
	@DGNS_PRCDR_ICD_IND ,
    @CLM_DGNS_9_CD ,
	@CLM_DGNS_10_CD ,
	@CLM_DGNS_11_CD ,
	@CLM_DGNS_12_CD ,
	@HCPCS_BETOS_CD,
	@CLM_RNDRG_PRVDR_TAX_NUM ,
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
    ON OBJECT::[adi].[ImportCCLF5] TO [BoomiDbUser]
    AS [dbo];

