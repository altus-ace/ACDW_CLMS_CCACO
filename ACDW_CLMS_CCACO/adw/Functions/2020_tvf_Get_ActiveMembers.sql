
/***
Retrieves list of active members 
***/

CREATE FUNCTION [adw].[2020_tvf_Get_ActiveMembers]
(@EffDate		DATE
)
RETURNS TABLE
AS
RETURN
( 
SELECT 
			DISTINCT HICN AS SUBSCRIBER_ID,
			CASE WHEN SEX =1 THEN 'M' 
				 WHEN SEX = 2 THEN 'F' ELSE SEX END AS GENDER,
			DOB, 
			DATEDIFF(yy, DOB, CONVERT(DATE, @EffDate, 101)) AS AGE,
			LOAD_DATE
FROM 
			(
SELECT		H.HICN, H.SEX, H.DOB, H.LOAD_DATE 
FROM		adw.tmp_Active_Members h 
--- WHERE		EXCLUSION = 'N' AND [PLAN] <> '' to be implemented afterwards
			) a
)

/***
Usage: 
SELECT *
FROM [adw].[2020_tvf_Get_ActiveMembers] ('09/01/2019') 
***/