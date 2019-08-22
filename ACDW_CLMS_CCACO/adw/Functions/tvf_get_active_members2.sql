

CREATE FUNCTION [adw].[tvf_get_active_members2]
(
 @date date

)
RETURNS TABLE
AS
     RETURN
(
select distinct HICN as SUBSCRIBER_ID, case when Sex=1 then 'M' else 'F' end as GENDER , DOB , datediff(year,  DOB, convert(DATE, @date, 101)) as AGE from tmp_Active_Members
)
