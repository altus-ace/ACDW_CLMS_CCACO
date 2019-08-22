--EXEC adw.InsertMbrEnrFromAssignable 2018, 3;
CREATE PROCEDURE adw.[z_InsertMbrEnrFromAssignable]
    @MbrYear INT
    , @MbrQtr INT   
AS

DECLARE @lMbrYear INT = @MbrYear	 --  = 2018;
DECLARE @lMbrQtr INT  = @MbrQtr	 --  = 2;


TRUNCATE TABLE adw.M_MEMBER_ENR;

INSERT INTO adw.M_MEMBER_ENR (
    SUBSCRIBER_ID
    , M_Last_Name
    , M_First_Name
    , M_Gender
    , M_Date_Of_Birth
    )
SELECT mh.HICN,
           mh.Lname,mh.Fname
		, CASE WHEN (mh.SEX = 1) then 'M' 
			  WHEN (mh.SEX = 2) then 'F'
				ELSE 'U' END AS Gender
		 ,mh.DOB
FROM adw.Assignable_Member_History mh
WHERE mh.MBR_YEAR = @lMbrYear
      AND mh.MBR_QTR = @lMbrQtr
;
