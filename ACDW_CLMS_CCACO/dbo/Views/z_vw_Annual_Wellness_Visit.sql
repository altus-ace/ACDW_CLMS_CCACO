
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW dbo.z_vw_Annual_Wellness_Visit
AS
     SELECT a.*
     FROM
     (
         SELECT *
         FROM adw.Claims_Member
         WHERE IsActiveMember = 1
     ) a
     JOIN
     (
         SELECT DISTINCT 
                [HICN], 
                CM_Flg, 
                MBR_TYPE
         FROM dbo.z_Active_Members
     ) b ON a.SUBSCRIBER_ID = b.HICN
     JOIN
     (
         SELECT DISTINCT 
                B1.SUBSCRIBER_ID
         FROM adw.Claims_Headers B1
              INNER JOIN
         (
             SELECT DISTINCT 
                    C3.SEQ_CLAIM_ID--,L3.VALUE_SET_NAME
             FROM adw.Claims_Diags C3
                  INNER JOIN
             (
                 SELECT DISTINCT 
                        VALUE_CODE
                 FROM lst.LIST_HEDIS_CODE L3
                 WHERE L3.VALUE_SET_NAME IN('Well-Care')
                 AND L3.ACTIVE = 'Y'
                 AND VALUE_CODE_SYSTEM IN('ICD9CM', 'ICD10CM')
             ) L33 ON L33.VALUE_CODE = C3.diagCode
         ) AS D ON D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID
         WHERE PRIMARY_SVC_DATE BETWEEN '01/01/2018' AND '12/31/2018'
         UNION
         (
             SELECT DISTINCT 
                    C6.SEQ_CLAIM_ID
             FROM adw.Claims_Details C6
                  INNER JOIN
             (
                 SELECT DISTINCT 
                        VALUE_CODE
                 FROM lst.LIST_HEDIS_CODE L6
                 WHERE L6.VALUE_SET_NAME IN('Well-Care')
                 AND L6.ACTIVE = 'Y'
                 AND L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT')
             ) L66 ON L66.VALUE_CODE = C6.PROCEDURE_CODE
             WHERE c6.DETAIL_SVC_DATE BETWEEN '01/01/2018' AND '12/31/2018'
         )
     ) z ON z.SUBSCRIBER_ID = a.SUBSCRIBER_ID;
