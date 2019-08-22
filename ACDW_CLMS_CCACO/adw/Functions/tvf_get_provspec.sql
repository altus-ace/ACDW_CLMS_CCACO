
/****** Object:  UserDefinedFunction [dbo].adw.tvf_get_active_members2    Script Date: 12/20/2018 11:39:29 AM ******/

CREATE FUNCTION adw.tvf_get_provspec
(@spec1 VARCHAR(50), 
 @spec2 VARCHAR(50), 
 @spec3 VARCHAR(50), 
 @spec4 VARCHAR(50), 
 @spec5 VARCHAR(50), 
 @spec6 VARCHAR(50)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           SEQ_CLAIM_ID, 
           SUBSCRIBER_ID, 
           PRIMARY_SVC_DATE, 
           ADMISSION_DATE, 
           SVC_TO_DATE
    FROM adw.Claims_Headers a
         JOIN
    (
        SELECT DISTINCT 
               Source
        FROM [lst].[ListAceMapping]
        WHERE Destination IN(@spec1, @spec1, @spec3, @spec4, @spec5, @spec6)
    ) b ON a.PROV_SPEC = b.source
);
