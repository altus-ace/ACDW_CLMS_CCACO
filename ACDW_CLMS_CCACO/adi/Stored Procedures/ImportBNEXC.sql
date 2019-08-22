-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportBNEXC](
	-- Add the parameters for the stored procedure here
    @HeaderCode varchar(50),
	@FileCreationDate varchar(15),
	@HICN nvarchar(50),
	@FirstName nvarchar(50),
	@MiddleName nvarchar(50),
	@LastName nvarchar(50),
	@DOB varchar(10),
	@Gender nvarchar(10),
	@BeneExcReason nvarchar(100),
	@TrailerCode nvarchar(20),
	@FileCreationDate2 varchar(15),
	@RecordCount varchar(10),
--	@LOAD_DATE varchar(10),
	@LOAD_USER varchar(50),
	@MBI varchar(20),
	@PerformanceYear varchar(10),
	@SrcFileName varchar(100),
	@FileDate varchar(10),
	--@CreateDate [datetime] NULL,
	@CreateBy varchar(100),
	@OriginalFileName varchar(100)
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
INSERT INTO [adi].[BNEXC]
(
    [HeaderCode],
	[FileCreationDate],
	[HICN] ,
	[FirstName] ,
	[MiddleName] ,
	[LastName] ,
	[DOB] ,
	[Gender] ,
	[BeneExcReason] ,
	[TrailerCode] ,
	[FileCreationDate2] ,
	[RecordCount],
	[LOAD_DATE] ,
	[LOAD_USER],
	[MBI] ,
	[PerformanceYear],
	[SrcFileName] ,
	[FileDate] ,
	[CreateDate],
	[CreateBy] ,
	[OriginalFileName] 
	
)
  VALUES
(
    @HeaderCode ,
	CASE WHEN (@FileCreationDate = '')
	THEN NULL
	ELSE CONVERT(float, @FileCreationDate)
	END,
	CASE WHEN (@HICN = '')
	THEN NULL
	ELSE CONVERT(nvarchar, @HICN)
	END,
	@FirstName ,
	@MiddleName ,
	@LastName ,
	CASE WHEN (@DOB = '')
	THEN NULL
	ELSE CONVERT(float, @DOB)
	END,
	@Gender ,
	@BeneExcReason ,
	@TrailerCode ,
	CASE WHEN (@FileCreationDate2 = '')
	THEN NULL
	ELSE CONVERT(float, @FileCreationDate2)
	END,
	@RecordCount ,
	--CASE WHEN (@LOAD_DATE = '')
	--THEN NULL
	--ELSE CONVERT(date, @LOAD_DATE)
	--END,
	GETDATE(),
	@LOAD_USER ,
	@MBI,
	CASE WHEN (@PerformanceYear = '')
	THEN NULL
	ELSE CONVERT(int, @PerformanceYear)
	END,
	@SrcFileName ,
	CASE WHEN (@FileDate = '')
	THEN NULL
	ELSE CONVERT(date, @FileDate)
	END,
	GETDATE(),
	--@CreateDate [datetime] NULL,
	@CreateBy ,
	@OriginalFileName 

)
END

