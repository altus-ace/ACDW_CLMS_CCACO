CREATE VIEW [dbo].[vw_Dashboard_NPIperformance]
AS
     SELECT NPI, 
            NPI_NAME, 
            TIN, 
            TIN_NAME, 
            QMDate, 
            tot_den, 
            tot_num, 
            perc, 
            perc_of_memb * 100 * perc_gap AS rank1, 
            perc_of_memb * .9 + perc_gap * .1 / .4 AS rank2
     FROM
     (
         SELECT NPI, 
                NPI_NAME, 
                TIN, 
                TIN_NAME, 
                QMDate, 
                tot_den, 
                tot_num, 
                perc, 
                CAST(tot_den AS FLOAT) /
         (
             SELECT SUM(tot_den)
             FROM adw.vw_npi_performance_caregap
         ) AS perc_of_memb, 
                PERCENT_RANK() OVER(
                ORDER BY perc) AS perc_gap
         FROM adw.vw_npi_performance_caregap
     ) a;
