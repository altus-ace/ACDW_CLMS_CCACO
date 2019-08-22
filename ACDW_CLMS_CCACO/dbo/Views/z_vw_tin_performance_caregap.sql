CREATE VIEW [z_vw_tin_performance_caregap]
AS
     SELECT *, 
            DENSE_RANK() OVER(
            ORDER BY perc DESC) AS rank
     FROM
     (
         SELECT b.TIN, 
                SUM([MsrDen]) AS tot_den, 
                SUM([MsrNum]) AS tot_num, 
                ROUND(CAST(SUM([MsrNum]) AS FLOAT) / SUM([MsrDen]), 2) AS perc
         FROM [dbo].zvw_QM_MbrCareOp_Detail a
              JOIN
         (
             SELECT *
             FROM adw.[vw_Mbr_Assigned_TIN_NPI]
         ) b ON a.ClientMemberKey = b.HICN
         GROUP BY b.TIN
     ) a;
