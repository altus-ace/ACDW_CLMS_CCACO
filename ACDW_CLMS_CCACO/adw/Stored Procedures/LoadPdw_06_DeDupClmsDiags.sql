
CREATE PROCEDURE [adw].[LoadPdw_06_DeDupClmsDiags]
AS 

     /* -- 6. de dup diags

	   get diags sets by claim and line and adj and ???
	   deduplicate for cases:
		  1. deal with duplicates: all relavant details are the same
		  2. deal with adjustments: if details sub line code is different
		  3. deal with???? will determin as we move forward

	   sort by file date or???
	   
	   insert into ast claims dedup diags urns table [pstcDgDeDupUrns]
    */
    TRUNCATE table [ast].[pstcDgDeDupUrns]
    INSERT INTO ast.pstcDgDeDupUrns (urn)
    SELECT s.URN
    FROM (SELECT c.URN, CUR_CLM_UNIQ_ID, CLM_VAL_SQNC_NUM, originalFileName, c.FileDate
	   	  , ROW_NUMBER() OVER (PARTITION BY c.CUR_CLM_UNIQ_ID, c.CLM_VAL_SQNC_NUM ORDER BY c.FileDate DESC, c.originalFileName ASC) aDupID
		  FROM adi.cclf4 c ) s
		  WHERE s.aDupID = 1;

		 -- select * from [ast].[pstcDgDeDupUrns]
