


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_W15] 
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
	
	DECLARE @Metric1				Varchar(20)	   = 'W15_0'
	DECLARE @Metric2				Varchar(20)	   = 'W15_1'
	DECLARE @Metric3				Varchar(20)	   = 'W15_2'
	DECLARE @Metric4				Varchar(20)	   = 'W15_3'
	DECLARE @Metric5				Varchar(20)	   = 'W15_4'
	DECLARE @Metric6				Varchar(20)	   = 'W15_5'
	DECLARE @Metric7				Varchar(20)	   = 'W15_6'
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
	DECLARE @TmpDenHeader0 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail0 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader0 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail0 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader0 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader2 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail2 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader2 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail2 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader2 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader3 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail3 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader3 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail3 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader3 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader4 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail4 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader4 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail4 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader4 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader5 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail5 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader5 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail5 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader5 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader1 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail1 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader1 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail1 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader1 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader6 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail6 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader6 as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail6 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader6 as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @DateAsAtMeasurementYear Date   = CONCAT('12/31/', @MeasurementYear)
	DECLARE @StartDateOfMeasurementYear Date   = CONCAT('1/1/', @MeasurementYear)
	---Calculating for Metrics for 'W15_0' Measure
	-- TmpTable to Calculate Headers and Details Denominator Values
	--Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT DISTINCT  a.SUBSCRIBER_ID,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear) a
	WHERE			 YEAR(DATEADD(MONTH, 15, DOB)) = @MeasurementYear;
    -- Insert into Denominator Header using TmpTable
    INSERT INTO		 @TmpDenHeader0(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    FROM			 @TmpTable1 a
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
    INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 0;
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader0(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader0(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 a
    LEFT JOIN		 @TmpNumHeader0 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail0(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader0 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader0
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader0
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric1 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric1 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail0
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END
	
	--Calculating for Metrics for 'W15_1' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
	-- TmpTable to Calculate Headers and Details Denominator Values
	--Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT DISTINCT  a.SUBSCRIBER_ID,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear) a
	WHERE			 YEAR(DATEADD(MONTH, 15, DOB)) = @MeasurementYear;
    -- Insert into Denominator Header using TmpTable
    INSERT INTO		 @TmpDenHeader1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    FROM			 @TmpTable1 a
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
    INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 1;
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader1(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader1 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader1(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader1 a
    LEFT JOIN		 @TmpNumHeader1 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader0 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader1
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader1
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric2 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric2 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail1
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END
	
	--Calculating for Metrics for 'W15_2' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;

	-- TmpTable to Calculate Headers and Details Denominator Values
	--Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT DISTINCT  a.SUBSCRIBER_ID,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear) a
	WHERE			 YEAR(DATEADD(MONTH, 15, DOB)) = @MeasurementYear;
    -- Insert into Denominator Header using TmpTable
    INSERT INTO		 @TmpDenHeader2(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    FROM			 @TmpTable1 a
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
    INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 2;
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader2(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader2 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader2(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader2 a
    LEFT JOIN		 @TmpNumHeader2 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail2(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader0 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader2
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader2
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric3,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric3 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail2
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END
	--Calculating for Metrics for 'W15_3' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
	--Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 3;
	---Calculating Values for Numerator Headers
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader0
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader1
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader2
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader3(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable2 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader3 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader3(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader3 a
    LEFT JOIN		 @TmpNumHeader0 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	--Insert into		 Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader3 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric4 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric4 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader3
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric4 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader3
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric4,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric4 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail3
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

	--Calculating for Metrics for 'W15_4' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
	DELETE FROM		 @TmpTable2;
    --Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 4;
	---Calculating Values for Numerator Headers
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader0
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader1
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader2
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader3
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader4(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable2 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader4(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 a
    LEFT JOIN		 @TmpNumHeader4 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	--Insert into		 Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail4(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader4 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric5 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric5 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader4
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric5  , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader4
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric5,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric5,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail4
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

	--Calculating for Metrics for 'W15_5' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
	DELETE FROM		 @TmpTable2;
    --Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 5;
	---Calculating Values for Numerator Headers
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader0
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader1
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader2
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader3
	EXCEPT
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpCOPHeader4
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader5(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable2 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader5(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 a
    LEFT JOIN		 @TmpNumHeader5 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	--Insert into		 Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail5(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader5 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric6 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric6  , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader5
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric6  , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader5
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric6,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric6,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail5
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END

	--Calculating for Metrics for 'W15_6' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
    INSERT INTO		 @TmpTable1(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate--, count(distinct PRIMARY_SVC_DATE) as visits 
    FROM
					 (
						SELECT *
						FROM [adw].[2020_tvf_Get_ActiveMembers](@StartDateOfMeasurementYear)
						WHERE AGE <= 3
					 ) a
    LEFT JOIN
					 (
						SELECT a.*
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Well-Care', '', '','', CONCAT('1/1/', @MeasurementYear - 100), CONCAT('12/31/', @MeasurementYear)) a
						JOIN [adw].[tvf_2020_Get_ProvSpec](1, 8, 11, 16, 37, 38) b 
						ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    AND				 DATEADD(MONTH, 15, DOB) >= b.PRIMARY_SVC_DATE
    GROUP BY		 a.SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    HAVING			 COUNT(DISTINCT PRIMARY_SVC_DATE) > 6;
	-- Insert into Numerator Header
    INSERT INTO		 @TmpNumHeader6(SUBSCRIBER_ID) --num headers
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpTable1 a
    INTERSECT
    SELECT			 b.SUBSCRIBER_ID
    FROM			 @TmpDenHeader0 b;
	-- Insert into CareOpp Header
    INSERT INTO		 @TmpCOPHeader2(SUBSCRIBER_ID)
    SELECT			 a.SUBSCRIBER_ID
    FROM			 @TmpDenHeader6 a
    LEFT JOIN		 @TmpNumHeader0 b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 b.SUBSCRIBER_ID IS NULL;
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail6(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader0 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric7 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader0
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric7 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader6
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric7 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader6
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric7,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader0
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric7 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail6
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
EXEC [adw].[sp_2020_Calc_QM_W15] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/