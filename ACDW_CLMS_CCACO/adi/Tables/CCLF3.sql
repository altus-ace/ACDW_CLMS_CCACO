CREATE TABLE [adi].[CCLF3] (
    [URN]                     INT           IDENTITY (1, 1) NOT NULL,
    [CUR_CLM_UNIQ_ID]         NUMERIC (26)  NULL,
    [BENE_HIC_NUM]            VARCHAR (22)  NULL,
    [CLM_TYPE_CD]             SMALLINT      NULL,
    [CLM_VAL_SQNC_NUM]        SMALLINT      NULL,
    [CLM_PRCDR_CD]            VARCHAR (7)   NULL,
    [CLM_PRCDR_PRFRM_DT]      DATE          NULL,
    [BENE_EQTBL_BIC_HICN_NUM] VARCHAR (11)  NULL,
    [PRVDR_OSCAR_NUM]         VARCHAR (6)   NULL,
    [CLM_FROM_DT]             DATE          NULL,
    [CLM_THRU_DT]             DATE          NULL,
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
CREATE STATISTICS [_dta_stat_1462296269_2_5_15]
    ON [adi].[CCLF3]([CUR_CLM_UNIQ_ID], [CLM_VAL_SQNC_NUM], [originalFileName]);


GO
CREATE STATISTICS [_dta_stat_1462296269_2_5_14_15]
    ON [adi].[CCLF3]([CUR_CLM_UNIQ_ID], [CLM_VAL_SQNC_NUM], [FileDate], [originalFileName]);


GO
CREATE STATISTICS [_dta_stat_1462296269_14_2]
    ON [adi].[CCLF3]([FileDate], [CUR_CLM_UNIQ_ID]);

