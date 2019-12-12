-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLF9](
	-- Add the parameters for the stored procedure here
   @HICN_MBI_XREF_IND VARCHAR(1),
   @CRNT_HIC_NUM varchar(11)
  ,@PRVS_HIC_NUM varchar(11)
  ,@PRVS_HICN_EFCTV_DT varchar(10)
  ,@PRVS_HICN_OBSLT_DT varchar(10)
  ,@BENE_RRB_NUM varchar(12)
  ,@SrcFileName varchar(100)
   ,@FileDate varchar(10)
   ,@originalFileName varchar(100)
     -- ,@CreateDate 
  ,@CreateBy varchar(20)

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
INSERT INTO [adi].[CCLF9]
(
       [HICN_MBI_XREF_IND]
	   ,[CRNT_HIC_NUM]
      ,[PRVS_HIC_NUM]
      ,[PRVS_HICN_EFCTV_DT]
      ,[PRVS_HICN_OBSLT_DT]
      ,[BENE_RRB_NUM]
      ,[SrcFileName]
      ,[FileDate]
      ,[originalFileName]
      ,[CreateDate]
      ,[CreateBy]

)
  VALUES
(
   @HICN_MBI_XREF_IND
   ,@CRNT_HIC_NUM
  ,@PRVS_HIC_NUM 
  ,CASE WHEN (@PRVS_HICN_EFCTV_DT = '')
  THEN NULL
  ELSE CONVERT(date, @PRVS_HICN_EFCTV_DT)
  END
 ,
  CASE WHEN (@PRVS_HICN_OBSLT_DT ='')
  THEN NULL
  ELSE CONVERT(date,  @PRVS_HICN_OBSLT_DT )
  END
  ,@BENE_RRB_NUM 
  ,@SrcFileName
  ,CASE WHEN (@FileDate = '')
  THEN NULL
  ELSE CONVERT(date ,@FileDate)
  END 
  ,@originalFileName
   , GETDATE()
	 -- ,@CreateDate 
      ,@CreateBy 
)
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportCCLF9] TO [BoomiDbUser]
    AS [dbo];

