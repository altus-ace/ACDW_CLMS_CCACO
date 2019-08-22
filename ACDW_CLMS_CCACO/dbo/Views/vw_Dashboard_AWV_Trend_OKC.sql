

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vw_Dashboard_AWV_Trend_OKC]
AS
     SELECT [NPI], 
            UPPER([NPI_NAME]) AS NPI_NAME, 
            a.[RUN_YEAR] AS curr_year, 
            a.[RUN_MTH] AS curr_mth, 
     (
         SELECT COUNT(DISTINCT [HICN]) AS curr_mbr
         FROM adw.[Member_Assigned_AWV_History] b
         WHERE b.run_year = a.RUN_YEAR
               AND b.run_mth = a.RUN_MTH
               AND a.npi = b.npi
     ) AS curr_mbr, 
     (
         SELECT COUNT(DISTINCT [HICN]) AS curr_mbr
         FROM adw.[Member_Assigned_AWV_History] b
         WHERE b.run_year = CASE
                                WHEN a.RUN_MTH - 1 = 0
                                THEN a.RUN_YEAR - 1
                                ELSE a.RUN_YEAR
                            END
               AND b.run_mth = CASE
                                   WHEN a.RUN_MTH - 1 = 0
                                   THEN 12
                                   ELSE a.RUN_MTH - 1
                               END
               AND a.npi = b.npi
     ) AS last_mbr, 
            'A' AS mbr_type
     FROM
     (
         SELECT a.[NPI], 
                b.NPI_NAME AS [NPI_NAME], 
                run_year, 
                run_mth
         FROM
         (
             SELECT *
             FROM
             (
                 SELECT DISTINCT 
                        [NPI]
                 FROM adw.[Member_Assigned_AWV_History]
             ) a
             CROSS JOIN
             (
                 SELECT DISTINCT 
                        run_year, 
                        run_mth
                 FROM adw.[Member_Assigned_AWV_History]
             ) b
         ) a
         LEFT JOIN
         (
             SELECT [PCP_NPI], 
                    UPPER(concat([PCP_LAST_NAME], ', ', [PCP_FIRST_NAME])) AS NPI_NAME
             FROM lst.[LIST_PCP]
         ) b ON a.[NPI] = b.PCP_NPI
     ) a
     UNION
     SELECT [ACO_NPI] AS NPI, 
            [NPI_NAME], 
            a.[RUN_YEAR] AS curr_year, 
            a.[RUN_MTH] AS curr_mth, 
     (
         SELECT COUNT(DISTINCT [HICN]) AS curr_mbr
         FROM adw.[Member_Unassigned_AWV_History] b
         WHERE b.run_year = a.RUN_YEAR
               AND b.run_mth = a.RUN_MTH
               AND a.[ACO_NPI] = b.[ACO_NPI]
     ) AS curr_mbr, 
     (
         SELECT COUNT(DISTINCT [HICN]) AS curr_mbr
         FROM adw.[Member_Unassigned_AWV_History] b
         WHERE b.run_year = CASE
                                WHEN a.RUN_MTH - 1 = 0
                                THEN a.RUN_YEAR - 1
                                ELSE a.RUN_YEAR
                            END
               AND b.run_mth = CASE
                                   WHEN a.RUN_MTH - 1 = 0
                                   THEN 12
                                   ELSE a.RUN_MTH - 1
                               END
               AND a.[ACO_NPI] = b.[ACO_NPI]
     ) AS last_mbr, 
            'U' AS mbr_type
     FROM
     (
         SELECT a.[ACO_NPI], 
                b.NPI_NAME AS [NPI_NAME], 
                run_year, 
                run_mth
         FROM
         (
             SELECT *
             FROM
             (
                 SELECT DISTINCT 
                        aco_npi
                 FROM adw.[Member_Unassigned_AWV_History]
             ) a
             CROSS JOIN
             (
                 SELECT DISTINCT 
                        run_year, 
                        run_mth
                 FROM adw.[Member_Unassigned_AWV_History]
             ) b
         ) a
         LEFT JOIN
         (
             SELECT [PCP_NPI], 
                    UPPER(concat([PCP_LAST_NAME], ', ', [PCP_FIRST_NAME])) AS NPI_NAME
             FROM lst.[LIST_PCP]
         ) b ON a.ACO_NPI = b.PCP_NPI
     ) a;
