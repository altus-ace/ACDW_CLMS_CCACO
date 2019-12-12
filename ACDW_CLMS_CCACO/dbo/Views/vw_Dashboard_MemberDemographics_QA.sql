

CREATE VIEW [dbo].[vw_Dashboard_MemberDemographics_QA]
AS
     SELECT a.*, 
            b.TIN, 
            b.TIN_NAME, 
            b.NPI, 
            b.NPI_NAME, 
            c.CountyName,
            CASE
                WHEN a.MBR_YEAR =
     (
         SELECT MAX(MBR_YEAR) AS Expr1
         FROM adw.[Member_History]
     )
                     AND a.MBR_QTR =
     (
         SELECT MAX(MBR_QTR) AS Expr1
         FROM adw.[Member_History]
         WHERE MBR_YEAR =
         (
             SELECT MAX(MBR_YEAR)
             FROM adw.[Member_History]
         )
     )
                THEN 1
                ELSE 0
            END AS ACTIVE
     FROM adw.[Assignable_Member_History] a
          LEFT JOIN adw.vw_Mbr_Assigned_TIN_NPI_ALL b ON a.HICN = b.HICN
                                                     AND a.MBR_YEAR = b.MBR_YEAR
                                                     AND a.MBR_QTR = b.MBR_QTR  --where ACTIVE =1 
          LEFT JOIN adw.[Member_History] c ON a.HICN = c.HICN
                                                AND a.MBR_YEAR = c.MBR_YEAR
                                                AND a.MBR_QTR = c.MBR_QTR;