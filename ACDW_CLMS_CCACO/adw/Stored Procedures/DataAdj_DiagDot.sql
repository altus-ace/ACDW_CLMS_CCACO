CREATE PROCEDURE [adw].[DataAdj_DiagDot]
AS 
    ALTER TABLE adw.Claims_Diags DISABLE TRIGGER [ClaimsDiags_AfterUpdate];
    UPDATE adw.Claims_Diags
        SET diagCode = h.VALUE_CODE
    FROM adw.Claims_Diags d
        JOIN (SELECT VALUE_CODE, REPLACE(VALUE_CODE, '.', '') noDot
			 FROM lst.LIST_HEDIS_CODE lh
			 WHERE lh.VALUE_CODE_SYSTEM IN('ICD9CM', 'ICD10CM')
			 ) h ON d.diagCode = h.noDot;
    ALTER TABLE adw.Claims_Diags ENABLE TRIGGER [ClaimsDiags_AfterUpdate];
