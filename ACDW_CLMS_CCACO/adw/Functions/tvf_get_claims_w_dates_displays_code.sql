





CREATE FUNCTION [adw].[tvf_get_claims_w_dates_displays_code]
(@param2           VARCHAR(250), 
 @param3           VARCHAR(250), 
 @param4           VARCHAR(250), 
 @claim_date_start VARCHAR(20), 
 @claim_date_end   VARCHAR(20)
)
RETURNS TABLE
AS
     RETURN
(
	

	  SELECT DISTINCT 
           B1.SUBSCRIBER_ID, 
           B1.SEQ_CLAIM_ID, 
           B1.PRIMARY_SVC_DATE, 
		   B1.PROV_SPEC,
		   D.VALUE_CODE,
		   D.VALUE_SET_NAME,
		   D.code_set as CODE_SET
    FROM adw.CLAIMS_HEADERS B1
         INNER JOIN
    (

        SELECT DISTINCT 
            
               C1.SEQ_CLAIM_ID,VALUE_SET_NAME, 'ICD10PCS/ICD9PCS' as code_set, value_code 
        FROM adw.CLAIMS_PROCS C1
             INNER JOIN (select distinct value_code, value_set_name from ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L1 WHERE L1.VALUE_SET_NAME IN(@param2, @param3, @param4)
             AND L1.ACTIVE = 'Y'
             AND VALUE_CODE_SYSTEM IN('ICD10PCS', 'ICD9PCS'))L11 ON L11.VALUE_CODE = C1.ProcCode
      
        UNION
        SELECT distinct
               C2.SEQ_CLAIM_ID,VALUE_SET_NAME, 'MSDRG' as code_set, value_code 
        FROM adw.CLAIMS_HEADERS C2
             INNER JOIN 
			 (select distinct value_code, value_set_name from ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L2  WHERE L2.VALUE_SET_NAME IN(@param2, @param3, @param4)
             AND L2.ACTIVE = 'Y'
             AND VALUE_CODE_SYSTEM IN('MSDRG')) L22 ON L22.VALUE_CODE = C2.DRG_CODE
       
        UNION
        SELECT distinct
               C3.SEQ_CLAIM_ID,VALUE_SET_NAME, 'ICD10CM/ICD9CM' as code_set, value_code 
        FROM adw.CLAIMS_DIAGS C3
             INNER JOIN (select distinct value_code, value_set_name from ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L3         WHERE L3.VALUE_SET_NAME IN(@param2, @param3, @param4)
             AND L3.ACTIVE = 'Y'
             AND VALUE_CODE_SYSTEM IN('ICD9CM', 'ICD10CM'))L33 ON L33.VALUE_CODE = C3.DIAGCODE

        UNION
            SELECT DISTINCT 
                   C4.SEQ_CLAIM_ID,VALUE_SET_NAME, 'UBREV' as code_set, value_code 
            FROM adw.CLAIMS_DETAILS C4
                 INNER JOIN (select distinct value_code, value_set_name from ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L4   WHERE L4.VALUE_SET_NAME IN(@param2, @param3, @param4)
                 AND L4.ACTIVE = 'Y'
                 AND VALUE_CODE_SYSTEM IN('UBREV'))L44 ON try_convert(int,L44.VALUE_CODE)=try_convert(int,C4.REVENUE_CODE)
          
            UNION
            SELECT DISTINCT 
                   C5.SEQ_CLAIM_ID,VALUE_SET_NAME, 'NDC' as code_set, value_code 
            FROM adw.CLAIMS_DETAILS C5
                 INNER JOIN
				 (select distinct value_code, value_set_name from  ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L5  WHERE L5.VALUE_SET_NAME IN(@param2, @param3, @param4)
                 AND L5.ACTIVE = 'Y'
                 AND VALUE_CODE_SYSTEM IN('NDC'))L55 ON L55.VALUE_CODE = C5.NDC_CODE
          
            UNION
			SELECT DISTINCT 
                   C6.SEQ_CLAIM_ID,VALUE_SET_NAME, 'CPT/CPTCATII/HCPCS/CDT' as code_set, value_code 
            FROM adw.CLAIMS_DETAILS C6
                 INNER JOIN 
				 (select distinct value_code, value_set_name from ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L6   WHERE L6.VALUE_SET_NAME IN(@param2, @param3, @param4)
                 AND L6.ACTIVE = 'Y'
                 AND L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT'))L66 ON L66.VALUE_CODE = C6.PROCEDURE_CODE
            UNION
			SELECT DISTINCT 
                  C7.SEQ_CLAIM_ID,VALUE_SET_NAME, 'POS' as code_set, value_code 
            FROM adw.CLAIMS_DETAILS C7
                 INNER JOIN 
				 (select distinct value_code, value_set_name from ACDW_CLMS_CCACO.LST.List_HEDIS_CODE L7   WHERE L7.VALUE_SET_NAME IN(@param2, @param3, @param4)
                 AND L7.ACTIVE = 'Y'
                 AND L7.VALUE_CODE_SYSTEM IN('POS'))L77 ON L77.VALUE_CODE = C7.PLACE_OF_SVC_CODE1

    ) AS D ON D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID 
    WHERE B1.PRIMARY_SVC_DATE >= @claim_date_start
          AND B1.PRIMARY_SVC_DATE <= @claim_date_end
);


