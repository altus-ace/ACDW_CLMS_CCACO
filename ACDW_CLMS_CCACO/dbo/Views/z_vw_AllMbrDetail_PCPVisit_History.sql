CREATE VIEW dbo.z_vw_AllMbrDetail_PCPVisit_History
AS
     SELECT B1.SUBSCRIBER_ID, 
            B1.SEQ_CLAIM_ID, 
            B1.PRIMARY_SVC_DATE, 
            B1.CLAIM_THRU_DATE, 
            B1.PROV_SPEC, 
            B1.ADMISSION_DATE, 
            B1.CATEGORY_OF_SVC, 
            B1.[SVC_TO_DATE], 
            B1.VENDOR_ID, 
            B1.SVC_PROV_NPI, 
     (
         SELECT pcp.PCP_NPI
         FROM lst.LIST_PCP pcp
         WHERE pcp.PCP_NPI = B1.SVC_PROV_NPI
     ) AS ACO_NPI
     FROM adw.Claims_Headers B1
          INNER JOIN
     (
         SELECT DISTINCT 
                C6.SEQ_CLAIM_ID--,L5.VALUE_SET_NAME
         FROM adw.Claims_Details C6
              INNER JOIN
         (
             SELECT DISTINCT 
                    VALUE_CODE
             FROM lst.LIST_HEDIS_CODE L6
             WHERE L6.VALUE_CODE IN('99201', '99202', '99203', '99204', '99205', '99211', '99212', '99213'
							 , '99214', '99215', '99304', '99305', '99306', '99307', '99308', '99309'
							 , '99310', '99315', '99316', '99318', '99324', '99325', '99326', '99327'
							 , '99328', '99334', '99335', '99336', '99337', '99339', '99340', '99341'
							 , '99342', '99343', '99344', '99345', '99347', '99348', '99349', '99350'
							 , 'G0402', 'G0438', 'G0439', 'G0463')
             AND L6.ACTIVE = 'Y'
             AND L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT')
         ) L66 ON L66.VALUE_CODE = C6.PROCEDURE_CODE
     ) AS D ON D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID
     WHERE B1.PRIMARY_SVC_DATE >= '01/01/2010'
           AND B1.PRIMARY_SVC_DATE <= '01/01/2099';
