
CREATE PROCEDURE [adw].[LoadPdw_04_DeDupClmsLns]
AS 
    /* PURPOSE: -- 4. de dup claims details
	    this is ready to be refactored 
	   
	   */
    TRUNCATE TABLE ast.pstcLnsDeDupUrns;
    INSERT INTO ast.pstcLnsDeDupUrns (URN)
    SELECT s.urn
    FROM (SELECT cl.urn, cl.originalFileName,cl.FileDate
	   , ROW_NUMBER() OVER (PARTITION BY cl.CUR_CLM_UNIQ_ID, cl.clm_line_Num ORDER BY cl.FileDate, cl.originalFileName ASC) arn	   
	   FROM adi.cclf2 cl) s
    WHERE s.arn = 1;
