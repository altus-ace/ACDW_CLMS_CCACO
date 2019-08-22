CREATE PROCEDURE [dbo].[z_sp_Drop_Create_Load_tmp_AHR_HL7_Report_Detail_Dx_OLD]
AS
    BEGIN
        SET NOCOUNT ON;
        IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_Dx]', 'U') IS NOT NULL
            DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx];
        CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
        ([ID]                 [INT] IDENTITY(2000, 1) NOT NULL, 
         [SUBSCRIBER_ID]      [VARCHAR](50) NULL, 
         [ICD10_Code]         [VARCHAR](11) NULL, 
         [DESC]               [VARCHAR](MAX) NULL, 
         [HCC]                [VARCHAR](3) NULL, 
         [HCC_Description]    [VARCHAR](MAX) NULL, 
         [WEIGHT]             [DECIMAL](4, 3) NULL, 
         [SVC_PROV_FULL_NAME] [VARCHAR](250) NULL, 
         [SVC_PROV_NPI]       [VARCHAR](11) NULL, 
         [SVC_DATE]           [DATE] NULL, 
         [LOADDATE]           [DATE] NULL, 
         [LOADEDBY]           [VARCHAR](50) NULL
        );
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
        ADD DEFAULT(SYSDATETIME()) FOR [LOADDATE];
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
        ADD DEFAULT(SUSER_SNAME()) FOR [LOADEDBY];
        DECLARE @DateStart DATETIME= YEAR(GETDATE()) - 1; --last year
        DECLARE @DateEnd DATETIME= YEAR(GETDATE()); --current year
        DECLARE @ExclDate DATETIME= YEAR(GETDATE()) - 2; --2 years ago

        SELECT a.SUBSCRIBER_ID, 
               diagCode, 
               replace(diagCode, '.', '') [Dx_No_Dec]
        INTO #gaps
        FROM adw.Claims_Diags a
             JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
        WHERE YEAR(b.PRIMARY_SVC_DATE) = @DateStart
        EXCEPT
        SELECT a.SUBSCRIBER_ID, 
               diagCode, 
               replace(diagCode, '.', '') [Dx_No_Dec]
        FROM adw.Claims_Diags a
             JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
        WHERE YEAR(b.PRIMARY_SVC_DATE) = @DateEnd;
        INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
        ([SUBSCRIBER_ID], 
         [ICD10_Code], 
         [DESC], 
         [HCC], 
         [HCC_Description], 
         [WEIGHT], 
         [SVC_PROV_FULL_NAME], 
         [SVC_PROV_NPI], 
         [SVC_DATE]
        )
               SELECT DISTINCT 
                      ch.[SUBSCRIBER_ID]
                      ,
                      --,[Primary_SVC_DATE] 
                      t.[diagCode] [DxCODE]
                      ,
                      --,c.CODE 
                      hc.VALUE_CODE_NAME, 
                      h.HCC_No, 
                      h.[HCC_Description], 
                      0.000 [Weight], 
                      '' [SVC_PROV_FULL_NAME]
                      , --n.FIRSTNAME + ' ' + n.LASTNAME  
                      n.NPI [SVC_PROV_NPI]
                      , --n.NPI  
                      MAX(PRIMARY_SVC_DATE) OVER(PARTITION BY c.CODE) PRIMARY_SVC_DATE --t.[diagCode])[Primary_SVC_DATE]
               FROM adw.Claims_Headers ch
                    INNER JOIN #gaps t ON t.SUBSCRIBER_ID = ch.SUBSCRIBER_ID
                                          AND t.Dx_No_Dec = ch.[ICD_PRIM_DIAG]
                    JOIN lst.LIST_HEDIS_CODE hc ON hc.VALUE_CODE = t.[diagCode]
                    JOIN lst.LIST_DX_CODES c ON c.CODE = replace(t.[diagCode], '.', '')
                    LEFT JOIN lst.LIST_HCC_CODES h ON h.HCC_ID = c.HCC_ID
                    JOIN lst.LIST_NPPES n ON n.NPI = ch.SVC_PROV_NPI
               WHERE n.EntityType = 1
                     AND YEAR(PRIMARY_SVC_DATE) > @ExclDate --and ch.SUBSCRIBER_ID = '{9450649116'
               GROUP BY PRIMARY_SVC_DATE, 
                        ch.[SUBSCRIBER_ID], 
                        ch.ICD_PRIM_DIAG, 
                        [SVC_PROV_FULL_NAME], 
                        hc.VALUE_CODE_NAME, 
                        h.HCC_No, 
                        h.[HCC_Description], 
                        ch.[SVC_PROV_NPI], 
                        FIRSTNAME, 
                        LASTNAME, 
                        NPI, 
                        c.CODE, 
                        t.[diagCode]
               ORDER BY ch.[SUBSCRIBER_ID];--, ch.[PRIMARY_SVC_DATE]

    END;
