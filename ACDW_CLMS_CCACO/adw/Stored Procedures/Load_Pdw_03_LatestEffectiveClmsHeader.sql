
CREATE PROCEDURE adw.Load_Pdw_03_LatestEffectiveClmsHeader
AS 
    TRUNCATE TABLE ast.pstLatestEffectiveClmsHdr;
    
    INSERT INTO ast.pstLatestEffectiveClmsHdr (clmSKey, clmHdrURN)
    SELECT src.clmSKey, src.URN
    FROM (SELECT csk.clmSKey, ch.URN
	       , ROW_NUMBER() OVER (PARTITION BY csk.clmSKey ORDER BY ch.CLM_EFCTV_DT desc, ch.CLM_ADJSMT_TYPE_CD DESC) LastEffective
	   FROM ast.pstCclfClmKeyList csk
	       JOIN adi.CCLF1 ch ON csk.PRVDR_OSCAR_NUM = ch.PRVDR_OSCAR_NUM
	   	   AND csk.BENE_EQTBL_BIC_HICN_NUM = ch.BENE_EQTBL_BIC_HICN_NUM
	   	   AND csk.CLM_FROM_DT = ch.CLM_FROM_DT
	   	   and csk.CLM_THRU_DT = ch.CLM_THRU_DT
	       JOIN ast.pstCclf1_DeDupClmsHdr ddH ON ch.urn = ddH.clm_URN	   
	   ) src
    WHERE src.LastEffective = 1

