CREATE VIEW [dbo].[vw_LatestDx_HCCCodes]
AS
     SELECT a.[ICD10], 
            a.[ICD10_DESCRIPTION], 
            a.[HCCV22] AS CUR_HCC, 
            b.HCC_Description, 
            b.MaxYr
     FROM lst.LIST_ICDcwHCC a, 
     (
         SELECT HCC_No, 
                HCC_Description, 
                MAX(Year) AS MaxYr
         FROM lst.LIST_HCC_CODES
         WHERE YEAR =
         (
             SELECT MAX(Year)
             FROM lst.LIST_HCC_CODES
         )
         GROUP BY HCC_No, 
                  HCC_Description
     ) b
     WHERE a.HCCV22 = b.HCC_No;

