






CREATE VIEW [dbo].[vw_Dashboard_AWV_NeedingVisit_OKC]
as
SELECT   a.[HICN]
      ,a.LastName
      ,a.FirstName
      ,a.[Sex]
      ,a.[DOB]
      ,a.[Mbr_Type]
   --   ,a.[AWV]
   --   ,a.[PCP]
	  --,a.[ER]
	  --,a.[IP]
	  --,a.[RA]
	  --,ISNULL(e.NoOfGaps,0) as NoOfGaps
	  ,c.SVC_PROV_NPI as LastSvcNPI
	  ,c.LBN as LastSvcName
	  ,c.SVC_DATE as LastSvcDate
	  ,d.PCP_NPI as ACO_NPI
	  ,concat(d.PCP_LAST_NAME, ', ', d.PCP_FIRST_NAME) as  ACO_NPI_NAME
	  --,GETDATE() as RUN_DATE
  FROM (select * from adw.[tmp_Active_Members] where exclusion = 'N')  a 
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
  AND ISNULL(e.NoOfGaps,0) <= 1
  AND DATEDIFF(yy,a.DOB,GETDATE()) < 85 -- Exclude < 85
  AND c.SVC_PROV_NPI is NOT NULL
 
 
  union




SELECT 
	--c.[MBI]
	--ROW_NUMBER() OVER ( ORDER BY (c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC) RANK
      a.[HICN]
	     ,a.[LastName]
      ,a.[FirstName]
   
      ,a.[Sex]
      ,a.[DOB]
	  ,a.Mbr_Type
      --,c.[DOD]
      --,c.[CountyName]
      --,c.[StateName]
      --,c.[CountyNumber]
      --,c.[VoluntaryFlag]
      --,c.[CBFlag]
      --,c.[CBStepFlag]
     -- ,c.[PrevBenFlag]
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
	 -- ,DATEDIFF(yy,c.DOB,GETDATE()) AS AGE
      --,c.[ELIG_TYPE]
      --,c.[LAST_NPI]
      --,c.[LAST_NPI_NAME]
      --,c.[SVC_DATE]
	  --,a.AWV
	  --,a.PCP
	  ,e.SVC_PROV_NPI as LastSvcNPI
	  ,e.LBN as LastSvcName
	  ,e.SVC_DATE as LastSvcDate
	  ,d.PCP_NPI as ACO_NPI
	  ,concat(d.PCP_LAST_NAME, ', ', d.PCP_FIRST_NAME) as  ACO_NPI_NAME
	  --,d.PRIM_SPECIALTY
	  --,GETDATE() as RUN_DATE
FROM adw.tmp_Active_Members a 
LEFT JOIN (select * from (select distinct  hicn , ELIG_TYPE, row_number() over (partition by hicn order by mbr_qtr desc ) as rank from dbo.[vw_Dashboard_Mbr_Assigned_Summary] where mbr_year = year(getdate()) ) z where rank = 1  ) c --Current_AssignedMembers
	ON a.HICN = c.HICN
 JOIN lst.[LIST_PCP] d ON a.NPI = d.PCP_NPI
	LEFT JOIN adw.[vw_AllMbrDetail_LastPCPVisit] e ON a.HICN = e.SUBSCRIBER_ID

WHERE (a.AWV + a.PCP) = 0
AND a.Mbr_Type = 'A'
AND a.DOD = '1900-01-01' -- Exclude Deaths
AND d.PRIM_SPECIALTY = 'PCP - Primary Care Physician'
AND ELIG_TYPE <> 1 -- Exclude ESRD
AND DATEDIFF(yy,a.DOB,GETDATE()) > 40 -- Exclude Age Range
--ORDER BY (c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC
