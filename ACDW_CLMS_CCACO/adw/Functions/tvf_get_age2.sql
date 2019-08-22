CREATE FUNCTION adw.tvf_get_age2
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
    FROM adw.tvf_get_active_members2(@measurement_date) a
    WHERE AGE BETWEEN @age_start AND @age_end
);
