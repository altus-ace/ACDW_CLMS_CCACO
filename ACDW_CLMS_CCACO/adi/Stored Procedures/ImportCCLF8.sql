-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
CREATE PROCEDURE [adi].[ImportCCLF8](
	-- Add the parameters for the stored procedure here
    @BENE_HIC_NUM varchar(22),
	@BENE_FIPS_STATE_CD varchar(5) ,
	@BENE_FIPS_CNTY_CD varchar(5) ,
	@BENE_ZIP_CD varchar(11),
	@BENE_DOB varchar(10),
	@BENE_SEX_CD varchar(2),
	@BENE_RACE_CD varchar(2) ,
	@BENE_AGE varchar(54) ,
	@BENE_MDCR_STUS_CD varchar(5),
	@BENE_DUAL_STUS_CD varchar(5),
	@BENE_DEATH_DT varchar(10),
	@BENE_RNG_BGN_DT varchar(10) ,
	@BENE_RNG_END_DT varchar(10) ,
	@BENE_1ST_NAME varchar(65) ,
	@BENE_LAST_NAME varchar(65),
	@BENE_MIDL_NAME varchar(65) ,
	@BENE_ORGNL_ENTLMT_RSN_CD varchar(10) ,
	@BENE_ENTLMT_BUYIN_IND varchar(5) ,
	@BENE_PART_A_ENRLMT_BGN_DT varchar(10),
    @BENE_PART_B_ENRLMT_BGN_DT varchar(10) ,

    @BENE_LINE_1_ADR VARCHAR(45),

    @BENE_LINE_2_ADR VARCHAR(45),

    @BENE_LINE_3_ADR VARCHAR(40),

    @BENE_LINE_4_ADR VARCHAR(40),

    @BENE_LINE_5_ADR VARCHAR(40),

    @BENE_LINE_6_ADR VARCHAR(40),

    @GEO_ZIP_PLC_NAME VARCHAR(100),

    @GEO_USPS_STATE_CD VARCHAR(2),

    @GEO_ZIP5_CD  VARCHAR(5),

    @GEO_ZIP4_CD VARCHAR(4),
	@SrcFileName varchar(100) ,
	@FileDate varchar(10),
	@OriginalFileName varchar(100),
	--@CreateDate ,
	@CreateBy varchar(20) ,
	--@AstCreatedDate varchar(100),
	@AstCreatedBy varchar(100),
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
INSERT INTO [adi].[CCLF8]
(
	[BENE_HIC_NUM],
	[BENE_FIPS_STATE_CD] ,
	[BENE_FIPS_CNTY_CD] ,
	[BENE_ZIP_CD],
	[BENE_DOB],
	[BENE_SEX_CD],
	[BENE_RACE_CD] ,
	[BENE_AGE] ,
	[BENE_MDCR_STUS_CD],
	[BENE_DUAL_STUS_CD],
	[BENE_DEATH_DT],
	[BENE_RNG_BGN_DT] ,
	[BENE_RNG_END_DT] ,
	[BENE_1ST_NAME] ,
	[BENE_LAST_NAME] ,
	[BENE_MIDL_NAME] ,
	[BENE_ORGNL_ENTLMT_RSN_CD] ,
	[BENE_ENTLMT_BUYIN_IND] ,
	BENE_PART_A_ENRLMT_BGN_DT  ,

BENE_PART_B_ENRLMT_BGN_DT  ,

BENE_LINE_1_ADR ,

BENE_LINE_2_ADR ,

BENE_LINE_3_ADR ,

BENE_LINE_4_ADR ,

BENE_LINE_5_ADR ,

BENE_LINE_6_ADR ,

GEO_ZIP_PLC_NAME ,

GEO_USPS_STATE_CD ,

GEO_ZIP5_CD ,

GEO_ZIP4_CD,
	[SrcFileName] ,
	[FileDate],
	[OriginalFileName] ,
	[CreateDate],
	[CreateBy] ,
	[AstCreatedDate],
	[AstCreatedBy],
	[BENE_MBI_ID] 
)
  VALUES
(
 @BENE_HIC_NUM ,
	@BENE_FIPS_STATE_CD  ,
	@BENE_FIPS_CNTY_CD ,
	@BENE_ZIP_CD ,
	@BENE_DOB ,
	@BENE_SEX_CD ,
	@BENE_RACE_CD  ,
	@BENE_AGE  ,
	@BENE_MDCR_STUS_CD ,
	@BENE_DUAL_STUS_CD ,
	CASE WHEN (@BENE_DEATH_DT = '')
	THEN NULL
	ELSE CONVERT(date, @BENE_DEATH_DT)
	END,
    CASE WHEN (@BENE_RNG_BGN_DT = '')
	THEN NULL
	ELSE CONVERT(date, @BENE_RNG_BGN_DT)
	END,
	CASE WHEN (@BENE_RNG_END_DT  = '')
	THEN NULL
	ELSE CONVERT(date, @BENE_RNG_END_DT )
	END, 


	@BENE_1ST_NAME  ,
	@BENE_LAST_NAME,
	@BENE_MIDL_NAME ,
	@BENE_ORGNL_ENTLMT_RSN_CD ,
	@BENE_ENTLMT_BUYIN_IND ,
	CASE WHEN (@BENE_PART_A_ENRLMT_BGN_DT = '')
	THEN NULL
	ELSE CONVERT(date, @BENE_PART_A_ENRLMT_BGN_DT)
	END,
    CASE WHEN (@BENE_PART_B_ENRLMT_BGN_DT = '')
	THEN NULL
	ELSE CONVERT(date, @BENE_PART_B_ENRLMT_BGN_DT)
	END,
	


    @BENE_LINE_1_ADR,

    @BENE_LINE_2_ADR,

    @BENE_LINE_3_ADR ,

    @BENE_LINE_4_ADR ,

    @BENE_LINE_5_ADR ,

    @BENE_LINE_6_ADR ,

    @GEO_ZIP_PLC_NAME ,

    @GEO_USPS_STATE_CD ,

    @GEO_ZIP5_CD ,

    @GEO_ZIP4_CD ,
	@SrcFileName  ,
	@FileDate ,
	@OriginalFileName,
	GETDATE(),
	--@CreateDate ,
	@CreateBy  ,
	GETDATE(),
	--@AstCreatedDate ,
	@AstCreatedBy,
	@BENE_MBI_ID  
)
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF8] TO [BoomiDbUser]
    AS [dbo];

