
CREATE VIEW dbo.zvw_tmp_Rpt_UnassignNeedingVisit
AS
SELECT a.[HICN]
      ,a.LASTNAME
      ,a.FIRSTNAME
      ,a.[SEX]
      ,a.[DOB]
      ,a.MBR_TYPE
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
	  --,GETDATE() as RUN_DATE
  FROM adw.tmp_Active_Members a 
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
  AND a.MBR_TYPE = 'U'
  AND a.DOD = '1900-01-01' -- Exclude Deaths
  AND ISNULL(e.NoOfGaps,0) <= 1
  AND DATEDIFF(yy,a.DOB,GETDATE()) < 85 -- Exclude < 85
  AND c.SVC_PROV_NPI is NOT NULL
