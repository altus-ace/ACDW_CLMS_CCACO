/****** Script for SelectTopNRows command from SSMS  ******/
USE ACDW_CLMS_CCACO
GO

/*
1. DROP TABLE tmp_Active_Members
2. Create Table
3. Insert each Beneficiary from History where current year & qtr is the latest
*/
DROP TABLE adw.tmp_Active_Members

CREATE TABLE adw.tmp_Active_Members (
	[URN] int identity NOT NULL,
	[MBI] [varchar] (50) NULL,
	[HICN] [varchar] (50) NOT NULL,
	[MemberId] [varchar] (50) NOT NULL,					--Added 02/12/2019
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Sex] [varchar](1) NULL,
	[Member_Zip] [varchar] (5) NULL,
	[Member_Pod] [varchar] (5) NULL,
	[DOB] date NULL,
	[DOD] date NULL,
	[AgeGrp]	varchar (1) NULL,
	[Exclusion] [varchar](1) NULL DEFAULT 'N',
	[Mbr_Type] [varchar](1) NULL,
	[AWV] int NULL DEFAULT 0,
	[PCP] int NULL DEFAULT 0,
	[IP] int NULL DEFAULT 0,
	[ER] int NULL DEFAULT 0,
	[RA] int NULL DEFAULT 0,
	[CurrentGaps] int NULL DEFAULT 0,
	[HospiceCode] int NULL DEFAULT 0,
	[PCP_Last18Mths] int NULL DEFAULT 0,
	[PCP_Last12Mths] int NULL DEFAULT 0,
	[AHRGaps] int NULL DEFAULT 0,						-- Gaps to be displayed on AHR
	[TIN] [varchar](50) NULL,
	[TIN_NAME] [varchar](50) NULL, 
	[NPI] [varchar](50) NULL,
	[NPI_NAME] [varchar](50) NULL,
	[MBR_YEAR] int NULL,
    [MBR_QTR] int NULL,
	IPVisits_Last12Mths				int NULL,
	ERVisits_Last12Mths				int NULL,
	BedDays_Last12Mths				int NULL,
	Readmissions_Last12Mths	        int NULL,
	IP_FUP_Within_7_Days	        int NULL,
	ER_FUP_Within_7_Days	        int NULL,
	Last_PCP_Visit					date NULL,
	Last_PCP_NPI					varchar (20) NULL,
	Total_Cost_Last12Mths			money NULL,
	IP_Costs_Last12Mths				money NULL,
	ER_Costs_Last12Mths				money NULL,
	OP_Costs_Last12Mths				money NULL,
	Rx_Costs_Last12Mths				money NULL,
	Prim_Care_Costs_Last12Mths		money NULL,
	Behavioral_Costs_Last12Mths		money NULL,
	Other_Office_Costs_Last12Mths	money NULL,
	Total_Cost_CY					money NULL,
	IP_Costs_CY						money NULL,
	ER_Costs_CY						money NULL,
	OP_Costs_CY						money NULL,
	Rx_Costs_CY						money NULL,
	Prim_Care_Costs_CY				money NULL,
	Behavioral_Costs_CY				money NULL,
	Other_Office_Costs_CY			money NULL,
    [LOAD_DATE] date NULL,
    [LOAD_USER] [varchar](50) NULL
) ON [PRIMARY]
GO

INSERT INTO adw.tmp_Active_Members (
	[MBI]
	,[HICN]
	,[MemberId]
	,[FirstName]
	,[LastName]
	,[Sex]
	,[DOB]
	,[DOD]
	,[AgeGrp]
	,[Exclusion]
	,[Mbr_Type]
	,[MBR_YEAR]
	,[MBR_QTR]
	,[LOAD_DATE]
	,[LOAD_USER]
	)

SELECT [MBI]
	,[HICN]
	,[HICN]
	,[Fname]
	,[Lname]
	,[Sex]
	,[DOB]
	,[DOD]
	,CASE 
		WHEN DATEDIFF(yy, DOB, GETDATE()) < 22
			THEN 'A'
		WHEN DATEDIFF(yy, DOB, GETDATE()) BETWEEN 22
				AND 64
			THEN 'B'
		ELSE 'C'
		END
	,ISNULL((
			SELECT 'Y'
			FROM adi.[BNEXC] b
			WHERE LOAD_DATE = (
					SELECT MAX(LOAD_DATE)
					FROM adi.[BNEXC]
					)
				AND b.HICN = a.HICN
			), 'N') AS Exclusion
	,[Mbr_Type]
	,[MBR_YEAR]
	,[MBR_QTR]
	,[LOAD_DATE]
	,[LOAD_USER]
FROM [adw].[Assignable_Member_History] a
WHERE MBR_YEAR = (
		SELECT MAX(MBR_YEAR)
		FROM [adw].[Assignable_Member_History]
		)
	AND MBR_QTR = (
		SELECT MAX(MBR_QTR)
		FROM [adw].[Assignable_Member_History]
		WHERE MBR_YEAR = (
				SELECT MAX(MBR_YEAR)
				FROM [adw].[Assignable_Member_History]
				)
		)

GO




TRUNCATE TABLE adw.M_MEMBER_ENR
/*
Insert in M_MEMBER_ENR
*/
INSERT INTO adw.M_MEMBER_ENR (
	[SUBSCRIBER_ID]
	,[CLIENT_ID]
	,[M_First_Name]
	,[M_Last_Name]
	,[M_Gender]
	,[M_Date_Of_Birth]
	,[CLIENT_UNIQUE_SYSTEM_ID]
	,[MBR_YEAR]
	,[MBR_MTH]
	,[LOAD_DATE]
	,[LOAD_USER]
	)
SELECT [HICN]
	,'ACO_' + ISNULL((
			SELECT 'Y'
			FROM adi.[BNEXC] b
			WHERE LOAD_DATE = (
					SELECT MAX(LOAD_DATE)
					FROM [adi].[BNEXC]
					)
				AND b.HICN = a.HICN
			), 'N') AS Exclusion
	,[Fname]
	,[Lname]
	,(
		SELECT CASE [Sex]
				WHEN 1
					THEN 'M'
				WHEN 2
					THEN 'F'
				ELSE 'U'
				END
		) AS SEX
	,[DOB]
	,[MBI]
	,YEAR(GETDATE())
	,MONTH(GETDATE())
	,GETDATE() AS RUN_DATE
	,'Snguyen'
FROM adw.[Assignable_Member_History] a
WHERE MBR_YEAR = (
		SELECT MAX(MBR_YEAR)
		FROM adw.[Assignable_Member_History]
		)
	AND MBR_QTR = (
		SELECT MAX(MBR_QTR)
		FROM adw.[Assignable_Member_History]
		WHERE MBR_YEAR = (
				SELECT MAX(MBR_YEAR)
				FROM adw.[Assignable_Member_History]
				)
		)
GO





/*
SELECT *
FROM tmp_Active_Members
*/
