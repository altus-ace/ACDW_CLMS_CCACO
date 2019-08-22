CREATE VIEW [dbo].[z_Current_AssignedMembers]
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
            a.[RS_ESRD], 
            a.[RS_Disabled], 
            a.[RS_AgedDual], 
            a.[RS_AgedNonDual], 
            a.[Demo_RS_ESRD], 
            a.[Demo_RS_Disabled], 
            a.[Demo_RS_AgedDual], 
            a.[Demo_RS_AgedNonDual], 
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
          LEFT JOIN adw.vw_AllMbrDetail_LastPCPVisit b ON a.HICN = b.SUBSCRIBER_ID

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
     ));
