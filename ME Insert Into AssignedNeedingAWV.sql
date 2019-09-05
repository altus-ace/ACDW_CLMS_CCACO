/*
10/02/2018 - Added Specialty to filter out by PCP vs Specialists

*/

USE ACDW_CLMS_CCACO
GO
--/*** Create Table to store Member AWV History ***/
--CREATE TABLE [dbo].Member_Assigned_AWV_History(
--	[URN] [int] IDENTITY(1,1) NOT NULL,
--	[RANK] [int] NOT NULL,
--	[HICN] [varchar](50) NOT NULL,
--	[FIRST_NAME] [varchar](50) NULL,
--	[LAST_NAME] [varchar](50) NULL,
--	[SEX] [varchar](1) NULL,
--	[DOB] [date] NULL,
--	[PREV_BEN_FLG] [int] NULL,
--	[CUR_AGE] [int] NULL,
--	[ELIG_TYPE] [varchar] (2) NULL,
--	[TIN] [varchar](50) NULL,
--	[TIN_NAME] [varchar](50) NULL,
--	[NPI] [varchar](50) NULL,
--	[NPI_NAME] [varchar](50) NULL,
--	[NPI_PRIM_SPECIALTY] [varchar](50) NULL,
--	[RUN_DATE] [date] NULL,
--	[RUN_YEAR] [int] NULL,
--	[RUN_MTH] [int] NULL,
--	[LOAD_DATE] [date] NULL,
--	[LOAD_USER] [varchar](50) NULL
--) ON [PRIMARY]

--ALTER TABLE [dbo].[Member_Assigned_AWV_History] ADD  DEFAULT (sysdatetime()) FOR [LOAD_DATE]
--ALTER TABLE [dbo].[Member_Assigned_AWV_History] ADD  DEFAULT (suser_sname()) FOR [LOAD_USER]

/*** Insert Into Member_AWV_History ***/
INSERT INTO adw.[Member_Assigned_AWV_History]
           ([RANK]
           ,[HICN]
           ,[FIRST_NAME]
           ,[LAST_NAME]
           ,[SEX]
           ,[DOB]
           ,[PREV_BEN_FLG]
           ,[CUR_AGE]
           ,[ELIG_TYPE]
           ,[TIN]
           ,[TIN_NAME]
           ,[NPI]
           ,[NPI_NAME]
           ,[NPI_PRIM_SPECIALTY]
           ,[RUN_DATE]
           ,[RUN_YEAR]
           ,[RUN_MTH]
           )

		SELECT TOP 100 PERCENT
			--c.[MBI]
			ROW_NUMBER() OVER ( ORDER BY (c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC) RANK
			  ,c.[HICN]
			  ,c.[FirstName]
			  ,c.[LastName]
			  ,c.[Sex]
			  ,c.[DOB]
			  --,c.[DOD]
			  --,c.[CountyName]
			  --,c.[StateName]
			  --,c.[CountyNumber]
			  --,c.[VoluntaryFlag]
			  --,c.[CBFlag]
			  --,c.[CBStepFlag]
			  ,c.[PrevBenFlag]
			  --,c.[PartDFlag]
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
			  ,DATEDIFF(yy,c.DOB,GETDATE()) AS AGE
			  ,c.[ELIG_TYPE]
			  --,c.[LAST_NPI]
			  --,c.[LAST_NPI_NAME]
			  --,c.[SVC_DATE]
			  --,a.AWV
			  --,a.PCP
			  ,a.TIN
			  ,a.TIN_NAME
			  ,a.NPI
			  ,a.NPI_NAME
			  ,d.PRIM_SPECIALTY
			  ,GETDATE() as RUN_DATE
			  ,YEAR(GETDATE())
			  ,MONTH(GETDATE())
		FROM adw.tmp_Active_Members a 
		LEFT JOIN adw.[vw_Mbr_Assigned_Summary] c --Current_AssignedMembers
			ON a.HICN = c.HICN
			LEFT JOIN lst.[LIST_PCP] d
			ON a.NPI = d.PCP_NPI
		WHERE (a.AWV + a.PCP) = 0
		AND a.Mbr_Type = 'A'
		AND a.exclusion = 'N'
		AND a.DOD = '1900-01-01' -- Exclude Deaths
		AND d.PRIM_SPECIALTY = 'PCP - Primary Care Physician'
		AND ELIG_TYPE <> 1 -- Exclude ESRD
		AND DATEDIFF(yy,c.DOB,GETDATE()) > 40 -- Exclude Age Range
		ORDER BY (c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC


