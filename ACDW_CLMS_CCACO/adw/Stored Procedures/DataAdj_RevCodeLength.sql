CREATE PROCEDURE [adw].[DataAdj_RevCodeLength]
AS
    ALTER TABLE adw.Claims_details DISABLE TRIGGER [ClaimsDetails_AfterUpdate];
    UPDATE adw.Claims_Details
    SET REVENUE_CODE = TRY_CONVERT( INT, REVENUE_CODE)
    ;
    ALTER TABLE adw.Claims_details ENABLE TRIGGER [ClaimsDetails_AfterUpdate];
