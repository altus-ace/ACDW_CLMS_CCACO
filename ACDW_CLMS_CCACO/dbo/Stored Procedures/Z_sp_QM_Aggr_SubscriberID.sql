
CREATE PROCEDURE [dbo].[Z_sp_QM_Aggr_SubscriberID]
AS
    truncate table dbo.[ztmp_Aggr_SubscriberID];
    INSERT INTO [dbo].[ztmp_Aggr_SubscriberID]
           ([SubscriberID]
           ,[Yr]
           ,[CatOfSvc]
           ,[TotBilled])
    SELECT h.SUBSCRIBER_ID, YEAR(PRIMARY_SVC_DATE) YR, CATEGORY_OF_SVC, SUM(h.TOTAL_BILLED_AMT)
    FROM adw.Claims_Headers h
    GROUP BY h.SUBSCRIBER_ID, Year(PRIMARY_SVC_DATE), CATEGORY_OF_SVC
