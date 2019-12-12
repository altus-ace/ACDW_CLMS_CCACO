


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_PCE] 
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
	
	DECLARE @Metric1			Varchar(20)	   = 'PCE_B'
	DECLARE @Metric2			Varchar(20)	   = 'PCE_S'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   = Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   = Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as table	(SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID varchar(50),EPISODE_DATE date )					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpTable4 as table		(SUBSCRIBER_ID varchar(50),SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date, Num int)
	DECLARE @TmpTable5 as table		(SUBSCRIBER_ID varchar(50), SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date , Num int)				
	DECLARE @TmpTable6 table		(SUBSCRIBER_ID varchar(50), SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date , Num int)				
	DECLARE @TmpTable7 as table		(SUBSCRIBER_ID varchar(50), SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date , Num int)				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	-- TmpTable to Calculate Denominator Values 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			 SUBSCRIBER_ID,'0','0','1900-01-01' 
	FROM			 [adw].[2020_tvf_Get_ActiveMembers] (@RunDate)
	WHERE			 AGE BETWEEN 40 AND 120
	
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE)--ValueCodeSystem, ValueCode, ValueCodeSvcDate,					
	SELECT			A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE AS EPISODE_DATE 
	FROM			(
						SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','',  CONCAT('1/1/',@year), CONCAT('11/30/',@year)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b 
						ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
						EXCEPT(
						SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b 
						ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
						UNION 
						SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '', '',CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b 
						ON ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
						AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
							 )
					)A
	UNION
	--Den cond 2 and cond 3 direct transfer , a and b are used for acute inpatient stay with the where statement and a and c are used to account for direct transfers: Acute Inpatient Discharge with 3 related lung conditions
	(
						SELECT DISTINCT  A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, 
						CASE WHEN c.ADMISSION_DATE IS NULL THEN a.SVC_TO_DATE 
						ELSE c.SVC_TO_DATE 
						END AS EpisodeDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis','',CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b
						ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) c 
						ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                        AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                        AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                        AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
						WHERE A.SEQ_CLAIM_ID NOT IN	(SELECT SEQ_CLAIM_ID
													FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear))
													 )
	)
	----Calculating DEN Values for Metric1 PCE_B
	INSERT INTO	 @TmpTable3(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM		 @TmpTable2
	-- Insert into Denominator Header using TmpTable
	INSERT INTO		 @TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a
	JOIN			 @TmpTable3 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	--Calculating to Denomination Values for Details
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE,ValueCodeSystem, ValueCode, ValueCodeSvcDate)					
	SELECT			A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE AS EPISODE_DATE ,ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM			(
						SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','',  CONCAT('1/1/',@year), CONCAT('11/30/',@year)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b 
						ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
						EXCEPT(
						SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b 
						ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
						UNION 
						SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '', '',CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b 
						ON ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
						AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
							 )
					)A
	UNION
	--Den cond 2 and cond 3 direct transfer , a and b are used for acute inpatient stay with the where statement and a and c are used to account for direct transfers: Acute Inpatient Discharge with 3 related lung conditions
	(
						SELECT DISTINCT  A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, 
						CASE WHEN c.ADMISSION_DATE IS NULL THEN a.SVC_TO_DATE 
						ELSE c.SVC_TO_DATE 
						END AS EpisodeDate,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) a
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis','',CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) b
						ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
						JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear)) c 
						ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                        AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                        AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                        AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
						WHERE A.SEQ_CLAIM_ID NOT IN	(SELECT SEQ_CLAIM_ID
													FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear))
													 )
	)
	-- -- Insert into Denominator Detail using TmpTable
	INSERT INTO		 @TmpDenDetail(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID,b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	JOIN			 @TmpTable4 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	
			-- Clear out tmpTables to reuse
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable3
	---Calculating Numerator Headers values for @Metric1 PCE_B
	INSERT INTO		 @TmpTable5(SUBSCRIBER_ID, SEQ_CLAIM_ID ,EPISODE_DATE, Den , Primary_Svc_Date_Med  , Num)--,ValueCodeSystem , ValueCode, ValueCodeSvcDate
	SELECT			 a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID,a.EPISODE_DATE , 1 AS DEN , b.PRIMARY_SVC_DATE , 
	CASE WHEN		 b.PRIMARY_SVC_DATE IS NULL THEN 0 
	ELSE 1 END AS NUM 
	FROM			 @TmpTable2 a 
	LEFT JOIN		 ( SELECT * FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Bronchodilator Medications', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear))) b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	AND				 a.EPISODE_DATE <= b.PRIMARY_SVC_DATE 
	AND				 abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=30 
	AND				 a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	--Calculating Numerator Headers values for @Metric1 PCE_B
	INSERT INTO		 @TmpTable6(SUBSCRIBER_ID)
	SELECT DISTINCT  SUBSCRIBER_ID 
	FROM			 (
						SELECT SUBSCRIBER_ID, SUM(DEN) AS DEN, SUM(NUM) AS NUM 
						, CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN)
						END AS PERC 
						FROM @TmpTable5 
						GROUP BY SUBSCRIBER_ID
						HAVING CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN) 
						END  =1
					 )A
	--Inserting into Numerator Headers
	INSERT	INTO	 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable6 a 
	INTERSECT
	SELECT			 b.SUBSCRIBER_ID
	FROM			 @TmpDenHeader  b
	--Inserting into COP Headers
	INSERT	INTO	 @TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader a 
	LEFT JOIN		 @TmpNumHeader b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			 b.SUBSCRIBER_ID IS NULL 
	
	SELECT			 *, CONCAT(@Metric1, '_DEN') ,@RUNDATE ,@RUNTIME , (SELECT SUM(b.DEN) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID)
	FROM			 @TmpDenHeader a
	
	SELECT			 *, CONCAT(@Metric1, '_NUM') ,@RUNDATE,@RUNTIME, (SELECT sum(b.NUM) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) 
	FROM			 @TmpNumHeader a
	
	SELECT			 *, CONCAT(@Metric1, '_COP') ,@RUNDATE ,@RUNTIME 
	FROM			 @TmpCOPHeader
	---- Clear out tmpTables to reuse
	DELETE FROM		 @TmpTable5
	DELETE FROM		 @TmpTable6
	---Calculating Numerator Details values for @Metric1 PCE_B
	INSERT INTO		 @TmpTable5(SUBSCRIBER_ID, SEQ_CLAIM_ID ,EPISODE_DATE, Den , Primary_Svc_Date_Med,Num,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID,a.EPISODE_DATE , 1 AS DEN , b.PRIMARY_SVC_DATE ,
	CASE WHEN		 b.PRIMARY_SVC_DATE IS NULL THEN 0 
	ELSE			 1 END AS NUM 
					 ,a.ValueCodeSystem , a.ValueCode, a.ValueCodeSvcDate
	FROM			 @TmpTable2 a 
	LEFT JOIN		 ( SELECT * FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Bronchodilator Medications', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear))) b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	AND				 a.EPISODE_DATE <= b.PRIMARY_SVC_DATE 
	AND				 abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=30 
	AND				 a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	--Calculating Numerator Details values for @Metric1 PCE_B
	INSERT INTO		 @TmpTable6(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  SUBSCRIBER_ID ,ValueCodeSystem , ValueCode, ValueCodeSvcDate
	FROM			 (
						SELECT SUBSCRIBER_ID, SUM(DEN) AS DEN, SUM(NUM) AS NUM ,ValueCodeSystem , ValueCode, ValueCodeSvcDate
						, CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN)
						END AS PERC 
						FROM @TmpTable5 
						GROUP BY SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate
						HAVING CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN) 
						END  =1
					 )A
	--Inserting into Numerator Details
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable6 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
			
	SELECT			 *, CONCAT(@Metric1, '_DEN') ,@RUNDATE ,@RUNTIME , (SELECT SUM(b.DEN) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID)
	FROM			 @TmpDenHeader a
	
	SELECT			 *, CONCAT(@Metric1, '_NUM') ,@RUNDATE,@RUNTIME, (SELECT sum(b.NUM) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) 
	FROM			 @TmpNumDetail a
	select * from @TmpNumDetail
			
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
	PRINT			'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END			

	---- Clear out tmpTables to reuse
	DELETE FROM		 @TmpTable5
	DELETE FROM		 @TmpTable6
	DELETE FROM		 @TmpNUMHeader
	DELETE FROM		 @TmpNumDetail
	DELETE FROM		 @TmpCOPHeader

	---Calculating Values for Metric2 PCE_S
	--Calculating for Numerator Values Headers
	INSERT INTO		 @TmpTable5(SUBSCRIBER_ID, SEQ_CLAIM_ID ,EPISODE_DATE, Den , Primary_Svc_Date_Med  , Num)--,ValueCodeSystem , ValueCode, ValueCodeSvcDate
	SELECT			 a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID,a.EPISODE_DATE , 1 AS DEN , b.PRIMARY_SVC_DATE , 
	CASE WHEN		 b.PRIMARY_SVC_DATE IS NULL THEN 0 
	ELSE			 1 END AS NUM 
	FROM			 @TmpTable2 a 
	LEFT JOIN		 ( SELECT * FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Systemic Corticosteroid Medications', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear))) b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	AND				 a.EPISODE_DATE <= b.PRIMARY_SVC_DATE 
	AND				 abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=14 
	AND				 a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	--Calculating for Numerator Values Headers
	INSERT INTO		 @TmpTable6(SUBSCRIBER_ID)
	SELECT DISTINCT  SUBSCRIBER_ID 
	FROM			 (
						SELECT SUBSCRIBER_ID, SUM(DEN) AS DEN, SUM(NUM) AS NUM 
						, CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN)
						END AS PERC 
						FROM @TmpTable5 
						GROUP BY SUBSCRIBER_ID
						HAVING CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN) 
						END  =1
					 )A
	--Inserting into Numerator Headers
	INSERT	INTO	 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable6 a 
	INTERSECT
	SELECT			 b.SUBSCRIBER_ID
	FROM			 @TmpDenHeader  b
	--Inserting into COP Headers
	INSERT	INTO	 @TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader a 
	LEFT JOIN		 @TmpNumHeader b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			 b.SUBSCRIBER_ID IS NULL 
	
	SELECT			 *, CONCAT(@Metric2, '_DEN') ,@RUNDATE ,@RUNTIME , (SELECT SUM(b.DEN) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID)
	FROM			 @TmpDenHeader a
	
	SELECT			 *, CONCAT(@Metric2, '_NUM') ,@RUNDATE,@RUNTIME, (SELECT sum(b.NUM) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) 
	FROM			 @TmpNumHeader a
	
	SELECT			 *, CONCAT(@Metric2, '_COP') ,@RUNDATE ,@RUNTIME 
	FROM			 @TmpCOPHeader
	---------

		---- Clear out tmpTables to reuse
	DELETE FROM		 @TmpTable5
	DELETE FROM		 @TmpTable6
	
	---Calculating Values for Metric2 PCE_S
	--Calculating for Numerator Values Details
	INSERT INTO		 @TmpTable5(SUBSCRIBER_ID, SEQ_CLAIM_ID ,EPISODE_DATE, Den , Primary_Svc_Date_Med, Num,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID,a.EPISODE_DATE , 1 AS DEN , b.PRIMARY_SVC_DATE,b.ValueCodeSystem , b.ValueCode, b.ValueCodeSvcDate,
	CASE WHEN		 b.PRIMARY_SVC_DATE IS NULL THEN NULL 
	ELSE			 PRIMARY_SVC_DATE END AS NUM 
	FROM			 @TmpTable2 a 
	LEFT JOIN		 ( SELECT * FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Systemic Corticosteroid Medications', '', '','', CONCAT('1/1/',@MeasurementYear), CONCAT('11/30/',@MeasurementYear))) b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	AND				 a.EPISODE_DATE <= b.PRIMARY_SVC_DATE 
	AND				 abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=14 
	AND				 a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	--Calculating for Numerator Values Details
	INSERT INTO		 @TmpTable6(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT			 SUBSCRIBER_ID ,ValueCodeSystem , ValueCode, ValueCodeSvcDate
	FROM			 (
						SELECT SUBSCRIBER_ID, SUM(DEN) AS DEN, SUM(NUM) AS NUM ,ValueCodeSystem , ValueCode, ValueCodeSvcDate
						, CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN)
						END AS PERC 
						FROM @TmpTable5 
						GROUP BY SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate
						HAVING CASE WHEN SUM(DEN)= 0 THEN 0 
						ELSE CONVERT(FLOAT,SUM(NUM))/SUM(DEN) 
						END  =1
					 )A
	--Inserting into Numerator Details
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable5 a
	INNER JOIN		 @TmpDenHeader b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
		
	SELECT			 *, CONCAT(@Metric2, '_DEN') ,@RUNDATE ,@RUNTIME , (SELECT SUM(b.DEN) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID)
	FROM			 @TmpDenHeader a
	
	SELECT			 *, CONCAT(@Metric2, '_NUM') ,@RUNDATE,@RUNTIME, (SELECT sum(b.NUM) FROM @TmpTable5 b WHERE b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) 
	FROM			 @TmpNumDetail a
	
	
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
EXEC [adw].[sp_2020_Calc_QM_PCE] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/