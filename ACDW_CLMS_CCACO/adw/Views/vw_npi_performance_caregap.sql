CREATE VIEW adw.[vw_npi_performance_caregap]
AS
     SELECT *, 
            DENSE_RANK() OVER(
            ORDER BY perc DESC) AS rank
     FROM
     (
         SELECT b.NPI, 
                b.NPI_NAME, 
                [TIN], 
                [TIN_NAME], 
                QMDate, 
                SUM([MsrDen]) AS tot_den, 
                SUM([MsrNum]) AS tot_num, 
                ROUND(CAST(SUM([MsrNum]) AS FLOAT) / SUM([MsrDen]), 2) AS perc
         FROM
         (
             SELECT *
             FROM adw.[vw_QM_MbrCareOp_Detail_CL]
             WHERE QmMsrId NOT IN
             (
                 SELECT DISTINCT 
                        QM
                 FROM lst.LIST_QM_Mapping
                 WHERE ACTIVE = 'N'
             )
         ) a
         JOIN
         (
             SELECT HICN, 
                    [NPI], 
                    [NPI_NAME], 
                    [TIN], 
                    [TIN_NAME]
             FROM adw.[vw_member_demographics]
         ) b ON a.ClientMemberKey = b.HICN
         GROUP BY b.NPI, 
                  b.npi_name, 
                  [TIN], 
                  [TIN_NAME], 
                  QMDate
         HAVING b.NPI IS NOT NULL
     ) a;
