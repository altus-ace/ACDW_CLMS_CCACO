
CREATE PROCEDURE adw.Load_Pdw_13_ClmsProcsCclf3
AS

    --Task 3 Insert Proc: -- Insert to proc    
    INSERT INTO adw.Claims_Procs
               ([SEQ_CLAIM_ID]
               ,[SUBSCRIBER_ID]
               ,[ProcNumber]
               ,[ProcCode]
               ,[ProcDate])
    SELECT cp.CUR_CLM_UNIQ_ID AS SEQ_CLAIM_ID
        , cp.BENE_HIC_NUM AS subscriberID
        , cp.CLM_VAL_SQNC_NUM AS ProcNum
        , cp.CLM_PRCDR_CD AS ProcCode
        , cp.CLM_PRCDR_PRFRM_DT AS ProcDate
    FROM adi.CCLF3 cp
        JOIN ast.pstCclfClmKeyList ck ON ck.PRVDR_OSCAR_NUM  = cp.PRVDR_OSCAR_NUM
    		  AND ck.BENE_EQTBL_BIC_HICN_NUM	    = cp.BENE_EQTBL_BIC_HICN_NUM
    		  AND ck.CLM_FROM_DT			    = cp.CLM_FROM_DT
    		  and ck.CLM_THRU_DT			    = cp.CLM_THRU_DT
        JOIN ast.pstcPrcDeDupUrns  dd ON cp.URN = dd.urn
        JOIN ast.pstLatestEffectiveClmsHdr lr ON ck.clmSKey = lr.clmSKey
        JOIN adi.CCLF1 ch ON lr.clmHdrURN = ch.URN
    ORDER BY cp.CUR_CLM_UNIQ_ID, cp.CLM_VAL_SQNC_NUM;
