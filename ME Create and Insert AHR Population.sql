USE ACDW_CLMS_CCACO
GO

/*** 
Insert into AHR_Population_History
***/


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
           ,[LOAD_USER]
		   ,[ToSend])
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
		  ,SUSER_NAME() AS LOAD_USER
		  ,'N'
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

/*** Update what to send ***/
UPDATE adw.[AHR_Population_History]
SET ToSend = 'Y'
	,SentDate = [LOAD_DATE]
WHERE LOAD_DATE = (
		SELECT MAX(LOAD_DATE)
		FROM adw.[AHR_Population_History]
		)
	AND HICN IN (
		SELECT new
		FROM (
			SELECT c.HICN new
				,s.HICN AS old
			FROM adw.[AHR_Population_History] c
			LEFT JOIN (
				SELECT HICN
					,RUN_MTH
					,run_year
				FROM adw.[AHR_Population_History]
				WHERE RUN_MTH IN (2)
					AND RUN_YEAR = 2019
				) s
				ON s.HICN = c.HICN
			WHERE c.RUN_MTH IN (3)
				AND c.RUN_YEAR = 2019
			) AS ss
		WHERE ss.old IS NULL
		)
/***
DECLARE @RUN_YEAR INT = 2018
DECLARE @RUN_MTH INT = 12

SELECT *
	FROM AHR_Population_History
WHERE RUN_YEAR = @RUN_YEAR AND RUN_MTH = @RUN_MTH
***/




