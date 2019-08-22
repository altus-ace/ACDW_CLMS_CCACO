
CREATE PROCEDURE adw.sp_Load_ClaimsNotReversedNotDenied
AS
     TRUNCATE TABLE adw.tmp_Claims_NotReversedNotDenied;
     INSERT INTO adw.tmp_Claims_NotReversedNotDenied(SEQ_CLAIM_ID)
            SELECT DISTINCT 
                   SEQ_CLAIM_ID
            FROM
            (
                SELECT SEQ_CLAIM_ID, 
                       LINE_NUMBER
                FROM adw.Claims_Details
                EXCEPT
                SELECT SEQ_CLAIM_ID, 
                       LINE_NUMBER
                FROM adw.Claims_Details
                WHERE SUB_LINE_CODE = 'R'
            ) a
            EXCEPT
            SELECT DISTINCT 
                   SEQ_CLAIM_ID
            FROM adw.Claims_Headers
            WHERE CLAIM_STATUS <> 'D';
