
/****** Object:  UserDefinedFunction [dbo].adw.tvf_get_active_members2    Script Date: 12/20/2018 11:39:29 AM ******/

CREATE FUNCTION [adw].[tvf_2020_Get_ProvSpec]
(@Provspec1 VARCHAR(50), 
 @Provspec2 VARCHAR(50), 
 @Provspec3 VARCHAR(50), 
 @Provspec4 VARCHAR(50), 
 @Provspec5 VARCHAR(50), 
 @Provspec6 VARCHAR(50)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT SEQ_CLAIM_ID, SUBSCRIBER_ID, PRIMARY_SVC_DATE,ADMISSION_DATE, SVC_TO_DATE
    FROM			adw.Claims_Headers a
    JOIN
					(
					 SELECT DISTINCT 
					 Source
					 FROM [lst].[ListAceMapping]
					 WHERE Destination IN(@Provspec1, @Provspec1, @Provspec3, @Provspec4, @Provspec5, @Provspec6)
					) b 
	ON				a.PROV_SPEC = b.source
);