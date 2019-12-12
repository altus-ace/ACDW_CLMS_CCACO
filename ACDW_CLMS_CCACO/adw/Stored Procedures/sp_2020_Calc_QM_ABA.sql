


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ABA] 
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
		--Declare @MeasurementYear      INT        = 2019
		-- Declare Variables
	DECLARE @Metric					Varchar(20)		= 'ABA'
	DECLARE @RunDate				Date			= Getdate()
	DECLARE @RunTime				Datetime		= Getdate()
	DECLARE @Today					Date			= Getdate()
	DECLARE @TodayMth				Int				= Month(Getdate())
	DECLARE @TodayDay				Int				= Day(Getdate())
	DECLARE @Year				    INT			    =Year(Getdate())
	DECLARE @PrimSvcDate_Start		VARCHAR(20)		= Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End		VARCHAR(20)		= Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	-- TmpTable to store Denominator 
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT SUBSCRIBER_ID FROM [adw].[2020_tvf_Get_ActiveMembers] (@RunDate)
	WHERE AGE >= 18
	INTERSECT
	SELECT SUBSCRIBER_ID FROM [adw].[2020_tvf_Get_ActiveMembers] (@RunDate)
	WHERE AGE <= 74
	-- Insert into Denominator Header using TmpTable
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT  SUBSCRIBER_ID
	FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient','','','',CONCAT('1/1/', @Measurementyear - 1), CONCAT('12/31/', @MeasurementYear))
	
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT a.SUBSCRIBER_ID FROM @TmpTable1 a
	JOIN			@TmpTable2 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	
	-- Insert into Denominator Detail using TmpTable
	INSERT INTO		 @TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient','','','',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
	
	INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate FROM @TmpTable1 a
	JOIN			@TmpTable3 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	--SELECT DISTINCT SUBSCRIBER_ID FROM @TmpDenDetail
	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2
	DELETE FROM		@TmpTable3
		---------------------------------------
		--Generating Records to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate)
    SELECT DISTINCT A.SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('BMI', '', '', '', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
    WHERE	CASE
            WHEN A.[SUBSCRIBER_ID] IN (	SELECT B.SUBSCRIBER_ID
										FROM [adw].[2020_tvf_Get_ActiveMembers](@RunDate) B
									  )
            THEN 1 ELSE 0
            END = 1;
     INSERT INTO	 @TmpTable2(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate)
     SELECT DISTINCT A.SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate--, A.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
     FROM            [adw].[2020_tvf_Get_ClaimsByValueSet]('BMI Percentile', '', '', '', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A 
     WHERE CASE
           WHEN A.[SUBSCRIBER_ID] IN  ( SELECT B.SUBSCRIBER_ID
										FROM  [adw].[2020_tvf_Get_ActiveMembers] (@RunDate) B 
									  )
          THEN 1  ELSE 0
          END = 1;
	-- Insert into tmp Numerator Header 
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID)
    SELECT			DISTINCT SUBSCRIBER_ID
    FROM			@TmpTable1
    UNION
    SELECT			DISTINCT SUBSCRIBER_ID
    FROM			@TmpTable2
	-- Insert into Numerator Header using TmpTable
    INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
    SELECT			DISTINCT SUBSCRIBER_ID
    FROM			@TmpTable3 a
    INTERSECT
    SELECT			DISTINCT SUBSCRIBER_ID
    FROM			@TmpDenHeader b;
	
	-- Insert into tmp Numerator Detail 
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM			@TmpTable1
    UNION
    SELECT			DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM			@TmpTable2
	-- Insert into Numerator Detail using TmpTable
    INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			@TmpTable4 a
    INNER JOIN		@TmpDenDetail b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader
	SELECT			a.* 
	FROM			@TmpDenHeader a LEFT JOIN @TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			b.SUBSCRIBER_ID IS NULL 
		

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
EXEC [adw].[sp_2020_Calc_QM_ABA] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/