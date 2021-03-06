/****** Script for SelectTopNRows command from SSMS  ******/
USE ACDW_CLMS_CCACO
GO

--/*** Create Table to store Member AWV History ***/
--CREATE TABLE [dbo].Member_Unassigned_AWV_History(
--	[URN] [int] IDENTITY(1,1) NOT NULL,
--	[HICN] [varchar](50) NOT NULL,
--	[FIRST_NAME] [varchar](50) NULL,
--	[LAST_NAME] [varchar](50) NULL,
--	[SEX] [varchar](1) NULL,
--	[DOB] [date] NULL,
--	[MBR_TYPE] [varchar] (20) NULL,
--	[AWV] [int] NULL,
--	[PCP] [int] NULL,
--	[ER] [int] NULL,
--	[IP] [int] NULL,
--	[RA] [int] NULL,
--	[GAPS] [int] NULL,
--	[LST_SVC_NPI] [varchar](50) NULL,
--	[LST_SVC_NAME] [varchar](50) NULL,
--	[LST_SVC_DATE] [date] NULL,
--	[ACO_NPI] [varchar](50) NULL,
--	[RUN_DATE] [date] NULL,
--	[RUN_YEAR] [int] NULL,
--	[RUN_MTH] [int] NULL,
--	[LOAD_DATE] [date] NULL,
--	[LOAD_USER] [varchar](50) NULL
--) ON [PRIMARY]

--ALTER TABLE [dbo].[Member_Unassigned_AWV_History] ADD  DEFAULT (sysdatetime()) FOR [LOAD_DATE]
--ALTER TABLE [dbo].[Member_Unassigned_AWV_History] ADD  DEFAULT (suser_sname()) FOR [LOAD_USER]

/*** Insert Into Member_AWV_History ***/
INSERT INTO adw.[Member_Unassigned_AWV_History]
           ([HICN]
           ,[LAST_NAME]
           ,[FIRST_NAME]
           ,[SEX]
           ,[DOB]
           ,[MBR_TYPE] 
		   ,[AWV] 
			,[PCP] 
			,[ER] 
			,[IP] 
			,[RA] 
			,[GAPS]
			,[LST_SVC_NPI] 
			,[LST_SVC_NAME] 
			,[LST_SVC_DATE]
			,[ACO_NPI] 
           ,[RUN_DATE]
           ,[RUN_YEAR]
           ,[RUN_MTH]
           )
		SELECT a.[HICN]
			  ,a.LastName
			  ,a.FirstName
			  ,a.[Sex]
			  ,a.[DOB]
			  --,a.exclusion
			  ,a.[Mbr_Type]
			  ,a.[AWV]
			  ,a.[PCP]
			  ,a.[ER]
			  ,a.[IP]
			  ,a.[RA]
			  ,ISNULL(e.NoOfGaps,0) as NoOfGaps
			  ,c.SVC_PROV_NPI as LastSvcNPI
			  ,c.LBN as LastSvcName
			  ,c.SVC_DATE as LastSvcDate
			  ,d.PCP_NPI as ACO_NPI
			  ,GETDATE() as RUN_DATE
			  ,YEAR(GETDATE())
			  ,MONTH(GETDATE())
		  FROM adw.[tmp_Active_Members] a 
		  LEFT JOIN adw.[vw_AllMbrDetail_LastPCPVisit] c
			ON a.HICN = c.SUBSCRIBER_ID
		  LEFT JOIN lst.LIST_PCP d
			ON c.SVC_PROV_NPI = d.PCP_NPI
		  LEFT JOIN 
				(SELECT DISTINCT [ClientMemberKey] AS HICN   
				,SUM([MsrCO]) AS NoOfGaps
				FROM adw.[vw_QM_MbrCareOp_Detail_CL]
				GROUP BY [ClientMemberKey]) e
			ON a.HICN = e.HICN
		  WHERE [AWV] + [PCP] = 0
		  AND [ER] + [IP] + [RA] = 0
		  AND a.Mbr_Type = 'U'
		  AND a.DOD = '1900-01-01' -- Exclude Deaths
		  AND a.exclusion = 'N'
		  AND ISNULL(e.NoOfGaps,0) <= 1
		  AND DATEDIFF(yy,a.DOB,GETDATE()) < 85 -- Exclude < 85
		  AND c.SVC_PROV_NPI is NOT NULL