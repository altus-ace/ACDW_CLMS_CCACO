


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_W36] 
	-- Parameters for the stored procedure here
	--@ConnectionStringProd		NVarChar(100) = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_History]', Future Usage
	@ConnectionStringTest		Nvarchar(100) = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',
	@MeasurementYear			INT,
	@ClientKeyID				Varchar(2)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN

    --DECLARE @ClientKeyID			Varchar(2) = '6'
	--Declare @MeasurementYear INT = 2019
	-- Declare Variables
	DECLARE @Metric			    Varchar(20)	   = 'W36'
	DECLARE @RunDate		    Date		   = Getdate()
	DECLARE @RunTime		    Datetime	   = Getdate()
	DECLARE @Today			    Date		   = Getdate()
	DECLARE @TodayMth		    Int			   = Month(Getdate())
	DECLARE @TodayDay		    Int			   = Day(Getdate())
	DECLARE @Year				INT			   =Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   =Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   =Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	-- TmpTable to store Denominator 
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT SUBSCRIBER_ID FROM [adw].[2020_tvf_Get_ActiveMembers] (@RunDate)
	WHERE AGE BETWEEN 3 AND 6
	-- Insert into Denominator Header using TmpTable
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID FROM @TmpTable1
	
	-- Insert into Denominator Detail using TmpTable
	INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate FROM @TmpTable1
	

	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	--DELETE FROM		@TmpTable2

	-- TmpTable to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate)
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care','','','',CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
	
	-- Insert into Numerator Header using TmpTable
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM			@TmpTable1
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate 
	FROM			@TmpTable1
	
	-- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader
	SELECT			a.SUBSCRIBER_ID 
	FROM			@TmpTable2 a 
	INTERSECT    
	SELECT			b.SUBSCRIBER_ID 
	FROM			@TmpDenHeader  b
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			@TmpTable3 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader
	SELECT			a.* 
	FROM			@TmpDenHeader a LEFT JOIN @TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID is null 
		
	IF				@ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			SUBSCRIBER_ID, @Metric , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			SUBSCRIBER_ID, @Metric , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			SUBSCRIBER_ID, @Metric , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			@TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_TESTING](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			@TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		[adw].[QM_ResultByValueCodeDetails_TESTING](
					[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			@ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			@TmpNumDetail
	PRINT			'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END


COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH

END  

/***
Usage: 
EXEC [adw].[sp_2020_Calc_QM_W36] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/