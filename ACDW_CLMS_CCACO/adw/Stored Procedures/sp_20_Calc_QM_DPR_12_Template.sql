CREATE PROCEDURE [adw].[sp_20_Calc_QM_DPR_12_Template]
@years INT,
@LOB Varchar(20)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
----------------------------------------------------------
--DECLARE @YEARS INT = 2019 
DECLARE @year INT = @years
DECLARE @QM Varchar(10) = 'DPR_12'
DECLARE @RUNDATE Date = getdate()
DECLARE @RUNTIME Datetime = getdate()
DECLARE @Today date = GETDATE()
DECLARE @Month int = MONTH(GETDATE())
DECLARE @day int = DAY(GETDATE())
DECLARE @FrstDY INT = 1
DECLARE @FrsDM INT = 1
DECLARE @ClientKeyID int = @LOB

DECLARE @Table1 as Table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20), Value_Code_Primary_Svc_Date Date)  --Active Members with Demo filters
DECLARE @Table2 as Table (SUBSCRIBER_ID Varchar(20))					--Additional Criteria for Denominator
DECLARE @Tableden as Table (SUBSCRIBER_ID Varchar(20))					--Denominator
DECLARE @Tablenumt as Table (SUBSCRIBER_ID Varchar(20))					--Bridge for Numerator
DECLARE @Tablenum as Table (SUBSCRIBER_ID Varchar(20))					--Numerator
DECLARE @Tablecareop as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @TableValueDen as Table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20), Value_Code_Primary_Svc_Date Date)
DECLARE @TableValueNumt as Table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20), Value_Code_Primary_Svc_Date Date)
DECLARE @TableValueNum as Table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20),Value_Code_Primary_Svc_Date Date)


INSERT INTO @Table1(SUBSCRIBER_ID)
SELECT SUBSCRIBER_ID FROM 
adw.tvf_get_active_members2(DATEFROMPARTS(Year(@Today),@Month,@day))
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
INSERT INTO		 @Table1(SUBSCRIBER_ID,Value_Code_System,Value_Code, Value_Code_Primary_Svc_Date) 
SELECT DISTINCT  A.SUBSCRIBER_ID, Value_Code_System, Value_Code, PRIMARY_SVC_DATE
FROM			 adw.tvf_get_claims_w_dates_2020('Major Depression and Dysthymia', '', '', DATEFROMPARTS(YEAR(@Today), @FrstDY, @FrsDM), datefromparts(@years,@Month,@day) ) a 
UNION 
SELECT DISTINCT	 A.SUBSCRIBER_ID, Value_Code_System, Value_Code, PRIMARY_SVC_DATE
FROM			 adw.tvf_get_claims_w_dates_2020('Ambulatory Outpatient Visits', 'Well-Care', '',  DATEFROMPARTS(YEAR(@Today), @FrstDY, @FrsDM), datefromparts(@years,@Month,@day)) a

--Inserting all Members with Claims at QM Headers Level
INSERT INTO		 @Tablenumt(SUBSCRIBER_ID)
SELECT			 SUBSCRIBER_ID 
FROM			 @Table1

--Inserting all Members with Claims at QM Detail Level
INSERT INTO		@TableValueNumt(SUBSCRIBER_ID,Value_Code_System,Value_Code, Value_Code_Primary_Svc_Date)
SELECT			SUBSCRIBER_ID, Value_Code_System, Value_Code, Value_Code_Primary_Svc_Date
FROM			@Table1

--Define Numerator Population, Insert into Numerator, Intersect Active Members with Members With Claims at the QM Headers Level.  
INSERT INTO	     @Tablenum
SELECT			 a.* 
FROM			 @Tablenumt a 
INTERSECT    
SELECT			 b.* 
FROM			 @Tableden  b

--Insert into Value Codes for Numerator using Denominator Population at the QM Details Level (Distinct Subscriber_ID will return aggregated value))
INSERT INTO		@TableValueNum(SUBSCRIBER_ID, Value_Code_System, Value_Code, Value_Code_Primary_Svc_Date)
SELECT			b.SUBSCRIBER_ID, a.Value_Code_System, a.Value_Code, a.Value_Code_Primary_Svc_Date
FROM			@TableValueNumt a 
INNER JOIN		@Tableden  b
ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

--Define CareOpp Population, Inserting Members with CAREOPP at the Headers Level
INSERT INTO		@Tablecareop
SELECT			a.* 
FROM			@Tableden a left join @tablenum b 
ON				a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 
WHERE			b.SUBSCRIBER_ID is null 

---Insert into Target Table, Inserting Population as DEN at Header Level
INSERT INTO		[adw].[QM_ResultByMember_History_Test]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
SELECT			*, @QM , 'DEN' ,@RUNDATE ,@RUNTIME , SUSER_NAME() 
FROM			@Tableden

---Insert into Target Table, Inserting Members with Numerator at Header Level
INSERT INTO	    [adw].[QM_ResultByMember_History_Test]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
SELECT		    *, @QM , 'NUM' ,@RUNDATE,@RUNTIME , SUSER_NAME() 
FROM			@Tablenum

--Insert into Target Table, Inserting Members with CAREOPPS at Header Level
INSERT INTO		[adw].[QM_ResultByMember_History_Test]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate],[CreateBy])
SELECT			*, @QM , 'COP' ,@RUNDATE ,@RUNTIME, SUSER_NAME() 
FROM			@Tablecareop


---Insert into Target Table, Inserting Members with Numerator at Detail Level
INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
				[ClientKey], [ClientMemberKey], [Value_Code_System],[Value_Code], [Value_Code_Primary_Svc_Date],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
SELECT			@ClientKeyID, SUBSCRIBER_ID, Value_Code_System,Value_Code,Value_Code_Primary_Svc_Date, @QM ,'NUM',@RUNDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME() 
FROM			@TableValueNum

---Insert into Target Table, Inserting Members with Denominator at Detail Level
INSERT INTO		[adw].[QM_ResultByValueCodeDetails_History](
				[ClientKey], [ClientMemberKey], [Value_Code_System],[Value_Code],[Value_Code_Primary_Svc_Date],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
SELECT			@ClientKeyID, SUBSCRIBER_ID,	'0','0','1900-01-01', @QM ,'DEN',@RUNDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME() 
FROM			@Tableden

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH
END

