﻿CREATE TABLE [adi].[ACO_CCLF5] (
    [URN]                     INT             IDENTITY (1, 1) NOT NULL,
    [CUR_CLM_UNIQ_ID]         NUMERIC (26)    NULL,
    [CLM_LINE_NUM]            INT             NULL,
    [BENE_HIC_NUM]            VARCHAR (11)    NULL,
    [CLM_TYPE_CD]             SMALLINT        NULL,
    [CLM_FROM_DT]             DATE            NULL,
    [CLM_THRU_DT]             DATE            NULL,
    [RNDRG_PRVDR_TYPE_CD]     VARCHAR (3)     NULL,
    [RNDRG_PRVDR_FIPS_ST_CD]  CHAR (2)        NULL,
    [CLM_PRVDR_SPCLTY_CD]     CHAR (2)        NULL,
    [CLM_FED_TYPE_SRVC_CD]    CHAR (1)        NULL,
    [CLM_POS_CD]              CHAR (2)        NULL,
    [CLM_LINE_FROM_DT]        DATE            NULL,
    [CLM_LINE_THRU_DT]        DATE            NULL,
    [CLM_LINE_HCPCS_CD]       VARCHAR (5)     NULL,
    [CLM_LINE_CVRD_PD_AMT]    VARCHAR (15)    NULL,
    [CLM_LINE_PRMRY_PYR_CD]   CHAR (1)        NULL,
    [CLM_LINE_DGNS_CD]        VARCHAR (7)     NULL,
    [RNDRG_PRVDR_NPI_NUM]     VARCHAR (10)    NULL,
    [CLM_CARR_PMT_DNL_CD]     CHAR (2)        NULL,
    [CLM_PRCSG_IND_CD]        CHAR (2)        NULL,
    [CLM_ADJSMT_TYPE_CD]      CHAR (2)        NULL,
    [CLM_EFCTV_DT]            DATE            NULL,
    [CLM_IDR_LD_DT]           DATE            NULL,
    [CLM_CNTL_NUM]            VARCHAR (40)    NULL,
    [BENE_EQTBL_BIC_HICN_NUM] VARCHAR (11)    NULL,
    [CLM_LINE_ALOWD_CHRG_AMT] VARCHAR (17)    NULL,
    [CLM_LINE_SRVC_UNIT_QTY]  NUMERIC (18, 3) NULL,
    [HCPCS_1_MDFR_CD]         CHAR (2)        NULL,
    [HCPCS_2_MDFR_CD]         CHAR (2)        NULL,
    [HCPCS_3_MDFR_CD]         CHAR (2)        NULL,
    [HCPCS_4_MDFR_CD]         CHAR (2)        NULL,
    [HCPCS_5_MDFR_CD]         CHAR (2)        NULL,
    [CLM_DISP_CD]             CHAR (2)        NULL,
    [CLM_DGNS_1_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_2_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_3_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_4_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_5_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_6_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_7_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_8_CD]           VARCHAR (7)     NULL,
    [DGNS_PRCDR_ICD_IND]      CHAR (1)        NULL,
    [SrcFileName]             VARCHAR (100)   NULL,
    [FileDate]                DATE            NULL,
    [OriginalFileName]        VARCHAR (100)   NULL,
    [CreateDate]              DATETIME        NULL,
    [CreateBy]                VARCHAR (100)   NULL,
    [BENE_MBI_ID]             VARCHAR (11)    NULL,
    [CLM_DGNS_9_CD]           VARCHAR (7)     NULL,
    [CLM_DGNS_10_CD]          VARCHAR (7)     NULL,
    [CLM_DGNS_11_CD]          VARCHAR (7)     NULL,
    [CLM_DGNS_12_CD]          VARCHAR (7)     NULL,
    [HCPCS_BETOS_CD]          VARCHAR (3)     NULL,
    [CLM_RNDRG_PRVDR_TAX_NUM] VARCHAR (10)    NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

