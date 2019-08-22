CREATE FUNCTION adw.tvf_get_gender
(@gender VARCHAR(10)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           SUBSCRIBER_ID
    FROM adw.tvf_get_active_members(1)
    WHERE gender = @gender
);
