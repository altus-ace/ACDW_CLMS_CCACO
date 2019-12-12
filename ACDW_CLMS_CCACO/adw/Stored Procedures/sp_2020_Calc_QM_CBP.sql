


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_CBP] 
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
									--Declare @MeasurementYear		INT    = 2019
									--DECLARE @ClientKeyID			Varchar(2) = '6'
	-- Declare Variables
	DECLARE @Metric				Varchar(20)	   = 'CBP'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   =Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   =Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   =Datefromparts(YEAR(@MeasurementYear), 12, 31)
	DECLARE @StartDatePriorToMeasurementYear Date = CONCAT('1/1/', @MeasurementYear - 1)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,MaxDate DATE)	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	-- TmpTable to store Denominator --getActiveMembers does not have valuecode etc
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID, '0', '0', '' FROM [adw].[2020_tvf_Get_ActiveMembers] (@StartDatePriorToMeasurementYear) 
	WHERE AGE BETWEEN 18 AND 85
	--Generating Claim Values for Denominator for headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,MaxDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, MAX(a.PRIMARY_SVC_DATE) AS maxdate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient Without UBREV', 'Telephone Visits', 'Online Assessments','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) a
    JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Essential Hypertension', '', '','', concat('1/1/', @MeasurementYear - 1), concat('12/31/', @MeasurementYear)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    GROUP BY		a.SUBSCRIBER_ID
    HAVING			COUNT(DISTINCT a.PRIMARY_SVC_DATE) >= 2;
	--Generating Claim Values for Denominator for Details
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate, MaxDate)
    SELECT DISTINCT a.SUBSCRIBER_ID,a.ValueCodeSystem,a.ValueCode, a.ValueCodeSvcDate,MAX(a.PRIMARY_SVC_DATE) AS MaxDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient Without UBREV', 'Telephone Visits', 'Online Assessments','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) a
    JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Essential Hypertension', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) b
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    GROUP BY		a.SUBSCRIBER_ID, a.ValueCodeSystem,a.ValueCode,a.ValueCodeSvcDate
    HAVING			COUNT(DISTINCT a.PRIMARY_SVC_DATE) >= 2;
	
	-- Insert into Denominator Header using TmpTable	
    INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
    SELECT			DISTINCT a.SUBSCRIBER_ID
    FROM			@TmpTable1 a
    JOIN			@TmpTable2 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
   	-- Insert into Denominator Detail using TmpTable
	INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate
    FROM			@TmpTable1 a
    JOIN			@TmpTable3 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
		-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	--DELETE FROM		@TmpTable2
	--Generating Claim Values for Numerator
	--TmpTable to store Numerator Values for headers
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
    SELECT			a.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Systolic Less Than 140', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diastolic Less Than 80', 'Diastolic 80-89', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) b
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    JOIN            @TmpTable2 c
	ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
    AND				a.PRIMARY_SVC_DATE >= c.MaxDate;
		--TmpTable to store Numerator Values for Details
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Systolic Less Than 140', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diastolic Less Than 80', 'Diastolic 80-89', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) b
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    JOIN            @TmpTable3 c
	ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
    AND				a.PRIMARY_SVC_DATE >= c.MaxDate;
  -- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		@TmpNumHeader
	SELECT			DISTINCT a.SUBSCRIBER_ID 
	FROM			@TmpTable1 a 
	INTERSECT    
	SELECT			b.SUBSCRIBER_ID 
	FROM			@TmpDenHeader  b
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate
	FROM		    @TmpTable4 a
	INNER JOIN		@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	-- Insert into CareOpp Header
	INSERT INTO		@TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			a.SUBSCRIBER_ID 
	FROM			@TmpDenHeader a 
	LEFT JOIN		@TmpNumHeader b 
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
EXEC [adw].[sp_2020_Calc_QM_CBP] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/