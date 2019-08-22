CREATE VIEW adw.[vw_AllMbrDetail_LastPCPVisit_CY]
AS
     SELECT *
     FROM
     (
         SELECT DISTINCT 
                a.SUBSCRIBER_ID, 
                a.[SVC_PROV_NPI], 
         (
             SELECT b.LBN_Name
             FROM lst.LIST_NPPES b
             WHERE b.NPI = a.SVC_PROV_NPI
         ) AS LBN, 
                a.PRIMARY_SVC_DATE AS SVC_DATE, 
                ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
                ORDER BY PRIMARY_SVC_DATE DESC, 
                         ACO_NPI DESC) AS rank
         FROM adw.[vw_AllMbrDetail_PCPVisit] a
     ) a
     WHERE rank = 1
           AND YEAR(a.SVC_DATE) = YEAR(GETDATE());
