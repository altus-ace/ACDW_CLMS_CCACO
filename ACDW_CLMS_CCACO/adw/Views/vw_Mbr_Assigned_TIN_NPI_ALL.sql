CREATE VIEW adw.vw_Mbr_Assigned_TIN_NPI_ALL
AS
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
                ROW_NUMBER() OVER(PARTITION BY a.HICN, 
                                               a.MBR_YEAR, 
                                               a.MBR_QTR
                ORDER BY CASE
                             WHEN b.NPI_NAME IS NULL
                             THEN 0
                             ELSE 1
                         END DESC, 
                         a.PCSVS DESC, 
                         a.TIN DESC, 
                         b.NPI DESC) AS rank
         FROM adw.Member_Practice_History a
              LEFT JOIN
         (
             SELECT *
             FROM adw.Member_Provider_History
         ) b ON a.HICN = b.HICN
                AND a.MBR_YEAR = b.MBR_YEAR
                AND a.MBR_QTR = b.MBR_QTR
     ) a
     WHERE rank = 1;
