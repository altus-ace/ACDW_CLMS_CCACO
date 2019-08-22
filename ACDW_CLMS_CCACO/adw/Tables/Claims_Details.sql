CREATE TABLE [adw].[Claims_Details] (
    [URN]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [CLAIM_NUMBER]                 VARCHAR (50)    NULL,
    [SEQ_CLAIM_ID]                 VARCHAR (50)    NULL,
    [LINE_NUMBER]                  SMALLINT        NULL,
    [SUB_LINE_CODE]                VARCHAR (50)    NULL,
    [DETAIL_SVC_DATE]              DATE            NULL,
    [SVC_TO_DATE]                  DATE            NULL,
    [PROCEDURE_CODE]               VARCHAR (50)    NULL,
    [MODIFIER_CODE_1]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_2]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_3]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_4]              VARCHAR (20)    NULL,
    [REVENUE_CODE]                 SMALLINT        NULL,
    [PLACE_OF_SVC_CODE1]           VARCHAR (10)    NULL,
    [PLACE_OF_SVC_CODE2]           VARCHAR (10)    NULL,
    [PLACE_OF_SVC_CODE3]           VARCHAR (10)    NULL,
    [QUANTITY]                     NUMERIC (12, 2) NULL,
    [BILLED_AMT]                   MONEY           NULL,
    [PAID_AMT]                     MONEY           NULL,
    [NDC_CODE]                     VARCHAR (20)    NULL,
    [RX_GENERIC_BRAND_IND]         VARCHAR (50)    NULL,
    [RX_SUPPLY_DAYS]               VARCHAR (50)    NULL,
    [RX_DISPENSING_FEE_AMT]        MONEY           NULL,
    [RX_INGREDIENT_AMT]            MONEY           NULL,
    [RX_FORMULARY_IND]             VARCHAR (50)    NULL,
    [RX_DATE_PRESCRIPTION_WRITTEN] DATE            NULL,
    [BRAND_NAME]                   VARCHAR (50)    NULL,
    [DRUG_STRENGTH_DESC]           VARCHAR (50)    NULL,
    [GPI]                          VARCHAR (50)    NULL,
    [GPI_DESC]                     VARCHAR (50)    NULL,
    [CONTROLLED_DRUG_IND]          VARCHAR (50)    NULL,
    [COMPOUND_CODE]                VARCHAR (50)    NULL,
    [A_CREATED_DATE]               DATETIME        CONSTRAINT [DF_ClaimsDetails_CreatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_CREATED_BY]                 VARCHAR (50)    CONSTRAINT [DF_ClaimsDetails_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [A_LST_UPDATED_DATE]           DATETIME        CONSTRAINT [DF_ClaimsDetails_LastUpdatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_LST_UPDATED_BY]             VARCHAR (50)    CONSTRAINT [DF_ClaimsDetails_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NdxClmDetails_SEQ_CLAIM_ID]
    ON [adw].[Claims_Details]([SEQ_CLAIM_ID] ASC)
    INCLUDE([URN], [CLAIM_NUMBER], [DETAIL_SVC_DATE], [SVC_TO_DATE], [PROCEDURE_CODE], [REVENUE_CODE]);


GO
CREATE NONCLUSTERED INDEX [Ndx_Clms_Details_PlcOfSvc]
    ON [adw].[Claims_Details]([SEQ_CLAIM_ID] ASC)
    INCLUDE([PLACE_OF_SVC_CODE1]);


GO
CREATE NONCLUSTERED INDEX [Ndx_Clms_Dets_ProcCode]
    ON [adw].[Claims_Details]([PROCEDURE_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDets_NdcCode]
    ON [adw].[Claims_Details]([NDC_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDets_ProcedureCode]
    ON [adw].[Claims_Details]([PROCEDURE_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDets_RevCode]
    ON [adw].[Claims_Details]([REVENUE_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_149627626_1_8_13_20]
    ON [adw].[Claims_Details]([URN], [PROCEDURE_CODE], [REVENUE_CODE], [NDC_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_13_20_8]
    ON [adw].[Claims_Details]([REVENUE_CODE], [NDC_CODE], [PROCEDURE_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_13_3_20]
    ON [adw].[Claims_Details]([REVENUE_CODE], [SEQ_CLAIM_ID], [NDC_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_20_1_13]
    ON [adw].[Claims_Details]([NDC_CODE], [URN], [REVENUE_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_20_3_1_8]
    ON [adw].[Claims_Details]([NDC_CODE], [SEQ_CLAIM_ID], [URN], [PROCEDURE_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_20_3_8_13_1]
    ON [adw].[Claims_Details]([NDC_CODE], [SEQ_CLAIM_ID], [PROCEDURE_CODE], [REVENUE_CODE], [URN]);


GO
CREATE STATISTICS [_dta_stat_149627626_3_1_13_20]
    ON [adw].[Claims_Details]([SEQ_CLAIM_ID], [URN], [REVENUE_CODE], [NDC_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_8_3_1_13]
    ON [adw].[Claims_Details]([PROCEDURE_CODE], [SEQ_CLAIM_ID], [URN], [REVENUE_CODE]);


GO
CREATE STATISTICS [_dta_stat_149627626_8_3_13]
    ON [adw].[Claims_Details]([PROCEDURE_CODE], [SEQ_CLAIM_ID], [REVENUE_CODE]);


GO

CREATE TRIGGER adw.ClaimsDetails_AfterUpdate
ON adw.Claims_Details
AFTER UPDATE 
AS
   UPDATE adw.Claims_Details
   SET A_LST_UPDATED_DATE = SYSDATETIME()
	, A_LST_UPDATED_BY = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Details.URN = i.URN;
