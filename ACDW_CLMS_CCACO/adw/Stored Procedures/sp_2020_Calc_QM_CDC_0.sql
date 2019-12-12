


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_CDC_0] 
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
	--Declare Variables
	
	DECLARE @Metric				Varchar(20)	   = 'CDC_0'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   = Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   = Datefromparts(YEAR(@MeasurementYear), 12, 31)
	DECLARE @StartDatePriorToMeasurementYear Date = CONCAT('12/31/', @MeasurementYear - 1)

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
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID)
	SELECT			 DISTINCT a.SUBSCRIBER_ID 
	FROM			 [adw].[2020_tvf_Get_ActiveMembers] (@StartDatePriorToMeasurementYear) a
	JOIN			 (
					 SELECT DISTINCT SUBSCRIBER_ID FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests','','','',CONCAT('1/1/', @MeasurementYear)
					 , CONCAT('12/31/', @MeasurementYear))
					 ) b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	WHERE			 AGE BETWEEN 18 AND 75;
	------Building For Headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT SUBSCRIBER_ID
    FROM            (
						SELECT A.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
						FROM
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM adw.tvf_get_claims_w_dates('Outpatient', 'ED', 'Nonacute Inpatient', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM adw.tvf_get_claims_w_dates('Observation', '', '', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					) A
    INNER JOIN
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM adw.tvf_get_claims_w_dates('Diabetes', '', '', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					) B 
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					) C
    GROUP BY		SUBSCRIBER_ID
    HAVING			(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
    AND				(COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);

	------Building For Details
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate    
    FROM			(            
						SELECT A.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM
					(	
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'ED', 'Nonacute Inpatient','', CONCAT('1/1/', @MeasurementYear - 1)
							   , CONCAT('12/31/', @MeasurementYear)) b
						UNION
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('Observation', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
                    ) A
   INNER JOIN
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					) B 
   ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					) C
   GROUP BY			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate
   HAVING			(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
   AND				(COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
   --Insert into Denominator Header using TmpTable
   INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
   SELECT DISTINCT A.SUBSCRIBER_ID
   FROM				[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
   JOIN				[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) B 
   ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
   INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
   SELECT DISTINCT SUBSCRIBER_ID
   FROM				[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear));
   INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)
   SELECT			a.SUBSCRIBER_ID
   FROM				@TmpTable1 a
   JOIN				@TmpTable2 b 
   ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
--Insert into Denominator Details using TmpTable
   INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
   SELECT DISTINCT	A.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
   FROM				[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
   JOIN				[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) B 
   ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
   INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
   SELECT DISTINCT SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
   FROM				[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear));
   INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
   SELECT			A.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
   FROM				@TmpTable1 a
   JOIN				@TmpTable3 b 
   ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	-- Clear out tmpTables to reuse
   DELETE FROM		@TmpTable1
   DELETE FROM		@TmpTable2
   DELETE FROM		@TmpTable3
	-- TmpTable to store Numerator Values
   INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
   SELECT DISTINCT	a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
   FROM				(
						SELECT *
						FROM
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE DESC) AS Ranks
						,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) a
					) b
    WHERE			Ranks = 1
					) a
    LEFT JOIN
					(
						SELECT DISTINCT  SEQ_CLAIM_ID, Code, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM
					(
						SELECT DISTINCT   SEQ_CLAIM_ID, 1 AS code, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Level Less Than 7.0', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT DISTINCT  SEQ_CLAIM_ID,  2 AS code, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', 'HbA1c Level 7.0-9.0', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT DISTINCT SEQ_CLAIM_ID, 3 AS code, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'HbA1c Level Greater Than 9.0','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear))
					)	A
					) C 
	ON				a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
    WHERE			c.code IN(1, 2, 3);
	
	-- Insert for Numerator Header 
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM			@TmpTable1
	-- Insert for Numerator Detail 
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate FROM @TmpTable1
	
	-- Insert into Numerator Header using TmpTable, with only members in the denominator
	INSERT INTO		 @TmpNumHeader
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable2 a 
	INTERSECT    
	SELECT			 b.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader  b
	-- Insert into Numerator Detail using TmpTable
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
	-- Insert into CareOpp Header
	INSERT INTO		 @TmpCOPHeader
	SELECT			 a.* 
	FROM			 @TmpDenHeader a 
	LEFT JOIN		 @TmpNumHeader b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			 b.SUBSCRIBER_ID IS NULL 
		
	IF				 @ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
	BEGIN
	---Insert DEN into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpDenHeader
	---Insert NUM into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric , 'NUM' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpNumHeader
	---Insert COP into Target Table QM Result By Member
	INSERT INTO		 [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
	SELECT			 SUBSCRIBER_ID, @Metric , 'COP' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
	FROM			 @TmpCOPHeader
	--Insert DEN into Target Table, Inserting Members with DEN at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,'0','0','1900-01-01', @Metric ,'DEN',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpDenHeader
	--Insert NUM into Target Table, Inserting Members with Numerator at Detail Level
	INSERT INTO		 [adw].[QM_ResultByValueCodeDetails_TESTING](
					 [ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
	SELECT			 @ClientKeyID, SUBSCRIBER_ID,ValueCodeSystem,ValueCode,ValueCodeSvcDate, @Metric ,'NUM',@RunDate ,@RunTime, SUSER_NAME(), GETDATE(), SUSER_NAME() 
	FROM			 @TmpNumDetail
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
EXEC [adw].[sp_2020_Calc_QM_CDC_0] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/