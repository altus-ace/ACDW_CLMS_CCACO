


---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_CDC_7_9] 
--	-- Parameters for the stored procedure here
--	--@ConnectionStringProd		NVarChar(100) = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_History]', Future Usage
	@ConnectionStringTest		Nvarchar(100) = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',
	@MeasurementYear			INT,
	@ClientKeyID				Varchar(2)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
									
--	--DECLARE @ClientKeyID			Varchar(2) = '6'
--	--Declare @MeasurementYear INT = 2019
--	-- Declare Variables
	
	DECLARE @Metric1				Varchar(20)	   = 'CDC_9'
	DECLARE @Metric2				Varchar(20)	   = 'CDC_8'
	DECLARE @Metric3				Varchar(20)	   = 'CDC_7'
	DECLARE @RunDate				Date		   = Getdate()
	DECLARE @RunTime				Datetime	   = Getdate()
	DECLARE @Today					Date		   = Getdate()
	DECLARE @TodayMth				Int			   = Month(Getdate())
	DECLARE @TodayDay				Int			   = Day(Getdate())
	DECLARE @Year					INT			   = Year(Getdate())
	DECLARE @PrimSvcDate_Start		VarChar(20)	   = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End		Varchar(20)	   = Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpTable3			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpTable4			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable5			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpTable6			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable7			as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpDenHeader9		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)				
	--DECLARE @TmpDenDetail9		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader9		as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail9		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader9		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	--DECLARE @TmpDenHeader7_9	as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	--DECLARE @TmpDenDetail7_9	as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader7_9	as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail7_9	as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader7_9	as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	--DECLARE @TmpDenHeader7		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	--DECLARE @TmpDenDetail7		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader7		as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail7		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader7		as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	
	DECLARE @DateAsAtMeasurementYear Date   = CONCAT('12/31/', @MeasurementYear)
	DECLARE @StartDateOfMeasurementYear Date   = CONCAT('1/1/', @MeasurementYear)

