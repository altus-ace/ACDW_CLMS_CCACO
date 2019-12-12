


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_PPC] 
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
	
	DECLARE @Metric1			Varchar(20)	   = 'PPC_Pre'
	DECLARE @Metric2			Varchar(20)	   = 'PPC_Post'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   = Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   = Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   = Datefromparts(YEAR(@MeasurementYear), 12, 31)
	DECLARE @DateOfMeasurementYear Date        = CONCAT('12/31/', @MeasurementYear)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20),SEQ_CLAIM_ID varchar(50), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					 			
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20),SEQ_CLAIM_ID varchar(50), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)	
	DECLARE @TmpTable3 as table		(SUBSCRIBER_ID varchar(50),SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date, Num int)
	DECLARE @TmpTable4 as table		(SUBSCRIBER_ID varchar(50), SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date , Num int)				
	DECLARE @TmpTable5 table		(SUBSCRIBER_ID varchar(50), SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date , Num int)				
	DECLARE @TmpTable6 as table		(SUBSCRIBER_ID varchar(50), SEQ_CLAIM_ID varchar(50) ,ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,CLAIM Varchar(50),EPISODE_DATE Date, Den Int, Primary_Svc_Date_Med date , Num int)				
	DECLARE @TmpTable11 as table	(SUBSCRIBER_ID varchar(20), delivery_date Date , firstTrimStart Date, firstTrimEnd Date, postStart Date, postEnd Date, ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpTable22 as table	(SUBSCRIBER_ID varchar(20), SEQ_CLAIM_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20))					
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date)					
	--Calculating Values for Metric1 PPC_Pre
	-- TmpTable to Calculate Denominator Values 
	INSERT INTO		 @TmpTable1(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			 SUBSCRIBER_ID,'0','0','1900-01-01' 
	FROM			 [adw].[2020_tvf_Get_ActiveMembers] (@DateOfMeasurementYear)
	----TmpTable to Calculate Denominator Values
	INSERT INTO		@TmpTable11(SUBSCRIBER_ID,Delivery_Date,FirstTrimStart,FirstTrimEnd,PostStart,PostEnd,ValueCodeSystem, ValueCode, ValueCodeSvcDate)	
	SELECT DISTINCT SUBSCRIBER_ID, PRIMARY_SVC_DATE as Delivery_Date, DATEADD(DAY, -280,PRIMARY_SVC_DATE) as FirstTrimStart, DATEADD(DAY, -176,PRIMARY_SVC_DATE) as FirstTrimEnd
					, DATEADD(DAY, 21, PRIMARY_SVC_DATE) as PostStart, DATEADD(DAY,56, PRIMARY_SVC_DATE) as PostEnd,ValueCodeSystem, ValueCode, ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Deliveries', '', '','', CONCAT('11/06/',@MeasurementYear-1), CONCAT('11/05/',@MeasurementYear))
	WHERE			SUBSCRIBER_ID   NOT IN (SELECT DISTINCT SUBSCRIBER_ID
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Non-live Births', '', '','', CONCAT('11/06/',@MeasurementYear-1), CONCAT('11/05/',@MeasurementYear)))
	INSERT INTO		@TmpTable2(SUBSCRIBER_ID )
	SELECT DISTINCT SUBSCRIBER_ID 
	FROM			@TmpTable11
	-- Insert into Denominator Header using TmpTable
	INSERT INTO		 @TmpDenHeader(SUBSCRIBER_ID)
	SELECT DISTINCT  a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a
	JOIN			 @TmpTable2 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	--Insert into Denominator Detail using TmpTable
	INSERT INTO		 @TmpDenDetail(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT			 a.SUBSCRIBER_ID,b.ValueCodeSystem, b.ValueCode, b.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
	JOIN			 @TmpTable2 b
	ON				 a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	---Clear tmp tables for reuse
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2
	---------------------
	
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)				
	SELECT			A.SUBSCRIBER_ID,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Prenatal Bundled Services', 'Stand Alone Prenatal Visits', '','',  CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.firstTrimStart AND b.firstTrimEnd

	INSERT INTO		@TmpTable22(SUBSCRIBER_ID, SEQ_CLAIM_ID,ValueCodeSystem, ValueCode, ValueCodeSvcDate)				
	SELECT			A.SUBSCRIBER_ID,a.SEQ_CLAIM_ID,a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Prenatal Visits', '', '','',  CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd

	INSERT INTO		@TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)				
	SELECT			A.SUBSCRIBER_ID,a.SEQ_CLAIM_ID--, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Obstetric Panel', 'Prenatal Ultrasound', '','',  CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd
	WHERE			a.SUBSCRIBER_ID IN (SELECT DISTINCT SUBSCRIBER_ID FROM @TmpTable22) 
	UNION 
	SELECT DISTINCT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID--,  a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Pregnancy Diagnosis', '', '','', CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd
	WHERE			a.SEQ_CLAIM_ID IN (SELECT DISTINCT SEQ_CLAIM_ID FROM @TmpTable22)  
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID,SEQ_CLAIM_ID--, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet_ValueSet]('Toxoplasma Antibody', 'Rubella Antibody', 'Cytomegalovirus Antibody','Herpes Simplex','','', CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd
	WHERE			a.SUBSCRIBER_ID IN (SELECT DISTINCT SUBSCRIBER_ID FROM @TmpTable22)  
	GROUP BY		a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID--,  a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	HAVING			COUNT(DISTINCT VALUE_SET_NAME) >=4
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID,SEQ_CLAIM_ID--, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet_ValueSet]('Rubella Antibody', 'ABO', '','', '','',CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd
	WHERE			a.SUBSCRIBER_ID IN (SELECT DISTINCT SUBSCRIBER_ID FROM @TmpTable22)  
	GROUP BY		a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID--,  a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	HAVING			COUNT(DISTINCT VALUE_SET_NAME) >=2	
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID,SEQ_CLAIM_ID--, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet_ValueSet]('Rubella Antibody', 'RH', '','','','', CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd
	WHERE			a.SUBSCRIBER_ID IN (SELECT DISTINCT SUBSCRIBER_ID FROM @TmpTable22)  
	GROUP BY		a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID--,  a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	HAVING			COUNT(DISTINCT VALUE_SET_NAME) >=2	
	UNION
	SELECT DISTINCT a.SUBSCRIBER_ID,SEQ_CLAIM_ID--, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet_ValueSet]('Rubella Antibody', 'ABO and RH', '','','','', CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.FirstTrimStart AND b.FirstTrimEnd
	WHERE			a.SUBSCRIBER_ID IN (SELECT DISTINCT SUBSCRIBER_ID FROM @TmpTable22)  
	GROUP BY		a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID--,  a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	HAVING			COUNT(DISTINCT VALUE_SET_NAME) >=2				
	---Calculating Values for Num Headers
	INSERT	INTO	 @TmpTable3(SUBSCRIBER_ID)
	SELECT			 SUBSCRIBER_ID 
	FROM			 @TmpTable1
	UNION
	SELECT			 SUBSCRIBER_ID 
	FROM			 @TmpTable2
	--Inserting into Numerator Headers
	INSERT	INTO	 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable3 a 
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
	---Calculating Values for Num Details
	INSERT	INTO	 @TmpTable4(SUBSCRIBER_ID,ValueCodeSystem, ValueCode,ValueCodeSvcDate)
	SELECT			 SUBSCRIBER_ID ,ValueCodeSystem, ValueCode,ValueCodeSvcDate
	FROM			 @TmpTable1
	UNION
	SELECT			 SUBSCRIBER_ID ,ValueCodeSystem, ValueCode,ValueCodeSvcDate
	FROM			 @TmpTable2
	--Inserting into Numerator Details
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable4 a
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
	PRINT			'This is a Test Environment'
	END
	ELSE
	
	BEGIN
	PRINT			'ConnectionString Parameter is not Valid, Transaction is incomplete'
	END			

	---Calculating Values for Metric2 PPC_Post
	--Calculating for Numerator Values Headers
	---- Clear out tmpTables to reuse
	DELETE FROM		 @TmpTable1
	DELETE FROM		 @TmpTable2
	DELETE FROM		 @TmpTable3
	DELETE FROM		 @TmpTable4
	DELETE FROM		 @TmpTable5
	DELETE FROM		 @TmpTable6
	DELETE FROM		 @TmpNUMHeader
	DELETE FROM		 @TmpNumDetail
	DELETE FROM		 @TmpCOPHeader
	--Calculating Values for Num Headers and Detail
	INSERT INTO		@TmpTable1(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
	FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Postpartum Visits', 'Cervical Cytology', 'Postpartum Bundled Services','', CONCAT('1/1/',@MeasurementYear-1), CONCAT('12/31/',@MeasurementYear)) a
	JOIN			@TmpTable11 b 
	ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
	AND				a.PRIMARY_SVC_DATE BETWEEN b.PostStart AND b.PostEnd
	--Inserting into Numerator Headers
	INSERT	INTO	 @TmpNumHeader(SUBSCRIBER_ID)
	SELECT			 a.SUBSCRIBER_ID 
	FROM			 @TmpTable1 a 
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
	--Inserting into Numerator Details
	INSERT INTO		 @TmpNumDetail(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
	SELECT DISTINCT  a.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate 
	FROM			 @TmpTable1 a
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
EXEC [adw].[sp_2020_Calc_QM_PPC] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/