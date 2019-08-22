﻿CREATE TABLE [adw].[Claims_Headers] (
    [SEQ_CLAIM_ID]       VARCHAR (50)  NOT NULL,
    [SUBSCRIBER_ID]      VARCHAR (50)  NULL,
    [CLAIM_NUMBER]       VARCHAR (50)  NULL,
    [CATEGORY_OF_SVC]    VARCHAR (50)  NULL,
    [PAT_CONTROL_NO]     VARCHAR (50)  NULL,
    [ICD_PRIM_DIAG]      VARCHAR (10)  NULL,
    [PRIMARY_SVC_DATE]   DATE          NULL,
    [SVC_TO_DATE]        DATE          NULL,
    [CLAIM_THRU_DATE]    DATE          NULL,
    [POST_DATE]          VARCHAR (50)  NULL,
    [CHECK_DATE]         VARCHAR (50)  NULL,
    [CHECK_NUMBER]       VARCHAR (20)  NULL,
    [DATE_RECEIVED]      VARCHAR (50)  NULL,
    [ADJUD_DATE]         VARCHAR (50)  NULL,
    [SVC_PROV_ID]        VARCHAR (20)  NULL,
    [SVC_PROV_FULL_NAME] VARCHAR (250) NULL,
    [SVC_PROV_NPI]       VARCHAR (20)  NULL,
    [PROV_SPEC]          CHAR (2)      NULL,
    [PROV_TYPE]          VARCHAR (20)  NULL,
    [PROVIDER_PAR_STAT]  VARCHAR (20)  NULL,
    [ATT_PROV_ID]        VARCHAR (50)  NULL,
    [ATT_PROV_FULL_NAME] VARCHAR (250) NULL,
    [ATT_PROV_NPI]       VARCHAR (20)  NULL,
    [REF_PROV_ID]        VARCHAR (20)  NULL,
    [REF_PROV_FULL_NAME] VARCHAR (250) NULL,
    [VENDOR_ID]          VARCHAR (20)  NULL,
    [VEND_FULL_NAME]     VARCHAR (250) NULL,
    [IRS_TAX_ID]         VARCHAR (20)  NULL,
    [DRG_CODE]           VARCHAR (20)  NULL,
    [BILL_TYPE]          VARCHAR (20)  NULL,
    [ADMISSION_DATE]     DATE          NULL,
    [AUTH_NUMBER]        VARCHAR (50)  NULL,
    [ADMIT_SOURCE_CODE]  VARCHAR (20)  NULL,
    [ADMIT_HOUR]         VARCHAR (20)  NULL,
    [DISCHARGE_HOUR]     VARCHAR (20)  NULL,
    [PATIENT_STATUS]     VARCHAR (20)  NULL,
    [CLAIM_STATUS]       VARCHAR (20)  NULL,
    [PROCESSING_STATUS]  VARCHAR (20)  NULL,
    [CLAIM_TYPE]         VARCHAR (20)  NULL,
    [TOTAL_BILLED_AMT]   MONEY         NULL,
    [A_CREATED_DATE]     DATETIME      CONSTRAINT [DF_ClaimsHeaders_CreatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_CREATED_BY]       VARCHAR (50)  CONSTRAINT [DF_ClaimsHeaders_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [A_LST_UPDATED_DATE] DATETIME      CONSTRAINT [DF_ClaimsHeaders_LastUpdatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_LST_UPDATED_BY]   VARCHAR (50)  CONSTRAINT [DF_ClaimsHeaders_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Headers_SeqClaimId] PRIMARY KEY CLUSTERED ([SEQ_CLAIM_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_DrgCode]
    ON [adw].[Claims_Headers]([DRG_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_CLmsHdr_PrmrySvcDt]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_SeqClmId]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID] ASC)
    INCLUDE([SUBSCRIBER_ID], [PRIMARY_SVC_DATE], [CLAIM_THRU_DATE], [PROV_SPEC], [ADMISSION_DATE], [CATEGORY_OF_SVC], [SVC_TO_DATE]);


GO
CREATE NONCLUSTERED INDEX [NDX_ClmsHdr_SubID_PrimSvcDt]
    ON [adw].[Claims_Headers]([SUBSCRIBER_ID] ASC, [PRIMARY_SVC_DATE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [ADMISSION_DATE]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHdr_SubscriberID]
    ON [adw].[Claims_Headers]([SUBSCRIBER_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsHeader_ProvSpec]
    ON [adw].[Claims_Headers]([PROV_SPEC] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [CATEGORY_OF_SVC], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [CLAIM_THRU_DATE], [ADMISSION_DATE]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Headers_nonclustered__K43]
    ON [adw].[Claims_Headers]([A_LST_UPDATED_DATE] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_adwClaimsHeaders_PRIMARY_SVC_DATE_Includes]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [SVC_PROV_NPI]) WITH (FILLFACTOR = 100);


GO
CREATE STATISTICS [_dta_stat_1465108310_1_29_7]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [DRG_CODE], [PRIMARY_SVC_DATE]);


GO
CREATE STATISTICS [_dta_stat_1465108310_1_2_29_7_31]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [DRG_CODE], [PRIMARY_SVC_DATE], [ADMISSION_DATE]);


GO
CREATE STATISTICS [_dta_stat_1465108310_1_7_31_29]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [ADMISSION_DATE], [DRG_CODE]);


GO
CREATE STATISTICS [_dta_stat_1465108310_1_7_8_29]
    ON [adw].[Claims_Headers]([SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [SVC_TO_DATE], [DRG_CODE]);


GO
CREATE STATISTICS [_dta_stat_1465108310_31_1]
    ON [adw].[Claims_Headers]([ADMISSION_DATE], [SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_1465108310_7_29]
    ON [adw].[Claims_Headers]([PRIMARY_SVC_DATE], [DRG_CODE]);


GO
CREATE STATISTICS [_dta_stat_1465108310_8_1_7_2_29_31]
    ON [adw].[Claims_Headers]([SVC_TO_DATE], [SEQ_CLAIM_ID], [PRIMARY_SVC_DATE], [SUBSCRIBER_ID], [DRG_CODE], [ADMISSION_DATE]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'From CMS Provider specialty List', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Headers', @level2type = N'COLUMN', @level2name = N'PROV_SPEC';
