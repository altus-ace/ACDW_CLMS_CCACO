

CREATE VIEW [adw].[vw_AllMbrDetail_MissingCodes2]
AS
     SELECT a.SUBSCRIBER_ID, 
            a.diagCode AS DXCODE, 
            b.[ICD10_DESCRIPTION] AS DESCRIPTION, 
            b.HCCV22
     FROM
     (
         SELECT a.SUBSCRIBER_ID, 
                diagCode--, b.PRIMARY_SVC_DATE 
         FROM adw.Claims_Diags a
              JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
         WHERE YEAR(b.PRIMARY_SVC_DATE) = YEAR(GETDATE()) - 1
         EXCEPT
         SELECT a.SUBSCRIBER_ID, 
                diagCode--, b.PRIMARY_SVC_DATE 
         FROM adw.Claims_Diags a
              JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
         WHERE YEAR(b.PRIMARY_SVC_DATE) = YEAR(GETDATE())
     ) a
     LEFT JOIN
     (
         SELECT b.[ICD10], 
                b.[ICD10_DESCRIPTION], 
                b.HCCV22
         FROM lst.LIST_ICDCwHCC b
         WHERE b.PY = YEAR(GETDATE())
     ) AS b ON replace(a.diagCode, '.', '') = b.[ICD10];
