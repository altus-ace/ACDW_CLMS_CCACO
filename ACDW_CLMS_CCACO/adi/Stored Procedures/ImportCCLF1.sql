-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF1](
	-- Add the parameters for the stored procedure here
    @CUR_CLM_UNIQ_ID varchar(20),
	@PRVDR_OSCAR_NUM varchar(6) ,
	@BENE_HIC_NUM varchar(22),
	@CLM_TYPE_CD varchar(10),
	@CLM_FROM_DT varchar(10),
	@CLM_THRU_DT varchar(10),
	@CLM_BILL_FAC_TYPE_CD char(1),
	@CLM_BILL_CLSFCTN_CD char(1),
	@PRNCPL_DGNS_CD varchar(7),
	@ADMTG_DGNS_CD varchar(7),
	@CLM_MDCR_NPMT_RSN_CD char(2) ,
	@CLM_PMT_AMT varchar(20),
	@CLM_NCH_PRMRY_PYR_CD char(1),
	@PRVDR_FAC_FIPS_ST_CD char(2) ,
	@BENE_PTNT_STUS_CD char(2),
	@DGNS_DRG_CD varchar(4),
	@CLM_OP_SRVC_TYPE_CD char(1) ,
	@FAC_PRVDR_NPI_NUM varchar(10) ,
	@OPRTG_PRVDR_NPI_NUM varchar(10),
	@ATNDG_PRVDR_NPI_NUM varchar(10) ,
	@OTHR_PRVDR_NPI_NUM varchar(10),
	@CLM_ADJSMT_TYPE_CD char(2) NULL,
	@CLM_EFCTV_DT varchar(10),
	@CLM_IDR_LD_DT varchar(10),
	@BENE_EQTBL_BIC_HICN_NUM varchar(11),
	@CLM_ADMSN_TYPE_CD char(2),
	@CLM_ADMSN_SRC_CD char(2),
	@CLM_BILL_FREQ_CD char(1),
	@CLM_QUERY_CD char(1),
	@DGNS_PRCDR_ICD_IND char(1),
	@SrcFileName varchar(100),
	@FileDate varchar(10),
	@originalFileName varchar(100),
--	@CreateDate ,
	@CreateBy varchar(100),
	@BENE_MBI_ID varchar(11),
	@CLM_MDCR_INSTNL_TOT_CHRG_AMT varchar(15),
	@CLM_MDCR_IP_PPS_CPTL_IME_AMT varchar(15),
	@CLM_OPRTNL_IME_AMT varchar(22),
	@CLM_MDCR_IP_PPS_DSPRPRTNT_AMT varchar(15),
	@CLM_HIPPS_UNCOMPD_CARE_AMT varchar(15),
	@CLM_OPRTNL_DSPRPRTNT_AMT varchar(22)
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
INSERT INTO [adi].[CCLF1]
(
    [CUR_CLM_UNIQ_ID] ,
	[PRVDR_OSCAR_NUM] ,
	[BENE_HIC_NUM],
	[CLM_TYPE_CD] ,
	[CLM_FROM_DT] ,
	[CLM_THRU_DT] ,
	[CLM_BILL_FAC_TYPE_CD],
	[CLM_BILL_CLSFCTN_CD],
	[PRNCPL_DGNS_CD] ,
	[ADMTG_DGNS_CD] ,
	[CLM_MDCR_NPMT_RSN_CD] ,
	[CLM_PMT_AMT] ,
	[CLM_NCH_PRMRY_PYR_CD] ,
	[PRVDR_FAC_FIPS_ST_CD] ,
	[BENE_PTNT_STUS_CD] ,
	[DGNS_DRG_CD],
	[CLM_OP_SRVC_TYPE_CD] ,
	[FAC_PRVDR_NPI_NUM] ,
	[OPRTG_PRVDR_NPI_NUM] ,
	[ATNDG_PRVDR_NPI_NUM] ,
	[OTHR_PRVDR_NPI_NUM] ,
	[CLM_ADJSMT_TYPE_CD] ,
	[CLM_EFCTV_DT] ,
	[CLM_IDR_LD_DT] ,
	[BENE_EQTBL_BIC_HICN_NUM] ,
	[CLM_ADMSN_TYPE_CD] ,
	[CLM_ADMSN_SRC_CD] ,
	[CLM_BILL_FREQ_CD] ,
	[CLM_QUERY_CD] ,
	[DGNS_PRCDR_ICD_IND] ,
	[SrcFileName] ,
	[FileDate] ,
	[originalFileName],
	[CreateDate],
	[CreateBy] ,
	[BENE_MBI_ID],
	[CLM_MDCR_INSTNL_TOT_CHRG_AMT],
	[CLM_MDCR_IP_PPS_CPTL_IME_AMT],
	[CLM_OPRTNL_IME_AMT],
	[CLM_MDCR_IP_PPS_DSPRPRTNT_AMT],
	[CLM_HIPPS_UNCOMPD_CARE_AMT],
	[CLM_OPRTNL_DSPRPRTNT_AMT]
)
  VALUES
(
  @CUR_CLM_UNIQ_ID,
	@PRVDR_OSCAR_NUM  ,
	@BENE_HIC_NUM ,
	@CLM_TYPE_CD ,
	CASE WHEN (@CLM_FROM_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_FROM_DT)
	END ,
	CASE WHEN (@CLM_THRU_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_THRU_DT)
	END ,
	@CLM_BILL_FAC_TYPE_CD ,
	@CLM_BILL_CLSFCTN_CD ,
	@PRNCPL_DGNS_CD ,
	@ADMTG_DGNS_CD ,
	@CLM_MDCR_NPMT_RSN_CD  ,
	CASE WHEN (@CLM_PMT_AMT = '')
	THEN NULL
	ELSE CONVERT(money,@CLM_PMT_AMT) 
	END,
	@CLM_NCH_PRMRY_PYR_CD ,
	@PRVDR_FAC_FIPS_ST_CD  ,
	@BENE_PTNT_STUS_CD ,
	@DGNS_DRG_CD ,
	@CLM_OP_SRVC_TYPE_CD ,
	@FAC_PRVDR_NPI_NUM ,
	@OPRTG_PRVDR_NPI_NUM ,
	@ATNDG_PRVDR_NPI_NUM  ,
	@OTHR_PRVDR_NPI_NUM ,
	@CLM_ADJSMT_TYPE_CD ,
	CASE WHEN (@CLM_EFCTV_DT = '')
	THEN NULL
	ELSE CONVERT(date, @CLM_EFCTV_DT)
	END,
	CASE WHEN (	@CLM_IDR_LD_DT= '')
	THEN NULL
	ELSE CONVERT(date, 	@CLM_IDR_LD_DT)
	END,
	@BENE_EQTBL_BIC_HICN_NUM ,
	@CLM_ADMSN_TYPE_CD ,
	@CLM_ADMSN_SRC_CD ,
	@CLM_BILL_FREQ_CD ,
	@CLM_QUERY_CD ,
	@DGNS_PRCDR_ICD_IND ,
	@SrcFileName ,
	CASE WHEN (@FileDate= '')
	THEN NULL
	ELSE CONVERT(date,@FileDate)
	END,
	@originalFileName,
--	@CreateDate ,
    GETDATE(),
	@CreateBy,
	@BENE_MBI_ID,
	@CLM_MDCR_INSTNL_TOT_CHRG_AMT ,
	@CLM_MDCR_IP_PPS_CPTL_IME_AMT,
	@CLM_OPRTNL_IME_AMT,
	@CLM_MDCR_IP_PPS_DSPRPRTNT_AMT,
	@CLM_HIPPS_UNCOMPD_CARE_AMT ,
	@CLM_OPRTNL_DSPRPRTNT_AMT  

)
END


GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF1] TO [BoomiDbUser]
    AS [dbo];

