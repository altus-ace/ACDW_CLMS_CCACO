CREATE PROCEDURE adw.HL7_GetMemberDetails @ID VARCHAR(12)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT ROW_NUMBER() OVER(
               ORDER BY CGQM ASC) + 2000 [Row], 
               CGQM + ' ' + CGQMDESC [Data]
        FROM dbo.tmp_AHR_HL7_Report_Detail_CG
        WHERE SUBSCRIBER_ID = @ID
        UNION
        SELECT ROW_NUMBER() OVER(
               ORDER BY [ICD10_Code] ASC) + 3000 [Row], 
               [ICD10_Code] + ' ' + [DESC] + ' ' + [HCC] + ' ' + Format([WEIGHT], 'N', 'en-US') + ' ' + [SVC_PROV_FULL_NAME] + ' ' + LEFT(CONVERT(VARCHAR, [SVC_DATE], 120), 10)
        FROM dbo.tmp_AHR_HL7_Report_Detail_Dx
        WHERE SUBSCRIBER_ID = @ID
        UNION
        SELECT ROW_NUMBER() OVER(
               ORDER BY [DATE] ASC) + 4000 [Row], 
               LEFT(CONVERT(VARCHAR, [DATE], 120), 10) + ' ' + [PRIMARY_DX] + ' ' + [DESC] + ' ' + [SECONDARY_DX] + ' ' + [SECONDARY_DESC] + ' ' + [LOCATION]
        FROM dbo.tmp_AHR_HL7_Report_Detail_ER
        WHERE SUBSCRIBER_ID = @ID
        UNION
        SELECT ROW_NUMBER() OVER(
               ORDER BY [ADMIT_DATE] ASC) + 5000 [Row], 
               LEFT(CONVERT(VARCHAR, [Admit_DATE], 120), 10) + ' ' + LEFT(CONVERT(VARCHAR, [DISC_DATE], 120), 10) + ' ' + CONVERT(VARCHAR(10), [LOS]) + ' ' + [DISC_DISPOSITION] + ' ' + [PRIMARY_DX] + ' ' + [DESC] + ' ' + [SECONDARY_DX] + ' ' + [SECONDARY_DESC] + ' ' + [LOCATION]
        FROM dbo.tmp_AHR_HL7_Report_Detail_IP
        WHERE SUBSCRIBER_ID = @ID;
    END;
