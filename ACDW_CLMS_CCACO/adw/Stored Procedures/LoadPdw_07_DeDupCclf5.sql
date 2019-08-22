
CREATE PROCEDURE [adw].[LoadPdw_07_DeDupCclf5]
AS    
    /* THIS IS UNIQUE TO CCLF model to handle PROFESSIONAL Component */

    TRUNCATE TABLE ast.pstcDeDupClms_Cclf5;

    INSERT INTO ast.pstcDeDupClms_Cclf5 (urn)
    SELECT s.urn
    FROM (select urn, CUR_CLM_UNIQ_ID, clm_line_num, BENE_HIC_NUM
    		  , BENE_EQTBL_BIC_HICN_NUM, CLM_FROM_DT, CLM_THRU_DT 
    		  , CLM_TYPE_CD, CLM_CARR_PMT_DNL_CD, CLM_PRCSG_IND_CD, CLM_ADJSMT_TYPE_CD
    		  , fileDate, srcfileName
    		  , ROW_NUMBER() OVER (partition by CUR_CLM_UNIQ_ID, clm_line_num ORDER BY FileDate Desc) arn
           FROM adi.cclf5 ) s
    WHERE s.arn = 1

