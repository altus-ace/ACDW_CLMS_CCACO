
CREATE VIEW adw.[vw_ActiveMember_ProviderPracticeProfile]
AS
     SELECT DISTINCT 
            a.HICN, 
            a.MBR_TYPE, 
            a.DOB, 
            a.SEX, 
            a.LASTNAME, 
            a.FIRSTNAME, 
            a.MBR_QTR, 
            a.MBR_YEAR, 
            b.NPI AS PCP_NPI, 
            b.PCP_NAME AS PCP_NPI_NAME, 
            b.PRIM_SPECIALTY AS PCP_SPEC, 
            b.TIN AS PCP_TIN, 
            b.TIN_NAME AS PCP_TINNAME, 
            c.NPI AS BLANK_NPI, 
            c.PCP_NAME AS BLANK_NPI_NAME, 
            c.PRIM_SPECIALTY AS BLANK_SPEC, 
            c.TIN AS BLANK_TIN, 
            c.TIN_NAME AS BLANK_TINNAME, 
            d.NPI AS SPL_NPI, 
            d.PCP_NAME AS SPL_NPI_NAME, 
            d.PRIM_SPECIALTY AS SPL_SPEC, 
            d.TIN AS SPL_TIN, 
            d.TIN_NAME AS SPL_TINNAME
     FROM adw.tmp_Active_Members a
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    a.HICN, 
                    a.NPI, 
                    b.PCP_NAME, 
                    b.PRIM_SPECIALTY, 
                    c.TIN, 
                    c.TIN_NAME, 
                    c.PCSVS, 
                    ROW_NUMBER() OVER(PARTITION BY a.HICN
                    ORDER BY c.PCSVS DESC, 
                             c.TIN DESC, 
                             a.NPI DESC) AS rank
             FROM
             (
                 SELECT *
                 FROM adw.[Member_Provider_History] a
                 WHERE a.MBR_YEAR = YEAR(GETDATE())
                       AND a.MBR_QTR =
                 (
                     SELECT MAX(MBR_QTR)
                     FROM adw.[Member_Provider_History]
                     WHERE MBR_YEAR = YEAR(GETDATE())
                 )
             ) a
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        PCP_NPI, 
                        PRIM_SPECIALTY, 
                        concat(PCP_LAST_NAME, ', ', PCP_FIRST_NAME) AS PCP_NAME
                 FROM lst.LIST_PCP
             ) b ON a.NPI = b.PCP_NPI
             LEFT JOIN
             (
                 SELECT *
                 FROM adw.[Member_Practice_History] a
                 WHERE a.MBR_YEAR = YEAR(GETDATE())
                       AND a.MBR_QTR =
                 (
                     SELECT MAX(MBR_QTR)
                     FROM adw.[Member_Provider_History]
                     WHERE MBR_YEAR = YEAR(GETDATE())
                 )
             ) c ON a.TIN = c.TIN
                    AND a.HICN = c.HICN
             WHERE PRIM_SPECIALTY = 'PCP - Primary Care Physician'
         ) z
         WHERE rank = 1
     ) b ON a.HICN = b.HICN
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    a.HICN, 
                    a.NPI, 
                    b.PCP_NAME, 
                    b.PRIM_SPECIALTY, 
                    c.TIN, 
                    c.TIN_NAME, 
                    c.PCSVS, 
                    ROW_NUMBER() OVER(PARTITION BY a.HICN
                    ORDER BY c.PCSVS DESC, 
                             c.TIN DESC, 
                             a.NPI DESC) AS rank
             FROM
             (
                 SELECT *
                 FROM adw.[Member_Provider_History] a
                 WHERE a.MBR_YEAR = YEAR(GETDATE())
                       AND a.MBR_QTR =
                 (
                     SELECT MAX(MBR_QTR)
                     FROM adw.[Member_Provider_History]
                     WHERE MBR_YEAR = YEAR(GETDATE())
                 )
             ) a
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        PCP_NPI, 
                        PRIM_SPECIALTY, 
                        concat(PCP_LAST_NAME, ', ', PCP_FIRST_NAME) AS PCP_NAME
                 FROM lst.LIST_PCP
             ) b ON a.NPI = b.PCP_NPI
             LEFT JOIN
             (
                 SELECT *
                 FROM adw.[Member_Practice_History] a
                 WHERE a.MBR_YEAR = YEAR(GETDATE())
                       AND a.MBR_QTR =
                 (
                     SELECT MAX(MBR_QTR)
                     FROM adw.[Member_Provider_History]
                     WHERE MBR_YEAR = YEAR(GETDATE())
                 )
             ) c ON a.TIN = c.TIN
                    AND a.HICN = c.HICN
             WHERE PRIM_SPECIALTY = ''
         ) z
         WHERE rank = 1
     ) c ON a.HICN = c.HICN
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    a.HICN, 
                    a.NPI, 
                    b.PCP_NAME, 
                    b.PRIM_SPECIALTY, 
                    c.TIN, 
                    c.TIN_NAME, 
                    c.PCSVS, 
                    ROW_NUMBER() OVER(PARTITION BY a.HICN
                    ORDER BY c.PCSVS DESC, 
                             c.TIN DESC, 
                             a.NPI DESC) AS rank
             FROM
             (
                 SELECT *
                 FROM adw.[Member_Provider_History] a
                 WHERE a.MBR_YEAR = YEAR(GETDATE())
                       AND a.MBR_QTR =
                 (
                     SELECT MAX(MBR_QTR)
                     FROM adw.[Member_Provider_History]
                     WHERE MBR_YEAR = YEAR(GETDATE())
                 )
             ) a
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        PCP_NPI, 
                        PRIM_SPECIALTY, 
                        concat(PCP_LAST_NAME, ', ', PCP_FIRST_NAME) AS PCP_NAME
                 FROM lst.LIST_PCP
             ) b ON a.NPI = b.PCP_NPI
             LEFT JOIN
             (
                 SELECT *
                 FROM adw.[Member_Practice_History] a
                 WHERE a.MBR_YEAR = YEAR(GETDATE())
                       AND a.MBR_QTR =
                 (
                     SELECT MAX(MBR_QTR)
                     FROM adw.[Member_Provider_History]
                     WHERE MBR_YEAR = YEAR(GETDATE())
                 )
             ) c ON a.TIN = c.TIN
                    AND a.HICN = c.HICN
             WHERE PRIM_SPECIALTY NOT IN('', 'PCP - Primary Care Physician')
         ) z
         WHERE rank = 1
     ) d ON a.HICN = d.HICN;
