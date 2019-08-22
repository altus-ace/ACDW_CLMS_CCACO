
CREATE VIEW adw.vw_Awv_Full_List_History
AS
     SELECT HICN, 
            FIRST_NAME, 
            LAST_NAME, 
            SEX, 
            DOB, 
            MBR_TYPE, 
            ACO_NPI AS NPI, 
            concat(d.PCP_LAST_NAME, ', ', d.PCP_FIRST_NAME) AS NPI_NAME, 
            RUN_MTH, 
            RUN_YEAR
     FROM adw.[Member_Unassigned_AWV_History] a
          LEFT JOIN lst.LIST_PCP d ON a.ACO_NPI = d.PCP_NPI
     WHERE HICN IN
     (
         SELECT HICN
         FROM adw.tmp_Active_Members
         WHERE Exclusion = 'N'
     )
     UNION
     SELECT HICN, 
            FIRST_NAME, 
            LAST_NAME, 
            SEX, 
            DOB, 
            'A' AS MBR_TYPE, 
            NPI, 
            NPI_NAME, 
            RUN_MTH, 
            RUN_YEAR
     FROM adw.[Member_Assigned_AWV_History]
     WHERE HICN IN
     (
         SELECT HICN
         FROM adw.tmp_Active_Members
         WHERE Exclusion = 'N'
     );
