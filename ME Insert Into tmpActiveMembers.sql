/****** Script for SelectTopNRows command from SSMS  ******/
USE ACDW_CLMS_CCACO
GO
/*select * from adw.tmp_active_members
1. Update each Beneficiary for 
	1. AW Visits in CY
	2. PCP Visits in CY
	3. IP Visits in CY
	4. ER Visits in CY
	5. Readmission Visits in CY
	6. Current Gaps in CL
2. Update TINs and NPIs for each Beneficiary
3. Update AHRGaps
*/
/*** Update - Set all Calculation to 0 ***/
--UPDATE adw.tmp_Active_Members 
--	SET 
--	AWV = 0
--	,PCP = 0
--	,IP = 0
--	,ER = 0
--	,RA = 0
--	,HospiceCode = 0
--	,PCP_Last18Mths = 0
--	,PCP_Last12Mths = 0
--FROM adw.tmp_Active_Members a
--GO

-- Annual Wellness Visit in Current Year
UPDATE adw.tmp_Active_Members 
	SET 
	AWV = 1
FROM adw.tmp_Active_Members a, (SELECT DISTINCT SUBSCRIBER_ID FROM adw.vw_AllMbrDetail_AWV_CY) b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- PCP Visit in Current Year
UPDATE adw.tmp_Active_Members 
	SET 
	PCP = 1
FROM adw.tmp_Active_Members a, (SELECT DISTINCT SUBSCRIBER_ID FROM adw.vw_AllMbrDetail_PCPVisit_CY) b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- Inpatient Visit in Current Year
UPDATE adw.tmp_Active_Members 
	SET 
	IP = 1
FROM adw.tmp_Active_Members a, (SELECT DISTINCT SUBSCRIBER_ID FROM adw.vw_AllMbrDetail_IPVisit_CY) b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- ER Visit in Current Year
UPDATE adw.tmp_Active_Members 
	SET 
	ER = 1
FROM adw.tmp_Active_Members a, (SELECT DISTINCT SUBSCRIBER_ID FROM adw.vw_AllMbrDetail_ERVisit_CY) b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- Readmission Visit in Current Year ****NEED TO FIX***
UPDATE adw.tmp_Active_Members 
	SET 
	RA = 1
FROM adw.tmp_Active_Members a, (SELECT DISTINCT SUBSCRIBER_ID FROM adw.vw_AllMbrDetail_Readmission_CY) b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- TIN and NPI 
UPDATE adw.tmp_Active_Members 
	SET 
	TIN = b.TIN,
	TIN_NAME = UPPER(b.TIN_NAME),
	NPI = b.NPI,
	NPI_NAME = UPPER(b.NPI_NAME)
FROM adw.tmp_Active_Members a, adw.vw_Mbr_Assigned_TIN_NPI b
WHERE a.HICN = b.HICN
GO

-- Current Care Gaps (Dependent on Care Gap Calculation)
UPDATE adw.tmp_Active_Members 
	SET 
	CurrentGaps = b.CurGaps
FROM adw.tmp_Active_Members a, (
	SELECT [HICN]
	,SUM([CntCG]) AS CurGaps
	FROM adw.[vw_QM_CareGap_By_Mbr_CL]
	GROUP BY HICN
	) b
WHERE a.HICN = b.HICN
GO

-- Beneficiary has a Hospice Code previously
UPDATE adw.tmp_Active_Members 
	SET 
	HospiceCode = 1
FROM adw.tmp_Active_Members a, (
	SELECT a.HICN, B.SUBSCRIBER_ID
	FROM adw.tmp_Active_Members a
	LEFT JOIN 
	  (select DISTINCT subscriber_id from adw.[tvf_get_claims_w_dates]('Hospice','' ,'','1/1/1900','12/31/2018' )) b
	ON  a.HICN = b.SUBSCRIBER_ID
	WHERE SUBSCRIBER_ID IS NOT NULL
	) b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- Beneficiary has a PCP visit in Last 18 mths
UPDATE adw.tmp_Active_Members 
	SET 
	PCP_Last18Mths = 1
FROM adw.tmp_Active_Members a, 
	adw.tmp_PCPVisit_Last18 b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- Beneficiary has a PCP visit in Last 12 mths
UPDATE adw.tmp_Active_Members 
	SET 
	PCP_Last12Mths = 1
FROM adw.tmp_Active_Members a, 
	adw.tmp_PCPVisit_Last18 b
WHERE a.HICN = b.SUBSCRIBER_ID
GO

-- Current Active QM Mapping Care Gaps (Dependent on Care Gap Calculation)
UPDATE adw.tmp_Active_Members 
	SET 
	AHRGaps = b.AHRGaps
FROM adw.tmp_Active_Members a, (
	SELECT [HICN]
	,SUM([CntCG]) AS AHRGaps
	FROM adw.[vw_QM_CareGap_By_Mbr_CL]
	INNER JOIN lst.LIST_QM_Mapping
	ON CGQM = QM
	WHERE ACTIVE = 'Y'
	GROUP BY HICN
	) b
WHERE a.HICN = b.HICN
GO

/*
SELECT *
FROM adw.tmp_Active_Members
WHERE exclusion = 'y'
*/
