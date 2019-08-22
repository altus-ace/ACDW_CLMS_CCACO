
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW adw.vw_active_members_ALL
AS
     SELECT *,
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
     FROM adw.[Member_History] a;
