

CREATE VIEW [dbo].[vw_Dashboard_AWV_New_Members_OKC]
AS
     SELECT b.[hicn], 
            b.[first_name], 
            b.[last_name],
            CASE
                WHEN b.[sex] = 1
                THEN 'Male'
                ELSE 'Female'
            END AS Sex, 
            b.[dob], 
            b.[mbr_type], 
            b.[NPI], 
            b.[NPI_NAME], 
            b.[run_mth], 
            b.[RUN_YEAR]
     FROM
     (
         SELECT hicn, 
                mbr_type
         FROM adw.VW_AWV_FULL_LIST_HISTORY
         WHERE mbr_type = 'U'
               AND run_year =
         (
             SELECT MAX(run_year)
             FROM adw.VW_AWV_FULL_LIST_HISTORY
         )
               AND run_mth =
                             (
                                 SELECT MAX(run_mth)
                                 FROM adw.VW_AWV_FULL_LIST_HISTORY
                                 WHERE run_year =
                                 (
                                     SELECT MAX(run_year)
                                     FROM adw.VW_AWV_FULL_LIST_HISTORY
                                 )
                             )
                             EXCEPT
                             SELECT hicn, 
                                    mbr_type
                             FROM adw.VW_AWV_FULL_LIST_HISTORY
                             WHERE mbr_type = 'U'
                                   AND run_year =
                             (
                                 SELECT CASE
                                            WHEN MAX(run_mth) = 1
                                            THEN MAX(run_year) - 1
                                            ELSE MAX(run_year)
                                        END AS run_mth
                                 FROM adw.VW_AWV_FULL_LIST_HISTORY
                             )
                                   AND run_mth =
                                                 (
                                                     SELECT CASE
                                                                WHEN MAX(run_mth) = 1
                                                                THEN 12
                                                                ELSE MAX(run_mth) - 1
                                                            END AS run_mth
                                                     FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                     WHERE run_year =
                                                     (
                                                         SELECT MAX(run_year)
                                                         FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                     )
                                                 )
                                                 UNION
                                                 (
                                                     SELECT hicn, 
                                                            mbr_type
                                                     FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                     WHERE mbr_type = 'A'
                                                           AND run_year =
                                                     (
                                                         SELECT MAX(run_year)
                                                         FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                     )
                                                           AND run_mth =
                                                                         (
                                                                             SELECT MAX(run_mth)
                                                                             FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                                             WHERE run_year =
                                                                             (
                                                                                 SELECT MAX(run_year)
                                                                                 FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                                             )
                                                                         )
                                                                         EXCEPT
                                                                         SELECT hicn, 
                                                                                mbr_type
                                                                         FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                                         WHERE mbr_type = 'A'
                                                                               AND run_year =
                                                                         (
                                                                             SELECT CASE
                                                                                        WHEN MAX(run_mth) = 1
                                                                                        THEN MAX(run_year) - 1
                                                                                        ELSE MAX(run_year)
                                                                                    END AS run_mth
                                                                             FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                                         )
                                                                               AND run_mth =
                                                                         (
                                                                             SELECT CASE
                                                                                        WHEN MAX(run_mth) = 1
                                                                                        THEN 12
                                                                                        ELSE MAX(run_mth) - 1
                                                                                    END AS run_mth
                                                                             FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                                             WHERE run_year =
                                                                             (
                                                                                 SELECT MAX(run_year)
                                                                                 FROM adw.VW_AWV_FULL_LIST_HISTORY
                                                                             )
                                                                         )
                                                 )
     ) a
     LEFT JOIN
     (
         SELECT *
         FROM adw.VW_AWV_FULL_LIST_HISTORY
         WHERE run_year =
         (
             SELECT MAX(run_year)
             FROM adw.VW_AWV_FULL_LIST_HISTORY
         )
               AND run_mth =
         (
             SELECT MAX(run_mth)
             FROM adw.VW_AWV_FULL_LIST_HISTORY
             WHERE run_year =
             (
                 SELECT MAX(run_year)
                 FROM adw.VW_AWV_FULL_LIST_HISTORY
             )
         )
     ) b ON a.hicn = b.hicn
            AND a.mbr_type = b.mbr_type;
