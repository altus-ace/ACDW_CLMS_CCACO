
CREATE PROCEDURE [adw].[LoadPdw_05_DeDupClmsProcs]
AS 
    /* -- 5. de dup procedures

	   get procs sets by claim and line and adj and ???
	   deduplicate for cases:
		  1. deal with duplicates: all relavant details are the same
		  2. deal with adjustments: if details sub line code is different
		  3. deal with???? will determin as we move forward

	   sort by file date or???
	   
	   insert into ast claims dedup procedure urns table
    */
    TRUNCATE table ast.pstcPrcDeDupUrns 
    INSERT INTO ast.pstcPrcDeDupUrns  (urn)
    SELECT s.URN
    FROM (SELECT c.URN, CUR_CLM_UNIQ_ID, CLM_VAL_SQNC_NUM, originalFileName, c.fileDAte
		  , ROW_NUMBER() OVER (PARTITION BY c.CUR_CLM_UNIQ_ID, c.CLM_VAL_SQNC_NUM ORDER BY c.FileDate Desc, c.originalFileName ASC) aDupID
	   FROM adi.cclf3 c) s
    WHERE s.aDupID = 1;
