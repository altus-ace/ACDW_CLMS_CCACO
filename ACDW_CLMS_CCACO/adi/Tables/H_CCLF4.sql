﻿CREATE TABLE [adi].[H_CCLF4] (
    [URN]                     INT           IDENTITY (1, 1) NOT NULL,
    [CUR_CLM_UNIQ_ID]         NUMERIC (26)  NULL,
    [BENE_HIC_NUM]            VARCHAR (22)  NULL,
    [CLM_TYPE_CD]             SMALLINT      NULL,
    [CLM_PROD_TYPE_CD]        VARCHAR (1)   NULL,
    [CLM_VAL_SQNC_NUM]        SMALLINT      NULL,
    [CLM_DGNS_CD]             VARCHAR (7)   NULL,
    [BENE_EQTBL_BIC_HICN_NUM] VARCHAR (11)  NULL,
    [PRVDR_OSCAR_NUM]         VARCHAR (6)   NULL,
    [CLM_FROM_DT]             VARCHAR (10)  NULL,
    [CLM_THRU_DT]             VARCHAR (10)  NULL,
    [CLM_POA_IND]             VARCHAR (7)   NULL,
    [DGNS_PRCDR_ICD_IND]      VARCHAR (1)   NULL,
    [SrcFileName]             VARCHAR (100) NULL,
    [FileDate]                DATE          NULL,
    [CreateDate]              DATETIME      NULL,
    [CreateBy]                VARCHAR (100) NULL,
    [OriginalFileName]        VARCHAR (100) NULL,
    [BENE_MBI_ID]             VARCHAR (11)  NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

