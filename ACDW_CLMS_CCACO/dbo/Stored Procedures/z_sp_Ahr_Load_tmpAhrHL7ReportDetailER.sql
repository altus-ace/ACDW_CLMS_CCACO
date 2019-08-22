
CREATE PROCEDURE [dbo].[z_sp_Ahr_Load_tmpAhrHL7ReportDetailER]
AS
    BEGIN
        SET NOCOUNT ON;
        IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_ER]', 'U') IS NOT NULL
            DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER];
        CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER]
        ([EP_ID]          [INT] IDENTITY(3000, 1) NOT NULL, 
         [SUBSCRIBER_ID]  [VARCHAR](50) NULL, 
         [DATE]           [DATE] NULL, 
         [PRIMARY_DX]     [VARCHAR](11) NULL, 
         [DESC]           [VARCHAR](MAX) NULL, 
         [SECONDARY_DX]   [VARCHAR](11) NULL, 
         [SECONDARY_DESC] [VARCHAR](MAX) NULL, 
         [LOCATION]       [VARCHAR](250) NULL, 
         [LOADDATE]       [DATE] NULL, 
         [LOADEDBY]       [VARCHAR](250) NULL
        );
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER]
        ADD DEFAULT(SYSDATETIME()) FOR [LOADDATE];
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER]
        ADD DEFAULT(SUSER_SNAME()) FOR [LOADEDBY];
        DECLARE @BeginDate [DATE]=
        (
            SELECT DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0)
        );
        DECLARE @EndDate [DATE]=
        (
            SELECT DATEADD(MILLISECOND, -3, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0))
        );
        INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_ER]
        ([SUBSCRIBER_ID], 
         [DATE], 
         [PRIMARY_DX], 
         [DESC], 
         [SECONDARY_DX], 
         [SECONDARY_DESC], 
         [LOCATION]
        )
               SELECT DISTINCT 
                      a.SUBSCRIBER_ID, 
                      a.PRIMARY_SVC_DATE, 
                      '' [Primary_Dx], 
                      '' [Description], 
                      '' [Secondary_DX], 
                      '' [2_Description], 
                      n.[LBN_Name] + '(' + b.VENDOR_ID + ')'
               FROM
               (
                   SELECT *
                   FROM adw.tvf_get_claims_w_dates('ED', '', '', @BeginDate, @EndDate)
                   WHERE CATEGORY_OF_SVC <> 'PHYSICIAN'
                   UNION
                   (
                       SELECT a.*
                       FROM adw.tvf_get_claims_w_dates('ED POS', '', '', @BeginDate, @EndDate) a
                            JOIN adw.tvf_get_claims_w_dates('ED Procedure Code', '', '', @BeginDate, @EndDate) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                                                                                                    AND a.CATEGORY_OF_SVC <> 'PHYSICIAN'
                   )
               ) a
               JOIN adw.Claims_Headers B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
               JOIN dbo.vw_tmp_AHR_Population c ON b.SUBSCRIBER_ID = c.HICN
               LEFT JOIN lst.LIST_NPPES n ON n.NPI = b.VENDOR_ID;
    END;

