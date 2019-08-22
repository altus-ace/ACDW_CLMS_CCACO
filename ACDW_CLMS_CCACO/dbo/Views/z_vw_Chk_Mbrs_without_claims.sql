CREATE VIEW dbo.z_vw_Chk_Mbrs_without_claims
AS
     SELECT DISTINCT 
            SUBSCRIBER_ID
     FROM adw.M_MEMBER_ENR
     EXCEPT
     SELECT DISTINCT 
            SUBSCRIBER_ID
     FROM adw.Claims_Headers;
