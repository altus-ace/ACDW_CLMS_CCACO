


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adw].[sp_2020_Calc_QM_FUH] 
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
	
	DECLARE @Metric				Varchar(20)	   = 'FUH_30'
	DECLARE @RunDate			Date		   = Getdate()
	DECLARE @RunTime			Datetime	   = Getdate()
	DECLARE @Today				Date		   = Getdate()
	DECLARE @TodayMth			Int			   = Month(Getdate())
	DECLARE @TodayDay			Int			   = Day(Getdate())
	DECLARE @Year				INT			   =Year(Getdate())
	DECLARE @PrimSvcDate_Start	VarChar(20)	   =Datefromparts(YEAR(@MeasurementYear), 1, 1)
	DECLARE @PrimSvcDate_End	Varchar(20)	   =Datefromparts(YEAR(@MeasurementYear), 12, 31)

	DECLARE @TmpTable1 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)					 
	DECLARE @TmpTable2 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)					
	DECLARE @TmpTable3 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)	
	DECLARE @TmpTable4 as Table		(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)				
	DECLARE @TmpDenHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)					
	DECLARE @TmpDenDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)					
	DECLARE @TmpNumHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)				
	DECLARE @TmpNumDetail as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)					
	DECLARE @TmpCOPHeader as Table	(SUBSCRIBER_ID VarChar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)					
	DECLARE @TblResult as Table		(METRIC Varchar(20), SUBSCRIBER_ID VarChar(20),ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodeSvcDate Date,SEQ_CLAIM_ID VARCHAR(30), PRIMARY_SVC_DATE DATE, ADMISSION_DATE DATE,DISCHARGE_DATE DATE)	
	DECLARE @DateAsOfMeasurementYear Date   = CONCAT('12/31/', @MeasurementYear)
	-- TmpTable to Calculate Denominator Values for Headers
	--Calculate for acute ip	@tableaip
    INSERT INTO		@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
    SELECT	DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE, a.SVC_TO_DATE--, ValueCodeSystem, ValueCode, ValueCodeSvcDate
    FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))a
	LEFT JOIN
					(
						SELECT  SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,SVC_TO_DATE
						FROM	[adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					)	b 
	ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
    WHERE			b.SEQ_CLAIM_ID IS NULL;
	--Calculate for mental health @tableMH for headers
     INSERT INTO	@TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT	DISTINCT SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE, a.SVC_TO_DATE--, ValueCodeSystem, ValueCode, ValueCodeSvcDate
	 FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Mental Health Diagnosis', 'Intentional Self-Harm', '', '',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A;
     --------Calculate for active Members into @TmpTable3
	 INSERT INTO	@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)--,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--@table1
     SELECT			SUBSCRIBER_ID, '0','0','1900-01-01'
     FROM			[adw].[2020_tvf_Get_ActiveMembers] (@DateAsOfMeasurementYear)
     WHERE			AGE BETWEEN 6 AND 120;
     ------Caculate merging Acute ip (@TmpTable1) and Mental Health (@TmpTable2) for headers
	 INSERT INTO	@TmpTable4 (SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate) @table2
     SELECT	DISTINCT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE,a.DISCHARGE_DATE
     FROM			@TmpTable1 a -- @tableAIP a
     JOIN			@TmpTable2 b --@tableMH b 
	 ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;
	 -- Insert into Denominator Header using TmpTable for headers
     INSERT INTO	@TmpDenHeader(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT	DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE, a.DISCHARGE_DATE --, ValueCodeSystem, ValueCode, ValueCodeSvcDate
     FROM			@TmpTable4 a---@table2 a
     JOIN			@TmpTable3 b --@table1
	 ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	 --Clear out tmpTables to reuse
	 DELETE FROM @TmpTable1
     DELETE FROM @TmpTable2
	 DELETE FROM @TmpTable3
	 DELETE FROM @TmpTable4

	 --TmpTable to Calculate Denominator Values for Details
	--Calculate for acute ip	@tableaip
	 INSERT INTO		@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT	DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE, a.SVC_TO_DATE, A.ValueCodeSystem, A.ValueCode, A.ValueCodeSvcDate
     FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Inpatient Stay', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))a
	 LEFT JOIN
					(
						SELECT  SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,SVC_TO_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
						FROM	[adw].[2020_tvf_Get_ClaimsByValueSet]('Nonacute Inpatient Stay', '', '','', CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear))
					)	b 
	 ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
     WHERE			b.SEQ_CLAIM_ID IS NULL;
	--Calculate for mental health @tableMH for Details
     INSERT INTO	@TmpTable2(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT	DISTINCT SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE, a.SVC_TO_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
	 FROM			[adw].[2020_tvf_Get_ClaimsByValueSet]('Mental Health Diagnosis', 'Intentional Self-Harm', '', '',CONCAT('1/1/', @MeasurementYear - 1), CONCAT('12/31/', @MeasurementYear)) A;
     --------Calculate for active Members into @TmpTable3
	 INSERT INTO	@TmpTable3(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodeSvcDate)--,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--@table1
     SELECT			SUBSCRIBER_ID, '0','0','1900-01-01'
     FROM			[adw].[2020_tvf_Get_ActiveMembers] (CONCAT('12/31/', @MeasurementYear))
     WHERE			AGE BETWEEN 6 AND 120;
     ------Caculate merging Acute ip (@TmpTable1) and Mental Health (@TmpTable2) for Details
	 INSERT INTO	@TmpTable4 (SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate)-- @table2
     SELECT	DISTINCT a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE,a.DISCHARGE_DATE, A.ValueCodeSystem, A.ValueCode, A.ValueCodeSvcDate
     FROM			@TmpTable1 a -- @tableAIP a
     JOIN			@TmpTable2 b --@tableMH b 
	 ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;
	 -- Insert into Denominator Details using TmpTable
     INSERT INTO	@TmpDenDetail(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT	DISTINCT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE, a.DISCHARGE_DATE , A.ValueCodeSystem, A.ValueCode, A.ValueCodeSvcDate
     FROM			@TmpTable4 a---@table2 a
     JOIN			@TmpTable3 b --@table1
	 ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
	 --select * from @TmpDenDetail
	  --Clear out tmpTables to reuse
	 DELETE FROM @TmpTable1
     DELETE FROM @TmpTable2
	 DELETE FROM @TmpTable3
	 DELETE FROM @TmpTable4
	  --Calculating for Numerator Values for headers
	 INSERT INTO	@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT			a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE,a.DISCHARGE_DATE--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     FROM			@TmpDenHeader a
     JOIN			[adw].[tvf_2020_Get_ProvSpec](26, 62, 68, '', '', '') b 
	 ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
     AND			ABS(DATEDIFF(day, a.DISCHARGE_DATE, b.PRIMARY_SVC_DATE)) <= 30;
	 -- Insert into Numerator Header using TmpTable
     INSERT INTO	@TmpNumHeader(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)--, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT			a.SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE
     FROM			@TmpTable1 a;
	 -- Calculating and Inserting into CareOpp Header
     INSERT INTO	@TmpCOPHeader(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)
     SELECT			a.SUBSCRIBER_ID,b.SEQ_CLAIM_ID, b.PRIMARY_SVC_DATE, b.ADMISSION_DATE,b.DISCHARGE_DATE
     FROM			@TmpDenHeader a
     LEFT JOIN		@TmpNumHeader b 
	 ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
     WHERE			b.SEQ_CLAIM_ID IS NULL;
	 --Inserting into CareOpp Header
     INSERT INTO	@TmpCOPHeader(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE)
     SELECT			a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE,a.DISCHARGE_DATE
     FROM
					(
						SELECT *
						FROM
					(
						SELECT *, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID ORDER BY PRIMARY_SVC_DATE DESC) AS Ranks
						FROM	@TmpDenHeader
					) z
						WHERE			Ranks = 1
					) a
     LEFT JOIN		@TmpNumHeader b 
	 ON				a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
     WHERE			b.SEQ_CLAIM_ID IS NULL;
	   --Clear out tmpTables to reuse
	 DELETE FROM @TmpTable1
      --Calculating for Numerator Values for Details
	 INSERT INTO	@TmpTable1(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT			a.SUBSCRIBER_ID,a.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE, a.ADMISSION_DATE,a.DISCHARGE_DATE, a.ValueCodeSystem, a.ValueCode, a.ValueCodeSvcDate
     FROM			@TmpDendetail a
     JOIN			[adw].[tvf_2020_Get_ProvSpec](26, 62, 68, '', '', '') b 
	 ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
     AND			ABS(DATEDIFF(day, a.DISCHARGE_DATE, b.PRIMARY_SVC_DATE)) <= 30;
	 -- Insert into Numerator Details using TmpTable
     INSERT INTO	@TmpNumDetail(SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate)
     SELECT			a.SUBSCRIBER_ID,SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE,DISCHARGE_DATE, ValueCodeSystem, ValueCode, ValueCodeSvcDate
     FROM			@TmpTable1 a;
		
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
EXEC [adw].[sp_2020_Calc_QM_FUH] '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]',2019,6
***/