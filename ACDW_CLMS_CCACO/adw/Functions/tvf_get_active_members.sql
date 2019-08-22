CREATE FUNCTION adw.tvf_get_active_members
(@isactive INT
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           SUBSCRIBER_ID, 
           M_Gender AS gender, 
           M_Date_Of_Birth AS DOB
    FROM adw.M_MEMBER_ENR
    WHERE CLIENT_ID = 'ACO_N'
);
