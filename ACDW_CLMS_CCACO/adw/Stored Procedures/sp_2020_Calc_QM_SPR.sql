


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_SPR] 
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
	
	DECLARE @Metric1			Varchar(20)	   = 'SPR'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   = Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   = Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 
	DECLARE @TmpTable2 as table		(SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID varchar(50),EPISODE_DATE date )					
	DECLARE @TmpTable5 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpTable3 as Table		(Member VarChar(50), IESD_date Date, Prior730day Date,SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable4 as table		(Member VarChar(50), IESD_date Date,SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable6 as table		(SUBSCRIBER_ID varchar(50),SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date, Num int)
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
	WHERE			 AGE BETWEEN 42 AND 120
	--Calculating DEN Values for Headers and Details
	INSERT INTO		@TmpTable3(Member, IESD_date,Prior730day)--ValueCodeSystem, ValueCode, ValueCodeSvcDate,					
	SELECT			D.SUBSCRIBER_ID,D.EPISODE_DATE, D.prior730days 
	FROM			(
					SELECT DISTINCT C.SUBSCRIBER_ID, C.EPISODE_DATE, dateadd(day,-730,c.EPISODE_DATE) as prior730days
					FROM 
						(
						SELECT DISTINCT B.SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE, dense_rank() over (partition by SUBSCRIBER_ID order by EPISODE_DATE) as rank 
					FROM 
						(
						SELECT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE 
						FROM 
								(
								SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) a
								JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis', '',CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b 
								ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
	EXCEPT (
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '', CONCAT('7/1/',@MeasurementYear-1),'', CONCAT('6/30/',@MeasurementYear)) a
	JOIN   [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b 
	ON	   a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	UNION 
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM  [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) a
	JOIN  [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b 
	ON    ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
	AND   a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	)
	)A
	UNION
--Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
	(
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, a.SVC_TO_DATE as EpisodeDate
	FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) a
	JOIN   [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b
	ON	   a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	JOIN   [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) c
	ON	   a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.SEQ_CLAIM_ID<> c.SEQ_CLAIM_ID and a.SVC_TO_DATE <=c.ADMISSION_DATE and abs(datediff(day,a.SVC_TO_DATE,c.ADMISSION_DATE))<=1
	WHERE  A.SEQ_CLAIM_ID NOT IN (SELECT SEQ_CLAIM_ID FROM  [adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b )
	)

	)B
	)C where C.rank =1 
	)D
	--Calculating DEN Values for Headers and Details
	INSERT INTO		@TmpTable4(Member, IESD_date)
    SELECT			E.SUBSCRIBER_ID,E.EPISODE_DATE 
	FROM		    (
					SELECT DISTINCT C.SUBSCRIBER_ID, C.EPISODE_DATE
					FROM 
					(
					SELECT DISTINCT  B.SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE, dense_rank() over (partition by SUBSCRIBER_ID order by EPISODE_DATE) as rank 
					FROM 
					(
					SELECT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE 
					FROM
					(
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
					EXCEPT
					(
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					UNION
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
    				AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
    				)
    )A
    UNION
    --Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
    (
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, a.SVC_TO_DATE as EpisodeDate
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) c
    				ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.SEQ_CLAIM_ID<> c.SEQ_CLAIM_ID and a.SVC_TO_DATE <=c.ADMISSION_DATE and abs(datediff(day,a.SVC_TO_DATE,c.ADMISSION_DATE))<=1
    				WHERE A.SEQ_CLAIM_ID NOT IN (SELECT SEQ_CLAIM_ID FROM  [adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b )
    ) 
    
    )B
    )C where C.rank =1 
    )E
    -- -- Insert into Denominator Header using TmpTable
	INSERT INTO		 @TmpDenHeader(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			 a.*
	FROM			 @TmpTable1 a 
	JOIN			 (
						SELECT DISTINCT MEMBER 
						FROM (
								SELECT A.member, 
								CASE WHEN B.IESD_date <=A.prior730day THEN 0 ELSE 1 END AS is_den 
								FROM 		@TmpTable3 A
								LEFT JOIN   @TmpTable4 B 
								ON			A.member = B.member
							 ) A 
						WHERE  is_den = 1
					 ) b 
	ON				 a.SUBSCRIBER_ID = b.member	
	---Clear Tables to reuse
	DELETE FROM @TmpTable1
	-----Calculating Values for Num Headers
	INSERT INTO     @TmpTable1(SUBSCRIBER_ID)--,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT Member   
	FROM	 
					(
						SELECT DISTINCT A.member , A.IESD_date,	(SELECT count(B.SEQ_CLAIM_ID)
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Spirometry', '', '','',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) B 
									WHERE A.member =B.SUBSCRIBER_ID  
																 ) as cnt
	
						FROM		(SELECT * FROM (
													SELECT A.member, A.IESD_date,A.prior730day, 
													CASE WHEN B.IESD_date <=A.prior730day THEN 0 ELSE 1 END AS is_den 
													FROM  @TmpTable3 A
													LEFT JOIN  @TmpTable4 B 
													ON 		   A.member = B.member
													) A 
					   WHERE       is_den = 1
									) A
					)Z  
	WHERE			cnt >=1
	---Calculating Numerator Headers values 
	INSERT INTO		 @TmpTable5(SUBSCRIBER_ID)--,ValueCodeSystem , ValueCode, ValueCodeSvcDate
	SELECT			 SUBSCRIBER_ID
	FROM			 @TmpTable1
	--Inserting into Numerator Headers
	INSERT	INTO	 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable5 a 
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
	
	-----Calculating Values for Num Details
	--Calculating for Numerator Values Details
	DELETE FROM @TmpTable1
	DELETE FROM @TmpTable3
	DELETE FROM @TmpTable4
	DELETE FROM @TmpTable5
		--Calculating DEN Values for Details
	INSERT INTO		@TmpTable3(Member, IESD_date,Prior730day,ValueCodeSystem, ValueCode, ValueCodeSvcDate)				
	SELECT			D.SUBSCRIBER_ID,D.EPISODE_DATE, D.prior730days ,d.ValueCodeSystem, d.ValueCode, d.ValueCodeSvcDate
	FROM			(
					SELECT DISTINCT C.SUBSCRIBER_ID, C.EPISODE_DATE, dateadd(day,-730,c.EPISODE_DATE) as prior730days,ValueCodeSystem, ValueCode, ValueCodeSvcDate
					FROM 
						(
						SELECT DISTINCT B.SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE, dense_rank() over (partition by SUBSCRIBER_ID order by EPISODE_DATE) as rank 
						,ValueCodeSystem, ValueCode, ValueCodeSvcDate
					FROM 
						(
						SELECT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE ,ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM 
								(
								SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
								FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) a
								JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis', '',CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b 
								ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
	EXCEPT (
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '', CONCAT('7/1/',@MeasurementYear-1),'', CONCAT('6/30/',@MeasurementYear)) a
	JOIN   [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b 
	ON	   a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	UNION 
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM  [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) a
	JOIN  [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b 
	ON    ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
	AND   a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	)
	)A
	UNION
--Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
	(
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, a.SVC_TO_DATE as EpisodeDate,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM   [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) a
	JOIN   [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b
	ON	   a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	JOIN   [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) c
	ON	   a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.SEQ_CLAIM_ID<> c.SEQ_CLAIM_ID and a.SVC_TO_DATE <=c.ADMISSION_DATE and abs(datediff(day,a.SVC_TO_DATE,c.ADMISSION_DATE))<=1
	WHERE  A.SEQ_CLAIM_ID NOT IN (SELECT SEQ_CLAIM_ID FROM  [adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','', CONCAT('7/1/',@MeasurementYear-1), CONCAT('6/30/',@MeasurementYear)) b )
	)

	)B
	)C where C.rank =1 
	)D
	--Calculating DEN Values for Details
	INSERT INTO		@TmpTable4(Member, IESD_date,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			E.SUBSCRIBER_ID,E.EPISODE_DATE ,e.ValueCodeSystem, e.ValueCode, e.ValueCodeSvcDate
	FROM		    (
					SELECT DISTINCT C.SUBSCRIBER_ID, C.EPISODE_DATE,c.ValueCodeSystem, c.ValueCode, c.ValueCodeSvcDate
					FROM 
					(
					SELECT DISTINCT  B.SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE, dense_rank() over (partition by SUBSCRIBER_ID order by EPISODE_DATE) as rank 
					,ValueCodeSystem, ValueCode, ValueCodeSvcDate
					FROM 
					(
					SELECT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE ,ValueCodeSystem, ValueCode, ValueCodeSvcDate
					FROM
					(
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','', CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
					EXCEPT
					(
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
					UNION
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('ED', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
    				AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
    				)
    )A
    UNION
    --Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
    (
					SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, a.SVC_TO_DATE as EpisodeDate,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
    				FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) a
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('COPD', 'Emphysema', 'Chronic Bronchitis', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b 
					ON	 a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    				JOIN [adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '', '',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) c
    				ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.SEQ_CLAIM_ID<> c.SEQ_CLAIM_ID and a.SVC_TO_DATE <=c.ADMISSION_DATE and abs(datediff(day,a.SVC_TO_DATE,c.ADMISSION_DATE))<=1
    				WHERE A.SEQ_CLAIM_ID NOT IN (SELECT SEQ_CLAIM_ID FROM  [adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','',   CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) b )
    ) 
    
    )B
    )C where C.rank =1 
    )E
	INSERT INTO     @TmpTable1(SUBSCRIBER_ID)--,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT Member  -- ,ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM	 
					(
						SELECT DISTINCT A.member , A.IESD_date,(SELECT count(B.SEQ_CLAIM_ID)--,ValueCodeSystem, ValueCode, ValueCodeSvcDate
									FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Spirometry', '', '','',  CONCAT('1/1/',@MeasurementYear-100), CONCAT('6/30/',@MeasurementYear)) B 
									WHERE A.member =B.SUBSCRIBER_ID  
									GROUP BY ValueCodeSystem, ValueCode, ValueCodeSvcDate
																 ) as cnt
	
						FROM		(SELECT * FROM (
													SELECT A.member, A.IESD_date,A.prior730day, 
													CASE WHEN B.IESD_date <=A.prior730day THEN 0 ELSE 1 END AS is_den 
													FROM  @TmpTable3 A
													LEFT JOIN  @TmpTable4 B 
													ON 		   A.member = B.member
													) A 
					   WHERE       is_den = 1
									) A
					)Z  
	WHERE			cnt >=1
	
	---Calculating Numerator Details values 
	INSERT INTO		 @TmpTable5(SUBSCRIBER_ID,ValueCodeSystem , ValueCode, ValueCodeSvcDate)
	SELECT			 SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM			 @TmpTable1
	--Inserting into Numerator Details
	INSERT	INTO	 @TmpNumDetail(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			 @TmpTable5 a 
	JOIN			 @TmpDenHeader  b
	ON			     b.SUBSCRIBER_ID = a.SUBSCRIBER_ID
	
				
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