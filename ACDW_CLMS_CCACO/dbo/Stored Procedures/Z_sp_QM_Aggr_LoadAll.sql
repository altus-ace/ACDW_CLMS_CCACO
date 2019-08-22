
CREATE PROCEDURE dbo.[Z_sp_QM_Aggr_LoadAll]
AS
    EXEC Z_sp_QM_Aggr_AttProvNPI;
    EXEC Z_sp_QM_Aggr_SubscriberID;
    EXEC Z_sp_QM_Aggr_VendorNPI;
