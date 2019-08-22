
CREATE PROCEDURE [dbo].[Z_sp_QM_Aggr_AttProvNPI]
AS
     TRUNCATE TABLE [dbo].[ztmp_Aggr_AttProvNPI];
     INSERT INTO [dbo].[ztmp_Aggr_AttProvNPI]
     ([ProvNpi], 
      [Yr], 
      [CatOfSvc], 
      [TotBilled]
     )
            SELECT h.SVC_PROV_ID, 
                   YEAR(h.PRIMARY_SVC_DATE) YR, 
                   CATEGORY_OF_SVC, 
                   SUM(h.TOTAL_BILLED_AMT)
            FROM adw.Claims_Headers h
            GROUP BY h.SVC_PROV_ID, 
                     YEAR(h.PRIMARY_SVC_DATE), 
                     CATEGORY_OF_SVC;
