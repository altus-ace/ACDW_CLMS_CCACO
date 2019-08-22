CREATE VIEW dbo.z_vw_AllMbrDetail_LastPCPVisit_History
AS

     -- Get Members' last PCP Visit
     SELECT DISTINCT 
            a.SUBSCRIBER_ID, 
            a.[SVC_PROV_NPI], 
     (
         SELECT b.LBN_Name
         FROM lst.LIST_NPPES b
         WHERE b.NPI = a.SVC_PROV_NPI
     ) AS LBN, 
            a.PRIMARY_SVC_DATE AS SVC_DATE
     FROM dbo.z_vw_AllMbrDetail_PCPVisit_History a
     WHERE 
     --a.SUBSCRIBER_ID = '007557155M' AND 
     a.PRIMARY_SVC_DATE =
     (
         SELECT MAX(b.PRIMARY_SVC_DATE)
         FROM dbo.z_vw_AllMbrDetail_PCPVisit_History b
         WHERE a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
               AND b.ACO_NPI IS NOT NULL
         GROUP BY b.SUBSCRIBER_ID
     )
     GROUP BY a.SUBSCRIBER_ID, 
              a.PRIMARY_SVC_DATE, 
              a.[SVC_PROV_NPI];
