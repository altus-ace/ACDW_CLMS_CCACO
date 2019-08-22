
CREATE PROCEDURE adw.Load_Pdw_21_ClmsDtlsCclf5
AS 
    -- detail
  --SELECT count(*) FROM dbo.Claims_Details d
    INSERT INTO adw.Claims_Details
               ([CLAIM_NUMBER]
               ,[SEQ_CLAIM_ID]			
               ,[LINE_NUMBER]
               ,[SUB_LINE_CODE]
               ,[DETAIL_SVC_DATE]
               ,[SVC_TO_DATE]
               ,[PROCEDURE_CODE]
               ,[MODIFIER_CODE_1]
               ,[MODIFIER_CODE_2]
               ,[MODIFIER_CODE_3]
               ,[MODIFIER_CODE_4]
               ,[REVENUE_CODE]
               ,[PLACE_OF_SVC_CODE1]           
               ,[QUANTITY]               
               ,[Paid_Amt])
    SELECT           
        c.CLM_CNTL_NUM				    AS CLAIM_NUMBER				 
	   , CUR_CLM_UNIQ_ID			    AS SEQ_CLAIM_ID	    
        --, c.BENE_HIC_NUM				    AS SUBSCRIBER_ID need to push the seq claim id to model
        , c.CLM_LINE_NUM				    AS LINE_NUMBER
        , ''						    AS SUB_LINE_CODE    
        , c.CLM_LINE_FROM_DT			    AS Detail_SvC_DATE
        , c.CLM_LINE_THRU_DT			    AS SVC_TO_DATE
        , c.CLM_LINE_HCPCS_CD			    AS Procedure_CODE
        , c.HCPCS_1_MDFR_CD			    AS Modifier_1
        , c.HCPCS_2_MDFR_CD			    AS Modifier_2
        , c.HCPCS_3_MDFR_CD			    AS Modifier_3
        , c.HCPCS_4_MDFR_CD			    AS Modifier_4 
        , ''	 					    AS REV_CODE
        , CLM_POS_CD				    AS Place_of_svc_Code1
        , c.CLM_LINE_SRVC_UNIT_QTY		    AS Quantity
        , c.CLM_LINE_CVRD_PD_AMT		    AS paid_AMT
    FROM adi.CCLF5 c
        JOIN ast.pstcDeDupClms_Cclf5 d ON c.URN = d.urn
