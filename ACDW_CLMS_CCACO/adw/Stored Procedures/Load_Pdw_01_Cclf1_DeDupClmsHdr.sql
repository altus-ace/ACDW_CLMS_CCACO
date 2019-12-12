

--Dont use the SP, load separately.
/* load set management tables  */

CREATE PROCEDURE [adw].[Load_Pdw_01_Cclf1_DeDupClmsHdr]
AS
    -- Claims Dedup: Use this table to remove any duplicated input rows, they will be duplicated and versioned.. 
    TRUNCATE TABLE ast.pstCclf1_DeDupClmsHdr;
	--Ensure records loaded tallies with cclf1 records (validation)
    INSERT INTO ast.pstCclf1_DeDupClmsHdr(clm_URN)
    SELECT s.urn
    FROM (SELECT ch.urn,ch.CUR_CLM_UNIQ_ID, ch.originalFileName, fileDate
	   	  , ROW_NUMBER() OVER (PARTITION BY ch.CUR_CLM_UNIQ_ID ORDER BY ch.FileDate DESC, ch.originalFileName ASC) arn
		  FROM adi.cclf1 ch where filedate = ( select max(filedate) from adi.cclf1)) s
    WHERE s.arn = 1 and filedate =( select max(filedate) from adi.cclf1);

	--select max(filedate) from adi.cclf1 where filedate not in ( select max(filedate) from adi.cclf1)
	--select * from ast.pstCclf1_DeDupClmsHdr
	--select *from [ACDW_CLMS_CCACO].[adi].[CCLF1] where filedate ='2019-07-22'
	----select *from [ACDW_CLMS_CCACO].[adi].[CCLF1] where filedate ='2019-08-08'
	----order by createdate desc

	--select  distinct  bene_hic_num from [ACDW_CLMS_CCACO].[adi].[CCLF1] where filedate = '2019-07-22'
	--select    count(CUR_CLM_UNIQ_ID),bene_hic_num from [ACDW_CLMS_CCACO].[adi].[CCLF1] where filedate = '2019-07-22'
	--group by BENE_HIC_NUM

