﻿CREATE TABLE [adi].[ACO_CCLF2] (
    [URN]                        INT             IDENTITY (1, 1) NOT NULL,
    [CUR_CLM_UNIQ_ID]            NUMERIC (26)    NULL,
    [CLM_LINE_NUM]               INT             NULL,
    [BENE_HIC_NUM]               VARCHAR (22)    NULL,
    [CLM_TYPE_CD]                SMALLINT        NULL,
    [CLM_LINE_FROM_DT]           DATE            NULL,
    [CLM_LINE_THRU_DT]           DATE            NULL,
    [CLM_LINE_PROD_REV_CTR_CD]   VARCHAR (4)     NULL,
    [CLM_LINE_INSTNL_REV_CTR_DT] DATE            NULL,
    [CLM_LINE_HCPCS_CD]          VARCHAR (5)     NULL,
    [BENE_EQTBL_BIC_HICN_NUM]    VARCHAR (11)    NULL,
    [PRVDR_OSCAR_NUM]            VARCHAR (6)     NULL,
    [CLM_FROM_DT]                DATE            NULL,
    [CLM_THRU_DT]                DATE            NULL,
    [CLM_LINE_SRVC_UNIT_QTY]     NUMERIC (18, 3) NULL,
    [CLM_LINE_CVRD_PD_AMT]       MONEY           NULL,
    [HCPCS_1_MDFR_CD]            CHAR (2)        NULL,
    [HCPCS_2_MDFR_CD]            CHAR (2)        NULL,
    [HCPCS_3_MDFR_CD]            CHAR (2)        NULL,
    [HCPCS_4_MDFR_CD]            CHAR (2)        NULL,
    [HCPCS_5_MDFR_CD]            CHAR (2)        NULL,
    [SrcFileName]                VARCHAR (100)   NULL,
    [FileDate]                   DATE            NULL,
    [originalFileName]           VARCHAR (100)   NULL,
    [CreateDate]                 DATETIME        NULL,
    [CreateBy]                   VARCHAR (100)   NULL,
    [BENE_MBI_ID]                VARCHAR (11)    NULL,
    [CLM_REV_APC_HIPPS_CD]       VARCHAR (5)     NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);



