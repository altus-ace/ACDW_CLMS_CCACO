CREATE VIEW [dbo].[z_vw_Mbr_Assigned_TIN_NPI]
AS
     SELECT *
     FROM
     (
         SELECT a.*, 
                ROW_NUMBER() OVER(PARTITION BY a.HICN
                ORDER BY TIN DESC) AS ranks
         FROM
         (
             SELECT *
             FROM
             (
                 SELECT a.HICN, 
                        a.FIRSTNAME, 
                        a.LASTNAME, 
                        a.SEX, 
                        a.DOB, 
                        b.TIN, 
                        b.TIN_NAME, 
                        b.NPI, 
                        b.NPI_NAME, 
                        a.MBR_YEAR, 
                        a.MBR_QTR,
                        CASE
                            WHEN b.NPI_NAME IS NULL
                            THEN 0
                            ELSE 1
                        END AS match_npi, 
                        DENSE_RANK() OVER(PARTITION BY a.HICN
                        ORDER BY CASE
                                     WHEN b.NPI_NAME IS NULL
                                     THEN 0
                                     ELSE 1
                                 END DESC, 
                                 a.PCSVS DESC, 
                                 a.TIN DESC, 
                                 b.NPI DESC) AS rank
                 FROM
                 (
                     SELECT *
                     FROM adw.Member_Practice_History a
                     WHERE a.MBR_YEAR =
                     (
                         SELECT MAX(MBR_YEAR) AS Expr1
                         FROM adw.Member_Practice_History AS Member_History_1
                     )
                           AND a.MBR_QTR =
                     (
                         SELECT MAX(MBR_QTR) AS Expr1
                         FROM adw.Member_Practice_History
                         WHERE MBR_YEAR =
                         (
                             SELECT MAX(MBR_YEAR)
                             FROM adw.Member_Practice_History
                         )
                     )
                 ) a
                 LEFT JOIN
                 (
                     SELECT *
                     FROM adw.Member_Provider_History a
                     WHERE a.MBR_YEAR =
                     (
                         SELECT MAX(MBR_YEAR) AS Expr1
                         FROM adw.Member_Practice_History AS Member_History_1
                     )
                           AND a.MBR_QTR =
                     (
                         SELECT MAX(MBR_QTR) AS Expr1
                         FROM adw.Member_Practice_History
                         WHERE MBR_YEAR =
                         (
                             SELECT MAX(MBR_YEAR) AS Expr1
                             FROM adw.Member_Practice_History AS Member_History_1
                         )
                     )
                 ) b ON a.HICN = b.HICN
             ) z
             WHERE rank = 1
         ) a
     ) b
     WHERE ranks = 1;
