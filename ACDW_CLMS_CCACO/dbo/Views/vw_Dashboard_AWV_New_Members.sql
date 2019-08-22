

CREATE VIEW [dbo].[vw_Dashboard_AWV_New_Members]
AS
     SELECT b.[HICN], 
            b.[FIRST_NAME], 
            b.[LAST_NAME],
            CASE
                WHEN b.[SEX] = 1
                THEN 'Male'
                ELSE 'Female'
            END AS SEX, 
            b.[DOB],
			d.[M_Alternate_Number] as [Home Phone],
			d.[M_Mobile_Number] as [Mobile Phone],
            b.MBR_TYPE, 
            b.[NPI], 
            b.[NPI_NAME], 
            b.[RUN_MTH], 
            b.[RUN_YEAR]
     FROM
     (
         SELECT HICN, 
                MBR_TYPE
         FROM adw.vw_Awv_Full_List_History
         WHERE MBR_TYPE = 'U'
               AND RUN_YEAR =
         (
             SELECT MAX(RUN_YEAR)
             FROM adw.vw_Awv_Full_List_History
         )
               AND RUN_MTH =
                             (
                                 SELECT MAX(RUN_MTH)
                                 FROM adw.vw_Awv_Full_List_History
                                 WHERE RUN_YEAR =
                                 (
                                     SELECT MAX(RUN_YEAR)
                                     FROM adw.vw_Awv_Full_List_History
                                 )
                             )
                             EXCEPT
                             SELECT HICN, 
                                    MBR_TYPE
                             FROM adw.vw_Awv_Full_List_History
                             WHERE MBR_TYPE = 'U'
                                   AND RUN_YEAR =
                             (
                                 SELECT CASE
                                            WHEN MAX(RUN_MTH) = 1
                                            THEN MAX(RUN_YEAR) - 1
                                            ELSE MAX(RUN_YEAR)
                                        END AS RUN_MTH
                                 FROM adw.vw_Awv_Full_List_History
                             )
                                   AND RUN_MTH =
                                                 (
                                                     SELECT CASE
                                                                WHEN MAX(RUN_MTH) = 1
                                                                THEN 12
                                                                ELSE MAX(RUN_MTH) - 1
                                                            END AS RUN_MTH
                                                     FROM adw.vw_Awv_Full_List_History
                                                     WHERE RUN_YEAR =
                                                     (
                                                         SELECT MAX(RUN_YEAR)
                                                         FROM adw.vw_Awv_Full_List_History
                                                     )
                                                 )
                                                 UNION
                                                 (
                                                     SELECT HICN, 
                                                            MBR_TYPE
                                                     FROM adw.vw_Awv_Full_List_History
                                                     WHERE MBR_TYPE = 'A'
                                                           AND RUN_YEAR =
                                                     (
                                                         SELECT MAX(RUN_YEAR)
                                                         FROM adw.vw_Awv_Full_List_History
                                                     )
                                                           AND RUN_MTH =
                                                                         (
                                                                             SELECT MAX(RUN_MTH)
                                                                             FROM adw.vw_Awv_Full_List_History
                                                                             WHERE RUN_YEAR =
                                                                             (
                                                                                 SELECT MAX(RUN_YEAR)
                                                                                 FROM adw.vw_Awv_Full_List_History
                                                                             )
                                                                         )
                                                                         EXCEPT
                                                                         SELECT HICN, 
                                                                                MBR_TYPE
                                                                         FROM adw.vw_Awv_Full_List_History
                                                                         WHERE MBR_TYPE = 'A'
                                                                               AND RUN_YEAR =
                                                                         (
                                                                             SELECT CASE
                                                                                        WHEN MAX(RUN_MTH) = 1
                                                                                        THEN MAX(RUN_YEAR) - 1
                                                                                        ELSE MAX(RUN_YEAR)
                                                                                    END AS RUN_MTH
                                                                             FROM adw.vw_Awv_Full_List_History
                                                                         )
                                                                               AND RUN_MTH =
                                                                         (
                                                                             SELECT CASE
                                                                                        WHEN MAX(RUN_MTH) = 1
                                                                                        THEN 12
                                                                                        ELSE MAX(RUN_MTH) - 1
                                                                                    END AS RUN_MTH
                                                                             FROM adw.vw_Awv_Full_List_History
                                                                             WHERE RUN_YEAR =
                                                                             (
                                                                                 SELECT MAX(RUN_YEAR)
                                                                                 FROM adw.vw_Awv_Full_List_History
                                                                             )
                                                                         )
                                                 )
     ) a
     LEFT JOIN
     (
         SELECT *
         FROM adw.vw_Awv_Full_List_History
         WHERE RUN_YEAR =
         (
             SELECT MAX(RUN_YEAR)
             FROM adw.vw_Awv_Full_List_History
         )
               AND RUN_MTH =
         (
             SELECT MAX(RUN_MTH)
             FROM adw.vw_Awv_Full_List_History
             WHERE RUN_YEAR =
             (
                 SELECT MAX(RUN_YEAR)
                 FROM adw.vw_Awv_Full_List_History
             )
         )
     ) b ON a.HICN = b.HICN
            AND a.MBR_TYPE = b.MBR_TYPE
	left join adw.M_MEMBER_ENR d on a.HICN = d.subscriber_id;
