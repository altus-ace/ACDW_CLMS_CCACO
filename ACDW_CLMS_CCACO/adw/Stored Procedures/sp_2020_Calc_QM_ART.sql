


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_ART] 
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
	DECLARE @Metric				Varchar(20)		= 'ART'
	DECLARE @RunDate			Date			= Getdate()
	DECLARE @RunTime			Datetime		= Getdate()
	DECLARE @Today				Date			= Getdate()
	DECLARE @TodayMth			Int				= Month(Getdate())
	DECLARE @TodayDay			Int				= Day(Getdate())
	DECLARE @Year				INT			    = Year(Getdate())
	DECLARE @PrimSvcDate_Start	Varchar(20)	    = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	    = Datefromparts(YEAR(@MeasurementYear), 12, 31)

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
	-- TmpTable to store Denominator --getActiveMembers does not have valuecode etc
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID, '0', '0', '' FROM [adw].[2020_tvf_Get_ActiveMembers] (@RunDate)
	WHERE AGE BETWEEN 18 AND 120 
	-- Insert into Denominator Header TmpTable
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT SUBSCRIBER_ID
    FROM				(															--concat('1/1/', @year), concat('11/30/', @year)) 
						SELECT DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', '', '','', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) a
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Rheumatoid Arthritis', '', '', '',CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) b 
						ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
						UNION
						SELECT DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '', '', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) a
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Rheumatoid Arthritis', '', '','', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) b 
						ON				a.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient', '', '', '', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) c
						ON				A.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID
						) X
    GROUP BY			SUBSCRIBER_ID
    HAVING				COUNT(DISTINCT SEQ_CLAIM_ID) >= 2
    AND					COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2;
	-- Insert into Denominator Header using TmpTable
    INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
    SELECT			DISTINCT a.SUBSCRIBER_ID
    FROM			@TmpTable1 a
    JOIN            @TmpTable2 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
		-- Insert into Denominator Detail TmpTable
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM				(
						SELECT DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE,a.ValueCodeSystem,a.ValueCode,a.ValueCodeSvcDate
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', '', '','', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) a
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Rheumatoid Arthritis', '', '', '',CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) b 
						ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
						UNION
						SELECT DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE,a.ValueCodeSystem,a.ValueCode,a.ValueCodeSvcDate
						FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '', '', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) a
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Rheumatoid Arthritis', '', '','', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) b 
						ON				a.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
						JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient', '', '', '', CONCAT('1/1/', @MeasurementYear),CONCAT('11/30/', @MeasurementYear)) c
						ON				A.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID
						) X
    GROUP BY			SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
    HAVING				COUNT(DISTINCT SEQ_CLAIM_ID) >= 2
    AND					COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2;

	-- Insert into Denominator Detail using TmpTable
	INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate 
	FROM			@TmpTable1 a
	JOIN            @TmpTable3 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	--select * from @TmpDendetail
	-- Clear out tmpTables to reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2
	DELETE FROM		@TmpTable3

	-- TmpTable to store Numerator Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate)
	SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('DMARD','DMARD Medications','','',CONCAT('1/1/', @MeasurementYear),CONCAT('12/31/', @MeasurementYear))
		-- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a 
	INTERSECT    
	SELECT			 b.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader  b
	  	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate FROM @TmpTable1 a
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
EXEC [adw].[sp_2020_Calc_QM_ART] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/