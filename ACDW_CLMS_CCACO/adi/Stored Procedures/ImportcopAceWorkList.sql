-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CCACO CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportcopAceWorkList]
@srcFileName VARCHAR(150) ,
@loadDate VARCHAR(10) ,
@CreatedDate VARCHAR(10) ,
@CreatedBy [VARCHAR](50) ,
@Subscriber_ID [VARCHAR](50) NULL,
@Total_Gaps VARCHAR(5) NULL,
@PCPName VARCHAR(150) NULL,
@PCPPhone VARCHAR(200) NULL,
@PCPAddress VARCHAR(100) NULL,
@Last_Service_Date_for_Measure VARCHAR(10) NULL,
@Member_Name VARCHAR(150) NULL,
@Member_DOB VARCHAR(10)  NULL,
@Member_Zip VARCHAR(15) NULL,
@NPI VARCHAR(15) NULL,
@Measure VARCHAR(max) NULL,
@Plan [VARCHAR](20) NULL,
@Member_Phone VARCHAR(35) NULL,
@Last_Call_Date VARCHAR(10) NULL,
@Last_Outcome VARCHAR(200) NULL,
@First_Call_Date VARCHAR(10) NULL,
@First_Call_Type VARCHAR(20) NULL,
@First_Call_Outcome VARCHAR(200) NULL,
@Second_Call_Date VARCHAR(10) NULL,
@Second_Call_Type VARCHAR(20) NULL,
@Second_Call_Outcome VARCHAR(200) NULL,
@Third_Call_Date VARCHAR(10) NULL,
@Third_Call_Type VARCHAR(20) NULL,
@Third_Call_Outcome VARCHAR(200) NULL, --12
@Fourth_Call_Date VARCHAR(15) NULL, --11
@Fourth_Call_Type VARCHAR(20) NULL, --10
@Fourth_Call_Outcome VARCHAR(200) NULL, --9
@Rep_Comment VARCHAR(max) NULL, --8
@File_Update_Date VARCHAR(20) NULL, --7
@List_Generated_Date VARCHAR(20) NULL,  --6
@Latest_Outcome VARCHAR(500) NULL, --5
@Latest_Action VARCHAR(100) NULL, --4
@Latest_Action_Date VARCHAR(12) NULL, --3
@Latest_Rep VARCHAR(50) NULL, --2
@Priority_Weight INT  --1

            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ADD ACE ETL AUDIT
--	DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
--	SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
 --   EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 7,'ECAP Import Call Center Work List', @ActionStartDateTime, @SrcFileName, '[ACDW_CLMS_WLC_ECAP].[adi].[copAceWorkList]', '';
	--EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	 
--	IF @@ROWCOUNT = 0


If (@Subscriber_ID != '') 
    
--	BEGIN TRY
    -- Insert statements 
    INSERT INTO adi.copAceWorkList
    (
	[srcFileName] ,
	[loadDate] ,
	[CreatedDate],
	[CreatedBy] ,
	[Subscriber_ID] ,
	[Total_Gaps] ,
	[Last_Service_Date_for_Measure],
	[Member_Name] ,
	[Member_DOB] ,
	[Member_Zip] ,
	[NPI] ,
	[Measure],
	[Plan] ,
	[Member_Phone] ,
	[Provider_Name] ,
	[PCPAddress],
	[PCP_Phone],
	[Last_Call_Date],
	[Last_Outcome] ,
	[First_Call_Date] ,
	[First_Call_Type],
	[First_Call_Outcome] ,
	[Second_Call_Date] ,
	[Second_Call_Type],
	[Second_Call_Outcome],
	[Third_Call_Date] ,
	[Third_Call_Type],
	[Third_Call_Outcome] ,
	[Fourth_Call_Date] ,
	[Fourth_Call_Type],
	[Fourth_Call_Outcome] ,
	[Comments],
	[File_Update_Date],
	[List_Generated_Date], 
	[Latest_Outcome],
	[Latest_Action],
	[Latest_Action_Date],
	[Latest_Rep],
	[Priority_Weight]
	)
		
 VALUES  (
     
  @srcFileName ,

  CONVERT(date, GETDATE()),
--@loadDate ,
  CONVERT(date, GETDATE()),
--@CreatedDate ,
@CreatedBy ,
@Subscriber_ID ,
@Total_Gaps ,
CASE WHEN (@Last_Service_Date_for_Measure = '')
THEN NULL
ELSE CONVERT(date, @Last_Service_Date_for_Measure) 
END,
@Member_Name ,
--AceMetaData.adi.udf_GetCleanDate(AceMetaData.adi.udf_GetCleanString(@Member_DOB)),
CASE WHEN (@Member_DOB = '')
THEN NULL
ELSE CONVERT(date,@Member_DOB)
END,  

--CASE WHEN (LEN(@Member_DOB)  > 0)
--THEN CONVERT(date,@Member_DOB)
--ELSE NULL 
--END,

@Member_Zip ,
@NPI ,
@Measure ,
@Plan ,
@Member_Phone ,
@PCPName ,
@PCPAddress,
@PCPPhone,
CASE WHEN (@Last_Call_Date = '')
THEN NULL
ELSE CONVERT(date,@Last_Call_Date) 
END,
@Last_Outcome ,

CASE WHEN (@First_Call_Date = '')
THEN NULL
ELSE CONVERT(date, @First_Call_Date) 
END,
@First_Call_Type,
@First_Call_Outcome ,
CASE WHEN (@Second_Call_Date = '')
THEN NULL
ELSE CONVERT(date, @Second_Call_Date) 
END,
@Second_Call_Type,
@Second_Call_Outcome ,
CASE WHEN (@Third_Call_Date = '')
THEN NULL
ELSE CONVERT(date, @Third_Call_Date) 
END,
@Third_Call_Type,
@Third_Call_Outcome ,
CASE WHEN (@Fourth_Call_Date = '')
THEN NULL
ELSE CONVERT(date, @Fourth_Call_Date) 
END,
@Fourth_Call_Type,
@Fourth_Call_Outcome ,
@Rep_Comment,
CASE WHEN (@File_Update_Date = '')
THEN NULL
ELSE CONVERT(date, @File_Update_Date) 
END,
CASE WHEN (@List_Generated_Date = '')
THEN NULL
ELSE CONVERT(date, @List_Generated_Date) 
END,
@Latest_Outcome,
@Latest_Action,
CASE WHEN (@Latest_Action_Date = '')
THEN NULL
ELSE CONVERT(date, @Latest_Action_Date) 
END,
@Latest_Rep,
@Priority_Weight
)



  --BEGIN
 --  SET @ActionStopDateTime = GETDATE()
 --  EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   	
 -- END TRY



  --BEGIN CATCH 

  -- SET @ActionStopDateTime = GETDATE()
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,3   	

  --END CATCH 
    
END
GO
GRANT EXECUTE
    ON OBJECT::[adi].[ImportcopAceWorkList] TO [BoomiDbUser]
    AS [dbo];

