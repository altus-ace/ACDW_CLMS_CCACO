
CREATE PROCEDURE [adw].[Load_Pdw_12_ClmsDetailsCclf2]
AS 
    INSERT INTO adw.Claims_Details
		  (SEQ_CLAIM_ID,
		   CLAIM_NUMBER,
		   LINE_NUMBER,
		   SUB_LINE_CODE,
		   DETAIL_SVC_DATE,
		   SVC_TO_DATE,
		   MODIFIER_CODE_1,
		   MODIFIER_CODE_2,
		   MODIFIER_CODE_3,
		   MODIFIER_CODE_4,
		   REVENUE_CODE,
		   PLACE_OF_SVC_CODE1,
		   PLACE_OF_SVC_CODE2,
		   QUANTITY,
		   Paid_Amt
		  )
       SELECT  cl.[CUR_CLM_UNIQ_ID]						as seq_Claim_ID 
              ,ck.clmSKey							as claim_number 
              ,cl.[CLM_LINE_NUM]						as line_Number 
              ,ch.CLM_ADJSMT_TYPE_CD					as SUB_LINE_CODE 
              ,ISNULL(cl.[CLM_LINE_FROM_DT], '1/1/1980')	as DETAIL_SVC_DATE 
              ,ISNULL(cl.[CLM_LINE_THRU_DT], '1/1/1980')	as SVC_TO_DATE 
              ,cl.[HCPCS_1_MDFR_CD]					as MODIFIER_CODE_1 
              ,cl.[HCPCS_2_MDFR_CD]					as MODIFIER_CODE_2 
              ,cl.[HCPCS_3_MDFR_CD]					as MODIFIER_CODE_3 
              ,cl.[HCPCS_4_MDFR_CD]					as MODIFIER_CODE_4 
              ,cl.[CLM_LINE_PROD_REV_CTR_CD]				as REVENUE_CODE 
              ,ch.[CLM_BILL_FAC_TYPE_CD]	   			as PLACE_OF_SVC_CODE1 
              ,ch.[CLM_BILL_CLSFCTN_CD]					as PLACE_OF_SVC_CODE2 
              ,cl.CLM_LINE_SRVC_UNIT_QTY				as QUANTITY 
              ,cl.CLM_LINE_CVRD_PD_AMT					as Paid_amt     
       FROM adi.CCLF2 cl
            JOIN ast.pstCclfClmKeyList ck ON ck.PRVDR_OSCAR_NUM = cl.PRVDR_OSCAR_NUM
                                AND ck.BENE_EQTBL_BIC_HICN_NUM = cl.BENE_EQTBL_BIC_HICN_NUM
                                AND ck.CLM_FROM_DT = cl.CLM_FROM_DT
                                AND ck.CLM_THRU_DT = cl.CLM_THRU_DT
		  -- why CCLF5??? Head yea, Latest Eff Yeah.... CCL%5 makes no sense.
            --JOIN ast.pstcDeDupClms_Cclf5 dd ON cl.URN = dd.urn THIS IS A BUG
            JOIN ast.pstLatestEffectiveClmsHdr lr ON ck.clmSKey = lr.clmSKey
            JOIN adi.CCLF1 ch ON lr.clmHdrURN = ch.URN
       ORDER BY cl.CUR_CLM_UNIQ_ID,
                cl.CLM_LINE_NUM;
