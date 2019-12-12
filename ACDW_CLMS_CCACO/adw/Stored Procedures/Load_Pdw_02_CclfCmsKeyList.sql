CREATE PROCEDURE [adw].[Load_Pdw_02_CclfCmsKeyList]
AS 
--Good to run / process SP.
    TRUNCATE TABLE ast.pstCclfClmKeyList;
    /* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */
    INSERT INTO ast.pstCclfClmKeyList(
	   clmSKey
	   , PRVDR_OSCAR_NUM
	   , BENE_EQTBL_BIC_HICN_NUM
	   , CLM_FROM_DT,CLM_THRU_DT)
    SELECT S.PRVDR_OSCAR_NUM +'.'+S.BENE_EQTBL_BIC_HICN_NUM+'.'+convert(varchar(10), S.CLM_FROM_DT,101)+'.'+CONVERT(varchar(10), S.CLM_THRU_DT,101) AS clmBigKey
	   ,S.PRVDR_OSCAR_NUM ,S.BENE_EQTBL_BIC_HICN_NUM, S.CLM_FROM_DT,S.CLM_THRU_DT
    FROM (SELECT --top 100  ch.URN, ch.CUR_CLM_UNIQ_ID
		  DISTINCT  PRVDR_OSCAR_NUM, CLM_FROM_DT,	 CLM_THRU_DT,	  BENE_EQTBL_BIC_HICN_NUM
		  FROM adi.CCLF1 ch
			 JOIN ast.pstCclf1_DeDupClmsHdr ddH ON ch.urn = ddH.clm_URN) S;

			 --select * from ast.pstCclf1_DeDupClmsHdr
			 --select * from ast.pstCclfClmKeyList

