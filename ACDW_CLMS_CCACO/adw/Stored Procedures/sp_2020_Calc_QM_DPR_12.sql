CREATE PROCEDURE [adw].[sp_2020_Calc_QM_DPR_12]
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
	--Declare @ClientKeyID			Varchar(2) = '6'
	--Declare @MeasurementYear INT = 2019
	-- Declare Variables
DECLARE @Metric				Varchar(20)	= 'DPR_12'
DECLARE @RunDate				Date		= Getdate()
DECLARE @RunTime				Datetime	= Getdate()
DECLARE @Today					Date		= Getdate()
DECLARE @TodayMth				Int			= Month(Getdate())
DECLARE @TodayDay				Int			= Day(Getdate())
DECLARE @Year					INT			=Year(Getdate())
DECLARE @Month					int			= MONTH(GETDATE())
DECLARE @day					int			= DAY(GETDATE())
DECLARE @FrstDY					INT			= 1
DECLARE @FrsDM					INT			= 1
DECLARE @PrimSvcDate_Start		VarChar(20)	=Datefromparts(YEAR(@MeasurementYear), 1, 1)
DECLARE @PrimSvcDate_End		Varchar(20)	=Datefromparts(YEAR(@MeasurementYear), 12, 31)

DECLARE @Table1 as Table (SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodePrimarySvcDate Date, PRIMARY_SVC_DATE DATE)  --Active Members with Demo filters
DECLARE @Table2 as Table (SUBSCRIBER_ID Varchar(20))					--Additional Criteria for Denominator
DECLARE @Tableden as Table (SUBSCRIBER_ID Varchar(20))					--Denominator
DECLARE @Tablenumt as Table (SUBSCRIBER_ID Varchar(20))					--Bridge for Numerator
DECLARE @Tablenum as Table (SUBSCRIBER_ID Varchar(20))					--Numerator
DECLARE @Tablecareop as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @TableValueDen as Table (SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodePrimarySvcDate Date, PRIMARY_SVC_DATE DATE)
DECLARE @TableValueNumt as Table (SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20), ValueCodePrimarySvcDate Date, PRIMARY_SVC_DATE DATE)
DECLARE @TableValueNum as Table (SUBSCRIBER_ID varchar(20), ValueCodeSystem Varchar(20), ValueCode Varchar(20),ValueCodePrimarySvcDate Date, PRIMARY_SVC_DATE DATE)


INSERT INTO @Table1(SUBSCRIBER_ID)
SELECT SUBSCRIBER_ID FROM 
adw.[2020_tvf_Get_ActiveMembers](DATEFROMPARTS(Year(@Today),@Month,@day))
WHERE AGE BETWEEN 18 and 75
--Define Denominator Population, Inserting Denominator at QM Headers Level 
INSERT INTO		 @Tableden (SUBSCRIBER_ID)
SELECT			 a.SUBSCRIBER_ID 
FROM			 @Table1 a 

--Define Denominator Population, Inserting Denominator at QM Details Level
INSERT INTO		 @TableValueDen(SUBSCRIBER_ID)
SELECT			 a.SUBSCRIBER_ID 
FROM			 @Table1 a 

DELETE FROM		 @Table1
DELETE FROM		 @Table2

--Retrieving all Members with Claims
INSERT INTO		 @Table1(SUBSCRIBER_ID,ValueCodeSystem,ValueCode, PRIMARY_SVC_DATE) 
SELECT DISTINCT  A.SUBSCRIBER_ID, ValueCodeSystem, ValueCode, PRIMARY_SVC_DATE
FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Major Depression and Dysthymia', '', '','', @PrimSvcDate_Start, @PrimSvcDate_End ) a 
UNION 
SELECT DISTINCT	 A.SUBSCRIBER_ID, ValueCodeSystem, ValueCode, PRIMARY_SVC_DATE
FROM			 adw.[2020_tvf_Get_ClaimsByValueSet]('Ambulatory Outpatient Visits', 'Well-Care', '','',  @PrimSvcDate_Start, @PrimSvcDate_End) a

--Inserting all Members with Claims at QM Headers Level
INSERT INTO		 @Tablenumt(SUBSCRIBER_ID)
SELECT			 SUBSCRIBER_ID 
FROM			 @Table1

--Inserting all Members with Claims at QM Detail Level
INSERT INTO		@TableValueNumt(SUBSCRIBER_ID,ValueCodeSystem,ValueCode, PRIMARY_SVC_DATE)
SELECT			SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodePrimarySvcDate
FROM			@Table1

--Define Numerator Population, Insert into Numerator, Intersect Active Members with Members With Claims at the QM Headers Level.  
INSERT INTO	     @Tablenum
SELECT			 a.* 
FROM			 @Tablenumt a 
INTERSECT    
SELECT			 b.* 
FROM			 @Tableden  b

--Insert into Value Codes for Numerator using Denominator Population at the QM Details Level (Distinct Subscriber_ID will return aggregated value))
INSERT INTO		@TableValueNum(SUBSCRIBER_ID, ValueCodeSystem, ValueCode, ValueCodePrimarySvcDate)
SELECT			b.SUBSCRIBER_ID, a.ValueCodeSystem, a.ValueCode, a.ValueCodePrimarySvcDate
FROM			@TableValueNumt a 
INNER JOIN		@Tableden  b
ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

--Define CareOpp Population, Inserting Members with CAREOPP at the Headers Level
INSERT INTO		@Tablecareop
SELECT			a.* 
FROM			@Tableden a left join @tablenum b 
ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
WHERE			b.SUBSCRIBER_ID is null 

IF				@ConnectionStringTest = '[ACE-SDV-DB01].[ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_TESTING]'
BEGIN
---Insert into Target Table, Inserting Population as DEN at Header Level
INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
SELECT			*, @Metric , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
FROM			@Tableden

---Insert into Target Table, Inserting Members with Numerator at Header Level
INSERT INTO	    [adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
SELECT		    *, @Metric , 'NUM' ,@RUNDATE,@RUNTIME , SUSER_NAME() 
FROM			@Tablenum

--Insert into Target Table, Inserting Members with CAREOPPS at Header Level
INSERT INTO		[adw].[QM_ResultByMember_TESTING]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
SELECT			*, @Metric , 'COP' ,@RUNDATE ,@RUNTIME, SUSER_NAME() 
FROM			@Tablecareop


---Insert into Target Table, Inserting Members with Numerator at Detail Level
INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
				[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode], [ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
SELECT			@ClientKeyID, SUBSCRIBER_ID, ValueCodeSystem,ValueCode,ValueCodePrimarySvcDate, @Metric ,'NUM',@RUNDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME() 
FROM			@TableValueNum

---Insert into Target Table, Inserting Members with Denominator at Detail Level
INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
				[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode],[ValueCodePrimarySvcDate],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
SELECT			@ClientKeyID, SUBSCRIBER_ID,	'0','0','1900-01-01', @Metric ,'DEN',@RUNDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME() 
FROM			@Tableden
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

--SELECT DISTINCT  SUBSCRIBER_ID, ValueCodeSystem, ValueCode, PRIMARY_SVC_DATE
--select top 2 * FROM			 [adw].[2020_tvf_Get_ClaimsByValueSet]('Major Depression and Dysthymia', '', '','', '2018','2019' ) 
--select top 1 * from [adw].[QM_ResultByValueCodeDetails_History]