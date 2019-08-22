
CREATE VIEW [dbo].[zvw_top_ten_rerank_npi_performers]
AS
     SELECT NPI, 
            tot_den, 
            tot_num, 
            perc, 
            perc_of_memb * 100 * percentile AS true_rank
     FROM
     (
         SELECT NPI, 
                tot_den, 
                tot_num, 
                perc, 
                CAST(tot_den AS FLOAT) /
         (
             SELECT SUM(tot_den)
             FROM adw.vw_npi_performance_caregap
         ) AS perc_of_memb, 
                PERCENT_RANK() OVER(
                ORDER BY perc) AS percentile
         FROM adw.[vw_npi_performance_caregap]
     ) a;
