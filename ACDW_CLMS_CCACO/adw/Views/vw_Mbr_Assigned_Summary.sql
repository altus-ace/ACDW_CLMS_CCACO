CREATE VIEW adw.[vw_Mbr_Assigned_Summary]
AS
     SELECT a.[URN], 
            a.[MBI], 
            a.[HICN], 
            a.FIRSTNAME, 
            a.LASTNAME, 
            a.[SEX], 
            a.[DOB], 
            a.[DOD], 
            a.[CountyName], 
            a.[StateName], 
            a.[CountyNumber], 
            a.[VoluntaryFlag], 
            a.[CBFlag], 
            a.[CBStepFlag], 
            a.[PrevBenFlag], 
            a.[PartDFlag], 
            ISNULL(CONVERT(DECIMAL(5, 4), a.RS_ESRD), 0) AS RS_ESRD
            ,
            -- ,(CASE a.[RS_ESRD] WHEN NULL THEN 0 ELSE CONVERT(decimal(5,4),a.RS_ESRD) END) AS RS1_ESRD 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[RS_Disabled]), 0) AS RS_Disabled, 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[RS_AgedDual]), 0) AS RS_AgedDual, 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[RS_AgedNonDual]), 0) AS RS_AgedNonDual, 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[Demo_RS_ESRD]), 0) AS Demo_RS_ESRD, 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[Demo_RS_Disabled]), 0) AS Demo_RS_Disabled, 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[Demo_RS_AgedDual]), 0) AS Demo_RS_AgedDual, 
            ISNULL(CONVERT(DECIMAL(5, 4), a.[Demo_RS_AgedNonDual]), 0) AS Demo_RS_AgedNonDual, 
            a.[ESRD_RS], 
            a.[DISABLED_RS], 
            a.[DUAL_RS], 
            a.[NONDUAL_RS], 
            a.[ELIG_TYPE], 
            b.SVC_PROV_NPI AS LAST_NPI, 
            UPPER(b.LBN) AS LAST_NPI_NAME, 
            b.SVC_DATE, 
            a.[MBR_YEAR], 
            a.[MBR_QTR], 
            a.[LOAD_DATE], 
            a.[LOAD_USER]
     FROM adw.[Member_History] a
          LEFT JOIN adw.vw_AllMbrDetail_LastPCPVisit_CY b ON a.HICN = b.SUBSCRIBER_ID

     --AND a.MBR_YEAR = b.MBR_YEAR AND a.MBR_QTR = b.MBR_QTR
     WHERE(a.MBR_YEAR =
     (
         SELECT MAX(MBR_YEAR) AS Expr1
         FROM adw.Assignable_Member_History AS Member_History_1
     ))
          AND (a.MBR_QTR =
     (
         SELECT MAX(MBR_QTR) AS Expr2
         FROM adw.Assignable_Member_History AS Member_History_2
         WHERE MBR_YEAR =
         (
             SELECT MAX(MBR_YEAR)
             FROM adw.Assignable_Member_History
         )
     ));
