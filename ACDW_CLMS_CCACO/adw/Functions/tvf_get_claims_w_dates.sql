
CREATE FUNCTION adw.tvf_get_claims_w_dates
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
           B1.CLAIM_THRU_DATE, 
           B1.PROV_SPEC, 
           B1.ADMISSION_DATE, 
           B1.CATEGORY_OF_SVC, 
           B1.[SVC_TO_DATE]--,D.VALUE_SET_NAME
    FROM adw.Claims_Headers B1
         INNER JOIN
    (
        SELECT DISTINCT 
               C1.SEQ_CLAIM_ID--,L1.VALUE_SET_NAME
        FROM Claims_Procs C1
             INNER JOIN
        (
            SELECT DISTINCT 
                   VALUE_CODE
            FROM lst.LIST_HEDIS_CODE L1
            WHERE L1.VALUE_SET_NAME IN(@param2, @param3, @param4)
            AND L1.ACTIVE = 'Y'
            AND VALUE_CODE_SYSTEM IN('ICD10PCS', 'ICD9PCS')
        ) L11 ON L11.VALUE_CODE = C1.ProcCode
        UNION
        SELECT DISTINCT 
               C2.SEQ_CLAIM_ID--,L2.VALUE_SET_NAME
        FROM adw.Claims_Headers C2
             INNER JOIN
        (
            SELECT DISTINCT 
                   VALUE_CODE
            FROM lst.LIST_HEDIS_CODE L2
            WHERE L2.VALUE_SET_NAME IN(@param2, @param3, @param4)
            AND L2.ACTIVE = 'Y'
            AND VALUE_CODE_SYSTEM IN('MSDRG')
        ) L22 ON L22.VALUE_CODE = C2.DRG_CODE
        UNION
        SELECT DISTINCT 
               C3.SEQ_CLAIM_ID--,L3.VALUE_SET_NAME
        FROM adw.Claims_Diags C3
             INNER JOIN
        (
            SELECT DISTINCT 
                   VALUE_CODE
            FROM lst.LIST_HEDIS_CODE L3
            WHERE L3.VALUE_SET_NAME IN(@param2, @param3, @param4)
            AND L3.ACTIVE = 'Y'
            AND VALUE_CODE_SYSTEM IN('ICD9CM', 'ICD10CM')
        ) L33 ON L33.VALUE_CODE = C3.diagCode
        UNION
        SELECT DISTINCT 
               C4.SEQ_CLAIM_ID--,L4.VALUE_SET_NAME
        FROM Claims_Details C4
             INNER JOIN
        (
            SELECT DISTINCT 
                   VALUE_CODE
            FROM lst.LIST_HEDIS_CODE L4
            WHERE L4.VALUE_SET_NAME IN(@param2, @param3, @param4)
            AND L4.ACTIVE = 'Y'
            AND VALUE_CODE_SYSTEM IN('UBREV')
        ) L44 ON L44.VALUE_CODE = C4.REVENUE_CODE
        UNION
        SELECT DISTINCT 
               C5.SEQ_CLAIM_ID--,L5.VALUE_SET_NAME
        FROM Claims_Details C5
             INNER JOIN
        (
            SELECT DISTINCT 
                   VALUE_CODE
            FROM lst.LIST_HEDIS_CODE L5
            WHERE L5.VALUE_SET_NAME IN(@param2, @param3, @param4)
            AND L5.ACTIVE = 'Y'
            AND VALUE_CODE_SYSTEM IN('NDC')
        ) L55 ON L55.VALUE_CODE = C5.NDC_CODE
        UNION
        SELECT DISTINCT 
               C6.SEQ_CLAIM_ID--,L5.VALUE_SET_NAME
        FROM Claims_Details C6
             INNER JOIN
        (
            SELECT DISTINCT 
                   VALUE_CODE
            FROM lst.LIST_HEDIS_CODE L6
            WHERE L6.VALUE_SET_NAME IN(@param2, @param3, @param4)
            AND L6.ACTIVE = 'Y'
            AND L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT')
        ) L66 ON L66.VALUE_CODE = C6.PROCEDURE_CODE
    ) AS D ON D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID
    WHERE CONVERT(DATETIME, B1.PRIMARY_SVC_DATE) >= @claim_date_start
          AND CONVERT(DATETIME, B1.PRIMARY_SVC_DATE) <= @claim_date_end
);
