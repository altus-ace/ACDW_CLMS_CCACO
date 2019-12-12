


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_SPD] 
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
	
	DECLARE @Metric1			Varchar(20)	   = 'SPD'
	DECLARE @Metric2			Varchar(20)	   = 'SPD_80'
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
	-- TmpTable to Calculate Values for Headers and Details Denominator
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, '0', '0', '' 
	FROM			[adw].[2020_tvf_Get_ActiveMembers] (@RunDate)a	
	WHERE			AGE BETWEEN 18 AND 75
	--Generating Claim Values for Denominator for Headers
	--Calculating Claims for Den Values for Headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID
    FROM            (
						SELECT A.*
						FROM
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'ED', 'Nonacute Inpatient','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Observation', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					)	A
    INNER JOIN
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID,  PRIMARY_SVC_DATE
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					) B 
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					) C
    GROUP BY		SUBSCRIBER_ID
    HAVING			(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
    AND				(COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
	----Calculating Claims for Den Values for Headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT A.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
    JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) B
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
	--Calculating Claims for Den Values for Headers
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID)
    SELECT DISTINCT SUBSCRIBER_ID
    FROM            [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear));  
	--Calculating Claims for Den Values for Headers
	INSERT INTO		@TmpTable3(SUBSCRIBER_ID)
    SELECT DISTINCT A.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('MI', 'CABG', 'PCI','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear - 1)) A
    UNION
    SELECT DISTINCT A.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Other Revascularization', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear - 1)) A
    UNION
					(
					SELECT DISTINCT A.SUBSCRIBER_ID
					FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '', '', '',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear - 1)) A
					INTERSECT
					SELECT DISTINCT A.SUBSCRIBER_ID
					FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A
					)
    UNION
	SELECT DISTINCT a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Pregnancy', 'IVF', 'Estrogen Agonists Medications','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ESRD', 'Cirrhosis', 'Advanced Illness','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'Dementia Medications', '',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('', 'Frailty', 'Muscular Pain and Disease','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A;
    -- Insert into Denominator Header using TmpTable
	INSERT INTO		 @TmpDenHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a
	JOIN			 @TmpTable2 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	EXCEPT
	SELECT			 SUBSCRIBER_ID 
    FROM			 @TmpTable3;
	-----Calculating for Den Details
	--Calculating Claims for Den Detail Values 
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate)
	SELECT			SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
    FROM            (
						SELECT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID,a.PRIMARY_SVC_DATE,a.ValueCodeSystem , a.ValueCode,a.ValueCodeSvcDate
						FROM
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE,ValueCodeSystem , ValueCode,ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Outpatient', 'ED', 'Nonacute Inpatient','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
						UNION
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE,ValueCodeSystem , ValueCode,ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Observation', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					)	A
    INNER JOIN
					(
						SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID,  PRIMARY_SVC_DATE,ValueCodeSystem , ValueCode,ValueCodeSvcDate
						FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					) B 
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
					) C
    GROUP BY		SUBSCRIBER_ID, ValueCodeSystem , ValueCode,ValueCodeSvcDate
    HAVING			(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
    AND				(COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
	--Calculating Claims for Den Detail Values 
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate)
    SELECT			A.SUBSCRIBER_ID,a.ValueCodeSystem , a.ValueCode,a.ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Acute Inpatient', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
    JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) B
	ON				A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
	--Calculating Claims for Den Detail Values 
	INSERT INTO		@TmpTable4(SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate)
    SELECT			SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
    FROM            [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes Medications', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear));  
	--Calculating Claims for Den Detail Values 
	INSERT INTO		@TmpTable5(SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate)
    SELECT			A.SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('MI', 'CABG', 'PCI','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear - 1)) A
    UNION
    SELECT			A.SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Other Revascularization', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear - 1)) A
    UNION
					(
					SELECT DISTINCT A.SUBSCRIBER_ID,A.ValueCodeSystem , A.ValueCode,A.ValueCodeSvcDate
					FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '', '', '',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear - 1)) A
					JOIN			[adw].[2020_tvf_Get_ClaimsByValueSet]('IVD', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) B
					ON				A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
					)
    UNION
	SELECT			a.SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Pregnancy', 'IVF', 'Estrogen Agonists Medications','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
	UNION
	SELECT			a.SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('ESRD', 'Cirrhosis', 'Advanced Illness','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
	UNION
	SELECT			a.SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('', '', 'Dementia Medications', '',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A
	UNION
	SELECT			a.SUBSCRIBER_ID,ValueCodeSystem , ValueCode,ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('', 'Frailty', 'Muscular Pain and Disease','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A;
   	-- Insert into Denominator Detail using TmpTable
	INSERT INTO		@TmpDenDetail(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			a.SUBSCRIBER_ID,b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate 
	FROM			@TmpTable1 a
	JOIN			@TmpTable4 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	EXCEPT
	SELECT			 SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM			 @TmpTable5;
			-- Clear out tmpTables to reuse
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2
	--Calculating Numerator Headers values for @Metric1 SPD
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
    SELECT DISTINCT A.SUBSCRIBER_ID
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('High and Moderate-Intensity Statin Medications', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A;
    --Inserting Numerator Headers
    INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
    SELECT			SUBSCRIBER_ID
	FROM			@TmpTable1
	INTERSECT
	SELECT			SUBSCRIBER_ID
	FROM			@TmpDenHeader
	--Inserting into COP Headers
    INSERT	INTO	 @TmpCOPHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpDenHeader a 
	LEFT JOIN		 @TmpNumHeader b 
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
	WHERE			 b.SUBSCRIBER_ID IS NULL  
	
	--Calculating Numerator Details values for @Metric1 SPD
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT DISTINCT A.SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('High and Moderate-Intensity Statin Medications', '', '','', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A;
    --Inserting Numerator Details
    INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			a.SUBSCRIBER_ID,a.ValueCodeSystem, A.ValueCode, A.ValueCodeSvcDate
	FROM			@TmpTable2 a
	JOIN			@TmpDenHeader b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	 

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
	
	--Calculating QM for Metric2 'SPD_80'
	--Clear tmp Tables for reuse
	DELETE FROM		@TmpCOPHeader
	DELETE FROM		@TmpDenDetail
	DELETE FROM		@TmpNumHeader
	DELETE FROM		@TmpNumDetail
	DELETE FROM		@TmpTable1	
	DELETE FROM		@TmpTable2	
	DELETE FROM		@TmpTable3	
	DELETE FROM		@TmpTable4	
	DELETE FROM		@TmpTable5
	--Calculating for DEN Header
	INSERT INTO		@TmpTable5(SUBSCRIBER_ID)--,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			SUBSCRIBER_ID
	FROM			@TmpDenHeader
	--Clear to Reuse Tmp Table
	DELETE FROM		@TmpDenHeader
	--Inserting DEN headers Values into tmp Table
	INSERT INTO		@TmpDenHeader(SUBSCRIBER_ID)--,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			SUBSCRIBER_ID
	FROM			@TmpTable5
	--Calculating Values for DEN Header Numerator
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID)
	SELECT DISTINCT SUBSCRIBER_ID
    FROM            (
						SELECT SUBSCRIBER_ID, SUM(rx_supply_dayyys) AS Total_Supply_Days, 
                        DATEDIFF(DAY, MIN(a.PRIMARY_SVC_DATE), CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31')) AS Total_Days_In_Treatment
						FROM
							(SELECT *, 
							 CASE
								WHEN DATEADD(DAY, RX_SUPPLY_DAYS, a.PRIMARY_SVC_DATE) > CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31')
								THEN DATEDIFF(DAY, a.PRIMARY_SVC_DATE, CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31'))
                                ELSE RX_SUPPLY_DAYS
								END AS RX_SUPPLY_DAYYYS
						     FROM
								(
								SELECT SUBSCRIBER_ID, b.SEQ_CLAIM_ID, PRIMARY_SVC_DATE, SUM(CAST(b.RX_SUPPLY_DAYS AS FLOAT)) AS RX_SUPPLY_DAYS
								FROM[adw].[2020_tvf_Get_ClaimsByValueSet]('High and Moderate-Intensity Statin Medications', '','Low-Intensity Statin Medications', '', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A
								JOIN
										(
										SELECT DISTINCT CLAIM_NUMBER, SEQ_CLAIM_ID, LINE_NUMBER, RX_SUPPLY_DAYS
										FROM adw.Claims_Details
										) b 
								ON		a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
								GROUP BY SUBSCRIBER_ID, b.SEQ_CLAIM_ID, PRIMARY_SVC_DATE
							   ) a
							) a
						GROUP BY SUBSCRIBER_ID
						HAVING	 (CAST(SUM(rx_supply_dayyys) AS FLOAT) / DATEDIFF(DAY, MIN(a.PRIMARY_SVC_DATE), CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31'))) >= .8
					) a;
	-----Calculating DEN Header Numerator Values
	--Calculating and Inserting DEN Header Numerators Values
    INSERT INTO		@TmpNumHeader(SUBSCRIBER_ID)
    SELECT			SUBSCRIBER_ID
	FROM			@TmpTable1 a
    INTERSECT
    SELECT			SUBSCRIBER_ID	b
    FROM			@TmpDenHeader b;
	--Inserting DEN COP Values
    INSERT INTO		@TmpCOPHeader(SUBSCRIBER_ID)
    SELECT			a.SUBSCRIBER_ID 
    FROM			@TmpDenHeader a
    LEFT JOIN		@TmpNumHeader b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    WHERE			b.SUBSCRIBER_ID IS NULL;
	--Calculating Numerator Values for Details
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM            (
						SELECT SUBSCRIBER_ID, SUM(rx_supply_dayyys) AS Total_Supply_Days, 
                        DATEDIFF(DAY, MIN(a.PRIMARY_SVC_DATE), CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31')) AS Total_Days_In_Treatment
						,ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM
							(SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate,
							 CASE
								WHEN DATEADD(DAY, RX_SUPPLY_DAYS, a.PRIMARY_SVC_DATE) > CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31')
								THEN DATEDIFF(DAY, a.PRIMARY_SVC_DATE, CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31'))
                                ELSE RX_SUPPLY_DAYS
								END AS RX_SUPPLY_DAYYYS
						     FROM
								(
								SELECT SUBSCRIBER_ID, b.SEQ_CLAIM_ID, PRIMARY_SVC_DATE, SUM(CAST(b.RX_SUPPLY_DAYS AS FLOAT)) AS RX_SUPPLY_DAYS,
								ValueCodeSystem, ValueCode, ValueCodeSvcDate
								FROM[adw].[2020_tvf_Get_ClaimsByValueSet]('High and Moderate-Intensity Statin Medications', '','Low-Intensity Statin Medications', '', CONCAT('1/1/', @MeasurementYear), CONCAT('12/31/', @MeasurementYear)) A
								JOIN
										(
										SELECT DISTINCT CLAIM_NUMBER, SEQ_CLAIM_ID, LINE_NUMBER, RX_SUPPLY_DAYS
										FROM adw.Claims_Details
										) b 
								ON		a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
								GROUP BY SUBSCRIBER_ID, b.SEQ_CLAIM_ID, PRIMARY_SVC_DATE,ValueCodeSystem, ValueCode, ValueCodeSvcDate
							   ) a
							) a
						GROUP BY SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate
						HAVING	 (CAST(SUM(rx_supply_dayyys) AS FLOAT) / DATEDIFF(DAY, MIN(a.PRIMARY_SVC_DATE), CONCAT(CONVERT(VARCHAR(4), @MeasurementYear), '-12-31'))) >= .8
					) a;
	--Calculating and Inserting DEN Details Numerators Values
    INSERT INTO		@TmpNumDetail(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT			b.SUBSCRIBER_ID,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			@TmpTable1 a
    JOIN			@TmpDenHeader b
    ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
    		
					
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
EXEC [adw].[sp_2020_Calc_QM_SPD] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/