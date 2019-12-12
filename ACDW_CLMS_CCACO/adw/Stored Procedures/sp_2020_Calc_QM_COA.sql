


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_COA] 
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
	
	DECLARE @Metric1				Varchar(20)	   = 'COA_ACP'
	DECLARE @Metric2				Varchar(20)	   = 'COA_FSA'
	DECLARE @Metric3				Varchar(20)	   = 'COA_PA'
	DECLARE @Metric4				Varchar(20)	   = 'COA_MR'
	DECLARE @RunDate				Date		   = Getdate()
	DECLARE @RunTime				Datetime	   = Getdate()
	DECLARE @Today					Date		   = Getdate()
	DECLARE @TodayMth				Int			   = Month(Getdate())
	DECLARE @TodayDay				Int			   = Day(Getdate())
	DECLARE @Year					INT			   = Year(Getdate())
	DECLARE @PrimSvcDate_Start		VarChar(20)	   = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End		Varchar(20)	   = Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable5 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable6 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable7 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @DateAsAtMeasurementYear Date   = CONCAT('12/31/', @MeasurementYear)
	---Calculating for Metrics for 'COA_ACP' Measure
	-- TmpTable to Calculate Headers and Details Denominator Values
	--Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT DISTINCT  a.SUBSCRIBER_ID,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers](@DateAsAtMeasurementYear) a
	WHERE			 AGE between 66 and 120
    -- Insert into Denominator Header using TmpTable
    INSERT INTO		 @TmpDenHeader(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    	-- Insert into Denominator Details using TmpTable 
	INSERT INTO		 @TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    FROM			 @TmpTable1 a
    --Clear tmp tables for reuse
	DELETE FROM		@TmpTable1
	-- TmpTable to store Numerator Head Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT DISTINCT A.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Advance Care Planning', '','', '',  
					CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) A
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader a
    LEFT JOIN		 @TmpNumHeader b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	-- TmpTable to Calculate Numerator Values for Detail
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT A.SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Advance Care Planning', '','', '',  
					CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) A
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable2 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
			
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric1 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric1 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

	DELETE FROM      @TmpNumHeader
	DELETE FROM		 @TmpNumDetail
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2
	DELETE FROM		 @TmpCOPHeader

	---Calculating for Metrics for 'COA_FSA' Measure
	--Calculating Claims for Numerator Headers
	INSERT INTO		 @TmpTable1 (SUBSCRIBER_ID)
	SELECT DISTINCT	 a.SUBSCRIBER_ID
	FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Functional Status Assessment', '', '', ''
					 , CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) A
	LEFT JOIN		 [adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', ''
					 ,'',  CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) B 
	ON				 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 
	WHERE			 b.SEQ_CLAIM_ID IS NULL 
	---Inserting calculated values into Numerator Headers Values
    INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID)
    SELECT			 SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    INTERSECT 
    SELECT			 SUBSCRIBER_ID
    FROM			 @TmpDenHeader b;
	--Calculate and insert values for CareOpps
    INSERT INTO		 @TmpCOPHeader(SUBSCRIBER_ID)
    SELECT			 A.SUBSCRIBER_ID
    FROM			 @TmpDenHeader a
    LEFT JOIN		 @TmpNumHeader b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	----Calculating Claims for Numerator Details
	INSERT INTO		 @TmpTable2 (SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT	 a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Functional Status Assessment', '', '', '', CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) A
	LEFT JOIN		 [adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '','',  CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) B 
	ON				 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 
	WHERE			 b.SEQ_CLAIM_ID IS NULL 
		-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable2 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric2 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric2 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END		

	DELETE FROM      @TmpNumHeader
	DELETE FROM		 @TmpNumDetail
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2
	DELETE FROM		 @TmpCOPHeader

	--Calculating Metrics for Measure 'COA_PA'
	--Calculating for Numerator Values for Headers
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID) 
    SELECT DISTINCT  a.SUBSCRIBER_ID
	FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Pain Assessment', '', '','',  CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) A
	LEFT JOIN		 [adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '', '', CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) B 
	ON				 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 
	WHERE			 b.SEQ_CLAIM_ID is null 
   ---Inserting Values for Numerator Headers
   INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID)
   SELECT			 a.SUBSCRIBER_ID
   FROM				 @TmpTable1 a
   INTERSECT
   SELECT			 b.SUBSCRIBER_ID
   FROM				 @TmpDenHeader b;
   --Calculating for Careopps
   INSERT INTO		 @TmpCOPHeader(SUBSCRIBER_ID)
   SELECT			 a.SUBSCRIBER_ID
   FROM				 @TmpDenHeader a
   LEFT JOIN		 @TmpNumHeader b 
   ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
   WHERE			 b.SUBSCRIBER_ID IS NULL;
   --Calculating for Numerator Values for Details
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate) 
    SELECT DISTINCT  a.SUBSCRIBER_ID,a.ValueCodeSystem , a.ValueCode, a.ValueCodeSvcDate
	FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Pain Assessment', '', '','',  CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) A
	LEFT JOIN		 [adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '', '', CONCAT('1/1/',@MeasurementYear), CONCAT('12/31/',@MeasurementYear)) B 
	ON				 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 
	WHERE			 b.SEQ_CLAIM_ID IS NULL 
   -- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable2 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric3 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric3 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

	--Calculating Metrics for QM COA_MR
	DELETE FROM      @TmpNumHeader
	DELETE FROM		 @TmpNumDetail
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2
	DELETE FROM		 @TmpCOPHeader

	--Calculating for Numerator Values for Headers
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT DISTINCT A.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Transitional Care Management Services', '', '', '', CONCAT('1/1/',@year), CONCAT('12/31/',@year)) A
	LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '', '', CONCAT('1/1/',@year), CONCAT('12/31/',@year)) B 
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 
	WHERE			b.SEQ_CLAIM_ID IS NULL 
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT A.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Medication Review', '', '',  '',CONCAT('1/1/',@year), CONCAT('12/31/',@year)) A
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Medication List', '', '', '', CONCAT('1/1/',@year), CONCAT('12/31/',@year)) B 
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '','',  CONCAT('1/1/',@year), CONCAT('12/31/',@year)) C 
	ON				a.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID 
	WHERE			b.SEQ_CLAIM_ID IS NULL 
	--where a.PROV_SPEC in (select * from get_prov_spec) 
   INSERT INTO		 @TmpTable3(SUBSCRIBER_ID)
   SELECT			 SUBSCRIBER_ID
   FROM				 @TmpTable1
   UNION
   SELECT			 SUBSCRIBER_ID
   FROM				 @TmpTable2
   ---Inserting Values for Numerator Headers
   INSERT INTO		 @TmpNumHeader(SUBSCRIBER_ID)
   SELECT			 a.SUBSCRIBER_ID
   FROM				 @TmpTable3 a
   INTERSECT
   SELECT			 b.SUBSCRIBER_ID
   FROM				 @TmpDenHeader b;
   --Calculating for Careopps
   INSERT INTO		 @TmpCOPHeader(SUBSCRIBER_ID)
   SELECT			 a.SUBSCRIBER_ID
   FROM				 @TmpDenHeader a
   LEFT JOIN		 @TmpNumHeader b 
   ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
   WHERE			 b.SUBSCRIBER_ID IS NULL;

    --Calculating for Numerator Values for Details
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate) 
	SELECT DISTINCT A.SUBSCRIBER_ID,A.ValueCodeSystem , A.ValueCode, A.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Transitional Care Management Services', '', '', '', CONCAT('1/1/',@year), CONCAT('12/31/',@year)) A
	LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '', '', CONCAT('1/1/',@year), CONCAT('12/31/',@year)) B 
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 
	WHERE			b.SEQ_CLAIM_ID IS NULL 
	INSERT INTO		@TmpTable5(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT A.SUBSCRIBER_ID,A.ValueCodeSystem , A.ValueCode, A.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Medication Review', '', '',  '',CONCAT('1/1/',@year), CONCAT('12/31/',@year)) A
	JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Medication List', '', '', '', CONCAT('1/1/',@year), CONCAT('12/31/',@year)) B 
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	LEFT JOIN		[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', 'Acute Inpatient POS', '','',  CONCAT('1/1/',@year), CONCAT('12/31/',@year)) C 
	ON				a.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID 
	WHERE			b.SEQ_CLAIM_ID IS NULL
	INSERT INTO		@TmpTable6(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
    SELECT			SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate
    FROM			@TmpTable4
    UNION
    SELECT			 SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate
    FROM			@TmpTable5
   -- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable6 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric4 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric4 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric4 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric4 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric4 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH

END  

/***
Usage: 
EXEC [adw].[sp_2020_Calc_QM_COA] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/