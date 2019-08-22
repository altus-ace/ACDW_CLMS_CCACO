

--CREATE TABLE tmp_AHR_ (
--	[URN] int identity NOT NULL,
--	[MBI] [varchar] (50) NULL,
--	[HICN] [varchar] (50) NOT NULL

CREATE VIEW [dbo].[vw_tmp_AHR_Population]
AS
  SELECT *
  FROM [adw].[AHR_Population_History] 
  WHERE LOAD_DATE = (SELECT MAX(LOAD_DATE) FROM [adw].[AHR_Population_History])
  AND ToSend = 'Y' 
	 
	 
	/**** delete 
	 SELECT DISTINCT 
            a.HICN, 
            c.[MBI], 
            a.FIRSTNAME, 
            a.LASTNAME, 
            a.[SEX], 
            a.[DOB]
            ,   
            --,c.[PrevBenFlag]
            --,c.[RS_ESRD]
            --,c.[RS_Disabled]
            --,c.[RS_AgedDual]
            --,c.[RS_AgedNonDual]
            --,c.[Demo_RS_ESRD]
            --,c.[Demo_RS_Disabled]
            --,c.[Demo_RS_AgedDual]
            --,c.[Demo_RS_AgedNonDual]
            --,c.[ESRD_RS]
            --,c.[DISABLED_RS]
            --,c.[DUAL_RS]
            --,c.[NONDUAL_RS]
            --,c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS] as CALC_RS
            --,c.[RS_ESRD]+c.[RS_Disabled]+c.[RS_AgedDual]+c.[RS_AgedNonDual] as HCC_RS 
            a.AHRGaps, 
            DATEDIFF(yy, a.DOB, GETDATE()) AS AGE
            ,
            --,c.[ELIG_TYPE] 
            a.TIN, 
            a.TIN_NAME, 
            a.NPI, 
            a.NPI_NAME, 
            d.PRIM_SPECIALTY
            ,
            --  ,a.PCP_Last18Mths
            --,b.SVC_DATE AS LAST_SVC_NPI_VISIT 
            GETDATE() AS RUN_DATE
     FROM adw.AHR
	

	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 adw.tmp_Active_Members a
          LEFT JOIN adw.vw_Mbr_Assigned_Summary c --Current_AssignedMembers
          ON a.HICN = c.HICN
          LEFT JOIN lst.LIST_PCP d ON a.NPI = d.PCP_NPI
     WHERE a.MBR_TYPE = 'A' -- Assigned Members Only
           AND a.DOD = '1900-01-01' -- Exclude Deaths
           AND a.Exclusion = 'N'
           --AND a.PCP > 0 -- Have had a PCP visit this year
           AND ELIG_TYPE <> 1 -- Exclude ESRD
           AND c.[RS_ESRD] + c.[RS_Disabled] + c.[RS_AgedDual] + c.[RS_AgedNonDual] < 1.2 -- Under Desired Benchmarch
           AND a.AHRGaps > 1 -- Number of Current Open Care Gaps
           AND a.HospiceCode = 0 -- 0/1, 1 has a Hospice Code
           AND a.PCP_Last18Mths = 1 -- 0/1, 1 has a PCP Visit in Last 18 Mths
           -- and a.HICN = 
           --AND a.PCP_Last12Mths = 1 -- 0/1, 1 has a PCP Visit in Last 12 Mths
           AND DATEDIFF(yy, a.DOB, GETDATE()) < 85 -- Exclude > 85
           AND d.PRIM_SPECIALTY IN
     (
           --'Anesthesiology'
           'Cardiology', 'Dermatology', 'Endocrinology and Metabolism'
           --,'Gastroenterology'
           --,'Gastroenterology & Hepatology'
           --,'General Surgery'
           , 'Hematology/Oncology', 'Internal Medicine', 'Nephrology'
           --,'Neurology'
           --,'Nuclear Medicine'
           , 'Obstetrics/GYN'
           --,'Ophthalmology'
           --,'Otorhinolaryngology (Ear, Nose & Throat)'
           --,'Pain Medicine'
           --,'Pathology'
           , 'PCP - Primary Care Physician'
           --,'Pediatric Neurology'
           --,'Pediatrics'
           --,'Pediatrics Neurology'
           , 'Physical Medicine and Rehabilitation'
           --,'Plastic Surgery'
           --,'Podiatric Surgery'
           --,'Podiatry'
           , 'Psychiatry', 'Pulmonology'
           --,'Radiation Oncology'
           , 'Rheumatology'
           --,'Urology'
           --,'Vascular Surgery'
     );
--ORDER BY a.TIN, a.NPI
--(c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC
--SELECT *
--FROM tmp_Active_Members
***/
