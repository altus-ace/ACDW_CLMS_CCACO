
CREATE PROCEDURE [adw].[Load_Pdw_11_ClmsHeadersCclf1]
AS    
    -- 1. Insert cliams Using LastClmRow set 
    
    INSERT INTO adw.Claims_Headers
           ([SEQ_CLAIM_ID]		 -- cur clm id
           ,[SUBSCRIBER_ID]		 -- HICN or EQTBL HCN ???
           ,[CLAIM_NUMBER]		 -- put composit key in here           
		 ,[CATEGORY_OF_SVC]		 --           
		 ,[PAT_CONTROL_NO]
           ,[ICD_PRIM_DIAG]		 -- prncpl_dgns_cd
           ,[PRIMARY_SVC_DATE]	 --            
           ,[CLAIM_THRU_DATE]           		
		 ,SVC_TO_DATE			             
		 ,ADMISSION_DATE
           ,[SVC_PROV_NPI]                      
           ,[ATT_PROV_NPI]        		        
		 , VENDOR_ID    
		 ,[PROV_SPEC]
		 ,[PROV_TYPE]                                            
           ,[DRG_CODE]           
           ,[ADMIT_SOURCE_CODE]          
           ,[PATIENT_STATUS]
           ,[CLAIM_STATUS] 
		   ,[PROCESSING_STATUS]
           ,[TOTAL_BILLED_AMT]
		 ,[CLAIM_TYPE]           
	   )           
     SELECT 
	   ch.CUR_CLM_UNIQ_ID
	   ,ch.[BENE_HIC_NUM]		-- or 	ch.BENE_EQTBL_BIC_HICN_NUM-- SUBSCRIBER_ID
	   ,lr.clmSKey				-- Claim_number
	   ,ch.[CLM_TYPE_CD]		--	CATEGORY_OF_SVC
	   ,ch.BENE_EQTBL_BIC_HICN_NUM -- PaT_CNTRL_NUM
	   ,ch.PRNCPL_DGNS_CD		--	ICD PRIM DIAG
	   ,ch.[CLM_FROM_DT]		--	PRIMARY_SVC_DATE
	   ,ch.[CLM_THRU_DT]		--	CLAIM_THRU_DATE	
	   ,ch.[CLM_THRU_DT]		 -- svc_to_date
	   , ch.[CLM_FROM_DT]		--	Admission Date
	   ,ch.OPRTG_PRVDR_NPI_NUM	 -- svcProvNpi
	   ,ch.ATNDG_PRVDR_NPI_NUM	 -- attProvNpi
	   ,ch.FAC_PRVDR_NPI_NUM		 -- vendor id
	   ,'' AS	PROV_SPEC			 -- load from professional claims
	   ,'' AS PROV_TYPE        
	   ,ch.[DGNS_DRG_CD]		--	DRG_CODE
	   ,ch.CLM_ADMSN_SRC_CD		 -- Admit_source_code
	   ,ch.[BENE_PTNT_STUS_CD]	--	PATIENT_STATUS
	   ,ch.CLM_QUERY_CD			 -- claim status
	   ,'P'
	   , ch.CLM_PMT_AMT			 -- total billed amount? 	
	   , ch.CLM_TYPE_CD			-- claim_type	
	FROM adi.CCLF1 ch
	   JOIN ast.pstLatestEffectiveClmsHdr lr ON ch.URN = lr.clmHdrURN
    ;

	--select * from adw.Claims_Headers
