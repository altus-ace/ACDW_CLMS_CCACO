
CREATE PROCEDURE [adw].[Load_Pdw_20_ClmsHdrsCclf5]
AS 
    -- Insert claims headers for CCLF5
    INSERT INTO adw.Claims_Headers
           ([SEQ_CLAIM_ID]	  
           ,[SUBSCRIBER_ID]	  
           ,[CLAIM_NUMBER]
           ,[CATEGORY_OF_SVC]
           ,[PAT_CONTROL_NO]
           ,[ICD_PRIM_DIAG]
           ,[PRIMARY_SVC_DATE]
           ,[SVC_TO_DATE]		 
           ,[CLAIM_THRU_DATE]                      
		 , ADMISSION_DATE
           ,[SVC_PROV_NPI]
           ,[PROV_SPEC]
           ,[PROV_TYPE]                                           
           ,[CLAIM_STATUS]           
           ,[CLAIM_TYPE]
           , DRG_CODE
           )    
    SELECT 
	   c.CUR_CLM_UNIQ_ID			  AS SEQ_CLAIM_ID -- maybe CLM_CNTL_NUM (as it is a cms umbrella clm number )
	   , c.BENE_HIC_NUM			  AS Subscriber_ID
	   , c.CLM_CNTL_NUM			  AS Claim_Number		 -- use this as it's function is similar to the composite natural key used on the other tables 
	   , 'PHYSICIAN'			  AS Category_Of_Svc
	   , c.BENE_EQTBL_BIC_HICN_NUM  AS pat_Control_No
	   , c.CLM_LINE_DGNS_CD		  AS  [ICD_PRIM_DIAG]
	   , c.[CLM_FROM_DT]		  as PRIMARY_SVC_DATE
	   , c.[CLM_THRU_DT]		  as Service_to_date
	   , c.[CLM_THRU_DT]		  as Claim_Thru_date
	   , c.[CLM_FROM_DT]		  as ADMISSION_DATE
	   , c.RNDRG_PRVDR_NPI_NUM	  as SVC_PROV_NPI
	   , c.[CLM_PRVDR_SPCLTY_CD]	  AS	PROV_SPEC
	   , c.[RNDRG_PRVDR_TYPE_CD]	  AS PROV_TYPE        
	   , c.CLM_CARR_PMT_DNL_CD	  AS [CLAIM_STATUS]
	   , 'UBH-PROF'			  AS CLAIM_TYPE
	   , 'NO_APR'				  AS DRG_CODE
    FROM adi.CCLF5 c
	   JOIN ast.pstcDeDupClms_Cclf5 d ON c.URN = d.urn
    WHERE c.CLM_LINE_NUM = 1 and filedate = (select max(filedate) from adi.cclf5)
    ;
