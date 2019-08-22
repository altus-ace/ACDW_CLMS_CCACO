
CREATE VIEW dbo.zvw_tmp_Rpt_AssignNeedingVisit
AS
     SELECT TOP 100 PERCENT
     --c.[MBI]
     ROW_NUMBER() OVER(
     ORDER BY(c.[ESRD_RS] + c.[DISABLED_RS] + c.[DUAL_RS] + c.[NONDUAL_RS]) DESC) RANK, 
     c.[HICN], 
     c.FIRSTNAME, 
     c.LASTNAME, 
     c.[SEX], 
     c.[DOB],
     --,c.[DOD]
     --,c.[CountyName]
     --,c.[StateName]
     --,c.[CountyNumber]
     --,c.[VoluntaryFlag]
     --,c.[CBFlag]
     --,c.[CBStepFlag] 
     c.[PrevBenFlag]
     ,
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
     DATEDIFF(yy, c.DOB, GETDATE()) AS AGE, 
     c.[ELIG_TYPE]
     ,
     --,c.[LAST_NPI]
     --,c.[LAST_NPI_NAME]
     --,c.[SVC_DATE]
     --,a.AWV
     --,a.PCP 
     a.TIN, 
     a.TIN_NAME, 
     a.NPI, 
     a.NPI_NAME
     --,d.PRIM_SPECIALTY
     --,GETDATE() as RUN_DATE
     FROM adw.tmp_Active_Members a
          LEFT JOIN adw.vw_Mbr_Assigned_Summary c --Current_AssignedMembers
          ON a.HICN = c.HICN
          LEFT JOIN lst.LIST_PCP d ON a.NPI = d.PCP_NPI
     WHERE(a.AWV + a.PCP) = 0
          AND a.MBR_TYPE = 'A'
          AND a.DOD = '1900-01-01' -- Exclude Deaths
          AND d.PRIM_SPECIALTY = 'PCP - Primary Care Physician'
          AND ELIG_TYPE <> 1 -- Exclude ESRD
          AND DATEDIFF(yy, c.DOB, GETDATE()) > 40 -- Exclude Age Range
     ORDER BY(c.[ESRD_RS] + c.[DISABLED_RS] + c.[DUAL_RS] + c.[NONDUAL_RS]) DESC;
