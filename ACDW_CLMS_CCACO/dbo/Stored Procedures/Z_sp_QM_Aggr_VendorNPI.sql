

CREATE PROCEDURE dbo.[Z_sp_QM_Aggr_VendorNPI]
AS
    INSERT INTO [dbo].[ztmp_Aggr_VendorNPI]
           ([VendorNpi]
           ,[Yr]
           ,[CatOfSvc]
           ,[TotBilled])
     SELECT h.VENDOR_ID, YEAR(h.PRIMARY_SVC_DATE) as Yr, CATEGORY_OF_SVC, SUM(TOTAL_BILLED_AMT)
    FROM adw.Claims_Headers h
    GROUP BY h.VENDOR_ID, YEAR(h.PRIMARY_SVC_DATE), CATEGORY_OF_SVC
