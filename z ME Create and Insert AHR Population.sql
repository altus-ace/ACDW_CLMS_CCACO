USE ACDW_CLMS_CCACO
GO

/*** 
Insert into AHR_Population_History
***/

/*** Re-Process Month End 
--If Re-Process, make sure to delete prior Process Data First
DECLARE @DEL_RUN_YEAR INT = 2018
DECLARE @DEL_RUN_MTH INT = 12
DECLARE @UPD_RUN_YEAR INT = 2018
DECLARE @UPD_RUN_MTH INT = 11

--DELETE
--	FROM AHR_Population_History
--WHERE RUN_YEAR = @DEL_RUN_YEAR AND RUN_MTH = @DEL_RUN_MTH

UPDATE AHR_Population_History
	SET RUN_YEAR = @UPD_RUN_YEAR,
		RUN_MTH = @UPD_RUN_MTH
WHERE RUN_YEAR = @DEL_RUN_YEAR AND RUN_MTH = @DEL_RUN_MTH

--SELECT RUN_YEAR, RUN_MTH, COUNT(URN)
--FROM AHR_Population_History
--GROUP BY RUN_YEAR, RUN_MTH
--ORDER BY RUN_YEAR, RUN_MTH
***/

/* 
Create TABLE AHR_Population_History
*/
--CREATE TABLE AHR_Population_History (
--	[URN] int identity NOT NULL,
--	[HICN] [varchar] (50) NOT NULL,
--	[MBI] [varchar] (50) NULL,
--	[FirstName] [varchar](50) NULL,
--	[LastName] [varchar](50) NULL,
--	[Sex] [varchar](1) NULL,
--	[DOB] date NULL,
--	[CurrentRS] decimal(5,4) NULL DEFAULT 0,
--	[CurrentDisplayGaps] int NULL DEFAULT 0,
--	[CurrentGaps] int NULL DEFAULT 0,
--	[Age] int NULL,
--	[TIN] [varchar](50) NULL,
--	[TIN_NAME] [varchar](50) NULL, 
--	[NPI] [varchar](50) NULL,
--	[NPI_NAME] [varchar](50) NULL,
--	[PRIM_SPECIALTY] [varchar](50) NULL,
--	[RUN_DATE] date NULL,
--	[RUN_YEAR] int NULL,
--  [RUN_MTH] int NULL,
--  [LOAD_DATE] date NULL,
--  [LOAD_USER] [varchar](50) NULL
--) ON [PRIMARY]
--GO

/* 
Insert TABLE AHR_Population_History
*/


INSERT INTO adw.[AHR_Population_History]
           ([HICN]
           ,[MBI]
           ,[FirstName]
           ,[LastName]
           ,[Sex]
           ,[DOB]
		   ,[CurrentRS]
		   ,[CurrentDisplayGaps]
		   ,[CurrentGaps]
           ,[Age]
		   ,[TIN]
		   ,[TIN_NAME]
		   ,[NPI]
		   ,[NPI_NAME]
		   ,[PRIM_SPECIALTY]
		   ,[RUN_DATE]
           ,[RUN_YEAR]
           ,[RUN_MTH]
           ,[LOAD_DATE]
           ,[LOAD_USER])
	SELECT   
		  DISTINCT a.HICN
		  ,c.[MBI]
		  ,a.[FirstName]
		  ,a.[LastName]
		  ,a.[Sex]
		  ,a.[DOB]   
		  ,c.[RS_ESRD]+[RS_Disabled]+c.[RS_AgedDual]+c.[RS_AgedNonDual] as CurrentRS
  	      ,a.AHRGaps
		  ,a.CurrentGaps
		  ,DATEDIFF(yy,a.DOB,GETDATE()) AS AGE
		  ,a.TIN
		  ,a.TIN_NAME
		  ,a.NPI
		  ,a.NPI_NAME
		  ,d.PRIM_SPECIALTY
		  ,GETDATE() as RUN_DATE
		  ,YEAR(GETDATE()) as RUN_YEAR
		  ,MONTH(GETDATE()) as RUN_MTH
		  ,GETDATE() as LOAD_DATE
		  ,'SNguyen-Manual' AS LOAD_USER
		FROM adw.tmp_Active_Members a 
		LEFT JOIN adw.[vw_Mbr_Assigned_Summary] c --Current_AssignedMembers
			ON a.HICN = c.HICN
			LEFT JOIN lst.LIST_PCP d ON a.NPI = d.PCP_NPI 
		WHERE a.Mbr_Type = 'A' -- Assigned Members Only
			AND a.DOD = '1900-01-01' -- Exclude Deaths
			AND a.exclusion = 'N'
			--AND a.PCP > 0 -- Have had a PCP visit this year
			AND ELIG_TYPE <> 1 -- Exclude ESRD
			AND c.[RS_ESRD]+c.[RS_Disabled]+c.[RS_AgedDual]+c.[RS_AgedNonDual] < 1.2 -- Under Desired Benchmarch
			AND a.AHRGaps > 1 -- Number of Open Care Gaps to be displayed on AHR
			AND a.HospiceCode = 0 -- 0/1, 1 has a Hospice Code
			AND a.PCP_Last18Mths = 1 -- 0/1, 1 has a PCP Visit in Last 18 Mths
			--AND a.PCP_Last12Mths = 1 -- 0/1, 1 has a PCP Visit in Last 12 Mths
			AND DATEDIFF(yy,a.DOB,GETDATE()) < 85 -- Exclude > 85
			AND d.PRIM_SPECIALTY IN 
			(
			--'Anesthesiology'[dbo].[AHR_HL7_Report_Detail_Dx]
			'Cardiology'
			,'Dermatology'
			,'Endocrinology and Metabolism'
			--,'Gastroenterology'
			--,'Gastroenterology & Hepatology'
			--,'General Surgery'
			,'Hematology/Oncology'
			,'Internal Medicine'
			,'Nephrology'
			--,'Neurology'
			--,'Nuclear Medicine'
			,'Obstetrics/GYN'
			--,'Ophthalmology'
			--,'Otorhinolaryngology (Ear, Nose & Throat)'
			--,'Pain Medicine'
			--,'Pathology'
			,'PCP - Primary Care Physician'
			--,'Pediatric Neurology'
			--,'Pediatrics'
			--,'Pediatrics Neurology'
			,'Physical Medicine and Rehabilitation'
			--,'Plastic Surgery'
			--,'Podiatric Surgery'
			--,'Podiatry'
			,'Psychiatry'
			,'Pulmonology'
			--,'Radiation Oncology'
			,'Rheumatology'
			--,'Urology'
			--,'Vascular Surgery'
			)
GO



/***
DECLARE @RUN_YEAR INT = 2018
DECLARE @RUN_MTH INT = 12

SELECT *
	FROM AHR_Population_History
WHERE RUN_YEAR = @RUN_YEAR AND RUN_MTH = @RUN_MTH
***/




