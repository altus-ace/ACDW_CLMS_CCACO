CREATE TABLE [adi].[CCLF4] (
    [URN]                     INT           IDENTITY (1, 1) NOT NULL,
    [CUR_CLM_UNIQ_ID]         NUMERIC (26)  NULL,
    [BENE_HIC_NUM]            VARCHAR (22)  NULL,
    [CLM_TYPE_CD]             SMALLINT      NULL,
    [CLM_PROD_TYPE_CD]        CHAR (1)      NULL,
    [CLM_VAL_SQNC_NUM]        SMALLINT      NULL,
    [CLM_DGNS_CD]             VARCHAR (7)   NULL,
    [BENE_EQTBL_BIC_HICN_NUM] VARCHAR (11)  NULL,
    [PRVDR_OSCAR_NUM]         VARCHAR (6)   NULL,
    [CLM_FROM_DT]             DATE          NULL,
    [CLM_THRU_DT]             DATE          NULL,
    [CLM_POA_IND]             VARCHAR (7)   NULL,
    [DGNS_PRCDR_ICD_IND]      CHAR (1)      NULL,
    [SrcFileName]             VARCHAR (100) NULL,
    [FileDate]                DATE          NULL,
    [originalFileName]        VARCHAR (100) NULL,
    [CreateDate]              DATETIME      NULL,
    [CreateBy]                VARCHAR (100) NULL,
    [BENE_MBI_ID]             VARCHAR (11)  NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);




GO
CREATE STATISTICS [_dta_stat_1494296383_2_6_16_15]
    ON [adi].[CCLF4]([CUR_CLM_UNIQ_ID], [CLM_VAL_SQNC_NUM], [originalFileName], [FileDate]);


GO
CREATE STATISTICS [_dta_stat_1494296383_15_2_6_1_16]
    ON [adi].[CCLF4]([FileDate], [CUR_CLM_UNIQ_ID], [CLM_VAL_SQNC_NUM], [URN], [originalFileName]);


GO
CREATE STATISTICS [_dta_stat_1494296383_1_2_6_16]
    ON [adi].[CCLF4]([URN], [CUR_CLM_UNIQ_ID], [CLM_VAL_SQNC_NUM], [originalFileName]);

