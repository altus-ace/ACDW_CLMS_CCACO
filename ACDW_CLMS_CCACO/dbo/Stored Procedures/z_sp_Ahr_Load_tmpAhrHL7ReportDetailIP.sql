
CREATE PROCEDURE [dbo].[z_sp_Ahr_Load_tmpAhrHL7ReportDetailIP]
AS
    BEGIN
        SET NOCOUNT ON;
        IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_IP]', 'U') IS NOT NULL
            DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP];
        CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP]
        ([IP_ID]            [INT] IDENTITY(4000, 1) NOT NULL, 
         [SUBSCRIBER_ID]    [VARCHAR](50) NULL, 
         [ADMIT_DATE]       [DATE] NULL, 
         [DISC_DATE]        [DATE] NULL, 
         [LOS]              [INT] NULL, 
         [DISC_DISPOSITION] [VARCHAR](25) NULL, 
         [PRIMARY_DX]       [VARCHAR](11) NULL, 
         [DESC]             [VARCHAR](MAX) NULL, 
         [SECONDARY_DX]     [VARCHAR](11) NULL, 
         [SECONDARY_DESC]   [VARCHAR](MAX) NULL, 
         [LOCATION]         [VARCHAR](250) NULL, 
         [LOADDATE]         [DATE] NULL, 
         [LOADEDBY]         [VARCHAR](250) NULL
        );
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP]
        ADD DEFAULT(SYSDATETIME()) FOR [LOADDATE];
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP]
        ADD DEFAULT(SUSER_SNAME()) FOR [LOADEDBY];
        DECLARE @BeginDate [DATE]=
        (
            SELECT CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)
        );
        DECLARE @EndDate [DATE]=
        (
            SELECT CONVERT(DATE, GETDATE())
        );
        INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_IP]
        ([SUBSCRIBER_ID], 
         [ADMIT_DATE], 
         [DISC_DATE], 
         [LOS], 
         [DISC_DISPOSITION], 
         [PRIMARY_DX], 
         [DESC], 
         [SECONDARY_DX], 
         [SECONDARY_DESC], 
         [LOCATION]
        )
               SELECT DISTINCT --a.*,
                      a.SUBSCRIBER_ID, 
                      a.ADMISSION_DATE, 
                      a.SVC_TO_DATE, 
                      DATEDIFF(DAY, a.ADMISSION_DATE, a.SVC_TO_DATE) [LOS], 
                      '', 
                      '', 
                      '', 
                      '', 
                      '', 
                      n.LBN_Name
               --,b.VENDOR_ID  
               FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', @BeginDate, @EndDate) a
                    JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                    JOIN dbo.vw_tmp_AHR_Population c ON b.SUBSCRIBER_ID = c.HICN
                    LEFT JOIN lst.[LIST_NPPES] n ON n.NPI = b.VENDOR_ID;
    END;

