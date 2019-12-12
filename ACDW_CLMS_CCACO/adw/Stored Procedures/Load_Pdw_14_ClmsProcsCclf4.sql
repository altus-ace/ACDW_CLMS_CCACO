CREATE PROCEDURE [adw].[Load_Pdw_14_ClmsProcsCclf4]
AS 
    -- insert diags    
    INSERT INTO  adw.Claims_Diags
           ([SEQ_CLAIM_ID]
           ,[SUBSCRIBER_ID]
           ,[ICD_FLAG]
           ,[diagNumber]
           ,[diagCode]
           ,[diagPoa])
    SELECT cp.CUR_CLM_UNIQ_ID AS SEQ_CLAIM_ID
        , cp.BENE_HIC_NUM AS subscriberID
        , cp.CLM_VAL_SQNC_NUM AS DiagNum        
        , cp.[DGNS_PRCDR_ICD_IND]     AS ICD_FLAG		
        , cp.CLM_DGNS_CD		    as diagCode		
        , cp.CLM_POA_IND		    as diagPoa		
     FROM adi.CCLF4 cp 
	 --JOIN ast.pstcDgDeDupUrns  dd ON cp.URN = dd.urn
        JOIN ast.pstCclfClmKeyList ck ON ck.PRVDR_OSCAR_NUM  = cp.PRVDR_OSCAR_NUM
				    --AND ck.BENE_EQTBL_BIC_HICN_NUM	    = cp.BENE_EQTBL_BIC_HICN_NUM --commented it while it ran, output is zero when not commented
				    AND ck.CLM_FROM_DT			    = cp.CLM_FROM_DT
				    and ck.CLM_THRU_DT			    = cp.CLM_THRU_DT
        JOIN ast.pstcDgDeDupUrns  dd ON cp.URN = dd.urn --select * from ast.pstcDgDeDupUrns where urn = '4177560' select * FROM adi.CCLF4 
        JOIN ast.pstLatestEffectiveClmsHdr lr ON ck.clmSKey = lr.clmSKey
        JOIN adi.CCLF1 ch ON lr.clmHdrURN = ch.URN
		--AND ch.FileDate = '2019-07-22'
    ORDER BY cp.CUR_CLM_UNIQ_ID, cp.CLM_VAL_SQNC_NUM;
