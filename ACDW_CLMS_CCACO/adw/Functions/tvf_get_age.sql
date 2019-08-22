CREATE FUNCTION adw.tvf_get_age
(@age_start        VARCHAR(10), 
 @age_end          VARCHAR(10), 
 @measurement_date VARCHAR(20)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           SUBSCRIBER_ID
    FROM adw.tvf_get_active_members(1)
    WHERE DATEDIFF(year, DOB, CONVERT(DATE, @measurement_date, 101)) BETWEEN @age_start AND @age_end
);
