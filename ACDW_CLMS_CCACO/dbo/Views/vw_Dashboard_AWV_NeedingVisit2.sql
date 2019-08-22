
CREATE VIEW [dbo].[vw_Dashboard_AWV_NeedingVisit2]
AS
     SELECT a.[HICN], 
            a.LASTNAME, 
            a.FIRSTNAME, 
            a.[SEX], 
            a.[DOB], 
            a.MBR_TYPE
            ,
            --   ,a.[AWV]
            --   ,a.[PCP]
            --,a.[ER]
            --,a.[IP]
            --,a.[RA]
            --,ISNULL(e.NoOfGaps,0) as NoOfGaps 
            c.SVC_PROV_NPI AS LastSvcNPI, 
            c.LBN AS LastSvcName, 
            c.SVC_DATE AS LastSvcDate, 
            d.PCP_NPI AS ACO_NPI, 
            concat(d.PCP_LAST_NAME, ', ', d.PCP_FIRST_NAME) AS ACO_NPI_NAME
     --,GETDATE() as RUN_DATE
     FROM
     (
         SELECT *
         FROM adw.[tmp_Active_Members]
         WHERE Exclusion = 'N'
     ) a
     LEFT JOIN adw.[vw_AllMbrDetail_LastPCPVisit] c ON a.HICN = c.SUBSCRIBER_ID
     LEFT JOIN lst.LIST_PCP d ON c.SVC_PROV_NPI = d.PCP_NPI
     LEFT JOIN
     (
         SELECT DISTINCT 
                [ClientMemberKey] AS HICN, 
                SUM([MsrCO]) AS NoOfGaps
         FROM adw.[vw_QM_MbrCareOp_Detail_CL]
         GROUP BY [ClientMemberKey]
     ) e ON a.HICN = e.HICN
     WHERE [AWV] + [PCP] = 0
           AND [ER] + [IP] + [RA] = 0
           AND a.MBR_TYPE = 'U'
           AND a.DOD = '1900-01-01' -- Exclude Deaths
           AND ISNULL(e.NoOfGaps, 0) <= 1
           AND DATEDIFF(yy, a.DOB, GETDATE()) < 85 -- Exclude < 85
           AND c.SVC_PROV_NPI IS NOT NULL
     UNION
     SELECT 
     --c.[MBI]
     --ROW_NUMBER() OVER ( ORDER BY (c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC) RANK
     a.[HICN], 
     a.LASTNAME, 
     a.FIRSTNAME, 
     a.[SEX], 
     a.[DOB], 
     a.MBR_TYPE
     ,
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
     e.SVC_PROV_NPI AS LastSvcNPI, 
     e.LBN AS LastSvcName, 
     e.SVC_DATE AS LastSvcDate, 
     d.PCP_NPI AS ACO_NPI, 
     concat(d.PCP_LAST_NAME, ', ', d.PCP_FIRST_NAME) AS ACO_NPI_NAME
     --,d.PRIM_SPECIALTY
     --,GETDATE() as RUN_DATE
     FROM adw.tmp_Active_Members a
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    HICN, 
                    ELIG_TYPE, 
                    ROW_NUMBER() OVER(PARTITION BY HICN
                    ORDER BY MBR_QTR DESC) AS rank
             FROM adw.vw_Mbr_Assigned_Summary
             WHERE MBR_YEAR = YEAR(GETDATE())
         ) z
         WHERE rank = 1
     ) c --Current_AssignedMembers
          ON a.HICN = c.HICN
          JOIN lst.LIST_PCP d ON a.NPI = d.PCP_NPI
          LEFT JOIN adw.vw_AllMbrDetail_LastPCPVisit e ON a.HICN = e.SUBSCRIBER_ID
     WHERE(a.AWV + a.PCP) = 0
          AND a.MBR_TYPE = 'A'
          AND a.DOD = '1900-01-01' -- Exclude Deaths
          AND d.PRIM_SPECIALTY = 'PCP - Primary Care Physician'
          AND ELIG_TYPE <> 1 -- Exclude ESRD
          AND DATEDIFF(yy, a.DOB, GETDATE()) > 40; -- Exclude Age Range
     --ORDER BY (c.[ESRD_RS]+c.[DISABLED_RS]+c.[DUAL_RS]+c.[NONDUAL_RS]) DESC
