CREATE VIEW dbo.z_vw_Chk_Mbrs_with_claims
AS
     SELECT DISTINCT 
            SUBSCRIBER_ID
     FROM adw.M_MEMBER_ENR
     INTERSECT
     SELECT DISTINCT 
            SUBSCRIBER_ID
     FROM adw.Claims_Headers;