--	---Calculating for Metrics for 'CDC_9' Measure
--	-- TmpTable to Calculate Headers and Details Denominator Values
--	--Calculating for Headers Denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID)--, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT DISTINCT  a.SUBSCRIBER_ID--,'0','0','1900-01-01'
    FROM			 [adw].[2020_tvf_Get_ActiveMembers](@DateAsAtMeasurementYear) a
	JOIN
                     (
						SELECT DISTINCT SUBSCRIBER_ID--, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '', '',CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			 AGE BETWEEN 18 AND 75;
	--Calculating for Headers Denominator
    INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT  SUBSCRIBER_ID --, count(distinct SEQ_CLAIM_ID), count(distinct PRIMARY_SVC_DATE)
	FROM             (
						SELECT DISTINCT A.*
						FROM
					 (
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE--, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'ED', 'Nonacute Inpatient','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE--, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Observation', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					 )  A
    INNER JOIN
					 (
						SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE--, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					 ) B 
	ON				 A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					 ) C
    GROUP BY		 SUBSCRIBER_ID--, ValueCodeSystem , ValueCode , ValueCodeSvcDate 
    HAVING			 (COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
    AND				 (COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
	--Calculating for Headers Denominator
    INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT  A.SUBSCRIBER_ID--, A.SEQ_CLAIM_ID
    FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
    JOIN			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) B 
	ON				 A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
	--Calculating for Headers Denominator
	INSERT INTO		 @TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT  SUBSCRIBER_ID
    FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear));
    --Calculating for Headers Denominator
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID)
    SELECT DISTINCT a.SUBSCRIBER_ID
    FROM			(
						SELECT	*
						FROM
							(
								SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
								ORDER BY PRIMARY_SVC_DATE DESC) AS rank
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
							)	b
						WHERE rank = 1
					) a
    LEFT JOIN
					(
						SELECT DISTINCT SEQ_CLAIM_ID, code
						FROM
						(
							SELECT DISTINCT SEQ_CLAIM_ID, 1 AS code
							FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '','', '', concat('1/1/', @MeasurementYear), concat('12/31/', @MeasurementYear))
							UNION
							SELECT DISTINCT SEQ_CLAIM_ID, 2 AS code
							FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', concat('1/1/', @MeasurementYear), concat('12/31/', @MeasurementYear))
							UNION
							SELECT DISTINCT SEQ_CLAIM_ID, 3 AS code
							FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', concat('1/1/', @MeasurementYear), concat('12/31/', @MeasurementYear))
						)	A
						) C 
	ON				a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			c.code IN(1, 2, 3);

	--Inserting records into CDC_9 Den Table
    INSERT INTO		@TmpDenHeader9(SUBSCRIBER_ID)
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpTable1 a
    JOIN			@TmpTable2 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    JOIN			@TmpTable3 c
	ON				a.SUBSCRIBER_ID = c.SUBSCRIBER_ID;
	---Clear Tmp Tables for Reuse
	DELETE FROM		@TmpTable1
	DELETE FROM		@TmpTable2
	DELETE FROM		@TmpTable3
	DELETE FROM		@TmpTable4
	DELETE FROM		@TmpTable5
	--Calculating for CDC_9 Numerator Headers Values
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID) --num for 9 
    SELECT DISTINCT a.SUBSCRIBER_ID
    FROM            (
						SELECT DISTINCT *
						FROM
						(
							SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
							ORDER BY PRIMARY_SVC_DATE DESC) AS rank
							FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '','', '', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
						) b
						WHERE rank = 1
					) a
    LEFT JOIN
					(
						SELECT DISTINCT SEQ_CLAIM_ID, code
						FROM
							(
								SELECT DISTINCT  SEQ_CLAIM_ID, 1 AS code
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT DISTINCT SEQ_CLAIM_ID, 2 AS code
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT DISTINCT SEQ_CLAIM_ID, 3 AS code
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
							) A
							) C 
	ON				a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			c.code IN(1, 2);
	--Calculating Values for CDC_9
    --INSERT INTO		@TmpTable2 (SUBSCRIBER_ID) --@tablenumt9
    --SELECT			SUBSCRIBER_ID
    --FROM			@TmpTable1
	--Inserting Records into Num Table for CDC_9
    INSERT	INTO    @TmpNumHeader9(SUBSCRIBER_ID)
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpTable1 a
    INTERSECT
    SELECT			b.SUBSCRIBER_ID
    FROM			@TmpDenHeader9 b --@tableden b;
	--Inserting into CDC_9 CareOpps Tabls
    INSERT INTO		@TmpCOPHeader9(SUBSCRIBER_ID) --@tablecareop9
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpDenHeader9 A --@tableden a
    LEFT JOIN		@TmpNumHeader9 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			b.SUBSCRIBER_ID IS NULL;
	----Calculating Values for Numerator Details
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate) --num for 9 
    SELECT			a.SUBSCRIBER_ID, a.ValueCodeSystem , a.ValueCode , a.ValueCodeSvcDate
    FROM            (
						SELECT *
						FROM
						(
							SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
							ORDER BY PRIMARY_SVC_DATE DESC) AS rank, ValueCodeSystem , ValueCode , ValueCodeSvcDate
							FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '','', '', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
						) b
						WHERE rank = 1
					) a
    LEFT JOIN
					(
						SELECT  SEQ_CLAIM_ID, code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						FROM
							(
								SELECT   SEQ_CLAIM_ID, 1 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT  SEQ_CLAIM_ID, 2 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT  SEQ_CLAIM_ID, 3 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
							) A
							) C 
	ON				a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			c.code IN(1, 2);
	--Inserting Num Detail Values from tmp
    INSERT INTO		@TmpTable4 (SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate) 
    SELECT			SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    FROM			@TmpTable3
    INSERT	INTO    @TmpNumDetail9(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT			a.SUBSCRIBER_ID, b.ValueCodeSystem , b.ValueCode , b.ValueCodeSvcDate
    FROM			@TmpTable4 a
    JOIN			@TmpDenHeader9 B
    ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader9
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader9
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric1 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader9
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric1 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader9
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric1 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail9
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END
	
	--Calculating for Metrics for 'CDC_8' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2;
	DELETE FROM		 @TmpTable3;
	DELETE FROM		 @TmpTable4;
	-- TmpTable to Calculate Headers Num Values
	--Calculating for Headers Denominator 
	--CDC_8 Den is same as CDC_9 ie CDC 7_9 Family has a common denominator 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID)
    SELECT DISTINCT  a.SUBSCRIBER_ID
    FROM	         (
						SELECT DISTINCT *
						FROM
							(
								SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
								ORDER BY PRIMARY_SVC_DATE DESC) AS rank
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
							) b
						WHERE	rank = 1
					 ) a
    LEFT JOIN
					 (
						 SELECT DISTINCT SEQ_CLAIM_ID, code
						 FROM
							(
								SELECT DISTINCT  SEQ_CLAIM_ID, 1 AS code
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT DISTINCT SEQ_CLAIM_ID, 2 AS code
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT DISTINCT SEQ_CLAIM_ID, 3 AS code
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
							) A
					 ) C 
	ON				 a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			 c.code IN(1);
	--Calculating Values for Head Num
    INSERT INTO		 @TmpTable2(SUBSCRIBER_ID) -- @tablenumt7_9 --exclude results from 9 
    SELECT DISTINCT  SUBSCRIBER_ID
    FROM			 @TmpTable1
    EXCEPT
    SELECT DISTINCT  SUBSCRIBER_ID
	FROM			@TmpCOPHeader9--@tablecareop9;
	--Inserting Num Values into Num Table for CDC_8
    INSERT INTO		@TmpNumHeader7_9-- @tablenum7_9
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpTable2 a
    INTERSECT
    SELECT			b.SUBSCRIBER_ID
    FROM			@TmpDenHeader9 b --@tableden b;
	--Insert into CDC_8 Careopps Table
    INSERT INTO		@TmpCOPHeader7_9(SUBSCRIBER_ID)		--@tablecareop7_9
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpDenHeader9 a
    LEFT JOIN		@TmpNumHeader7_9 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			b.SUBSCRIBER_ID IS NULL;
	--Creating Values for Num Details
	INSERT INTO		 @TmpTable4(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)
    SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem , a.ValueCode , a.ValueCodeSvcDate
    FROM	         (
						SELECT DISTINCT *
						FROM
							(
								SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
								ORDER BY PRIMARY_SVC_DATE DESC) AS rank, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
							) b
						WHERE	rank = 1
					 ) a
    LEFT JOIN
					 (
						 SELECT DISTINCT SEQ_CLAIM_ID, code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						 FROM
							(
								SELECT DISTINCT  SEQ_CLAIM_ID, 1 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT DISTINCT SEQ_CLAIM_ID, 2 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								UNION
								SELECT DISTINCT SEQ_CLAIM_ID, 3 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
							) A
					 ) C 
	ON				 a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			 c.code IN(1);
	--Calculating Values for Detail Num
    INSERT INTO		 @TmpTable5(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate) -- @tablenumt7_9 --exclude results from 9 
    SELECT DISTINCT  SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
    FROM			 @TmpTable4
    EXCEPT
    SELECT DISTINCT  SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate
	FROM			@TmpCOPHeader9--@tablecareop9;
	--Inserting Num Values into Num Table for CDC_8
    INSERT INTO		@TmpNumDetail7_9(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)-- @tablenum7_9
    SELECT			a.SUBSCRIBER_ID, a.ValueCodeSystem , a.ValueCode , a.ValueCodeSvcDate
    FROM			@TmpTable5 a
    JOIN			@TmpDenHeader9 b --@tableden b;
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader9
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader7_9
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric2 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader7_9
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric2 ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader9
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric2 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail7_9
	PRINT			 'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			 'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END
	
	--Calculating for Metrics for 'CDC_7' Measure
	--Clear to reuse tmps
	DELETE FROM		 @TmpTable1;
	DELETE FROM		 @TmpTable2;
	DELETE FROM		 @TmpTable3;
	DELETE FROM		 @TmpTable4;
	DELETE FROM		 @TmpTable5;
	--Calculating Values for Num Header CDC_7
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID) --num for 7
    SELECT DISTINCT  a.SUBSCRIBER_ID
    FROM		     (
						SELECT DISTINCT *
						FROM
							(
								SELECT DISTINCT SUBSCRIBER_ID,SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
								ORDER BY PRIMARY_SVC_DATE DESC) AS rank
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
							) b
						WHERE rank = 1
					 ) a
   LEFT JOIN
					(
						SELECT DISTINCT SEQ_CLAIM_ID, code
						FROM
								(
									SELECT DISTINCT  SEQ_CLAIM_ID, 1 AS code
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
									UNION
									SELECT DISTINCT SEQ_CLAIM_ID, 2 AS code
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
									UNION
									SELECT DISTINCT SEQ_CLAIM_ID, 3 AS code
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								) A
					) C 
    ON				a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			c.code IN(2, 3);
	--Calculating Values for Num Head CDC_7
    INSERT INTO		@TmpTable2(SUBSCRIBER_ID)--@tablenumt7
    SELECT DISTINCT SUBSCRIBER_ID
    FROM			@TmpTable1;
	--Insert Num Values into CDC_7
    INSERT INTO		@TmpNumHeader7(SUBSCRIBER_ID)--@tablenum7
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpTable2 a
    INTERSECT
    SELECT			b.SUBSCRIBER_ID
    FROM			@TmpDenHeader9 b;
	--Insert COP Values into Headers
    INSERT INTO		@TmpCOPHeader7(SUBSCRIBER_ID)
    SELECT			a.SUBSCRIBER_ID
    FROM			@TmpDenHeader9 a
    LEFT JOIN		@TmpNumHeader7 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			b.SUBSCRIBER_ID IS NULL;
	--Calculating Detail Values for CDC_7 Measure
	INSERT INTO		 @TmpTable4(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate) --num for 7
    SELECT			 a.SUBSCRIBER_ID, a.ValueCodeSystem , a.ValueCode , a.ValueCodeSvcDate
    FROM		     (
						SELECT *
						FROM
							(
								SELECT SUBSCRIBER_ID,SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
								ORDER BY PRIMARY_SVC_DATE DESC) AS rank, ValueCodeSystem , ValueCode , ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
							) b
						WHERE rank = 1
					 ) a
   LEFT JOIN
					(
						SELECT  SEQ_CLAIM_ID, code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
						FROM
								(
									SELECT   SEQ_CLAIM_ID, 1 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
									UNION
									SELECT  SEQ_CLAIM_ID, 2 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
									UNION
									SELECT  SEQ_CLAIM_ID, 3 AS code, ValueCodeSystem , ValueCode , ValueCodeSvcDate
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
								) A
					) C 
    ON				a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			c.code IN(2, 3);
	--Calculating Values for Num Details CDC_7
    --Insert Num Details Values into CDC_7
    INSERT INTO		@TmpNumDetail7(SUBSCRIBER_ID, ValueCodeSystem , ValueCode , ValueCodeSvcDate)--@tablenum7
    SELECT			a.SUBSCRIBER_ID, a.ValueCodeSystem , a.ValueCode , a.ValueCodeSvcDate
    FROM			@TmpTable4 a
    JOIN			@TmpDenHeader9 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader9
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader7
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric3 , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader7
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric3,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader9
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric3 ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail7
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
EXEC [adw].[sp_2020_Calc_QM_CDC_7_9] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/