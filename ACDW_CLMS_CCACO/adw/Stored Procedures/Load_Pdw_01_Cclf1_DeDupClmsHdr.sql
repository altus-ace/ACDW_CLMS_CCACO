


/* load set management tables  */

CREATE PROCEDURE adw.Load_Pdw_01_Cclf1_DeDupClmsHdr
AS
    -- Claims Dedup: Use this table to remove any duplicated input rows, they will be duplicated and versioned.. 
    TRUNCATE TABLE ast.pstCclf1_DeDupClmsHdr;

    INSERT INTO ast.pstCclf1_DeDupClmsHdr(clm_URN)
    SELECT s.urn
    FROM (SELECT ch.urn, ch.CUR_CLM_UNIQ_ID, ch.originalFileName, fileDate
	   	  , ROW_NUMBER() OVER (PARTITION BY ch.CUR_CLM_UNIQ_ID ORDER BY ch.FileDate DESC, ch.originalFileName ASC) arn
		  FROM adi.cclf1 ch) s
    WHERE s.arn = 1;

