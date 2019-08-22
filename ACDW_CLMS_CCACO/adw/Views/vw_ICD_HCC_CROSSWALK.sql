CREATE VIEW adw.[vw_ICD_HCC_CROSSWALK]
AS
     SELECT DISTINCT 
            a.[ICD10], 
            [ICD10_DESCRIPTION], 
            [HCCV23], 
            b.HCC_No, 
            b.HCC_Description, 
            b.Disease_Hier, 
            a.[VERSIONS]
     FROM
     (
         SELECT *
         FROM lst.[LIST_ICDcwHCC] a
         WHERE HCCV23 IS NOT NULL
               AND HCCV23 <> ''
     ) a
     LEFT JOIN
     (
         SELECT [HCC_ID], 
                [HCC_No], 
                [HCC_Description], 
                [Disease_Hier], 
                [Year], 
                [LoadDate]
         FROM lst.LIST_HCC_CODES
     ) b ON a.HCCV23 = b.HCC_No;
