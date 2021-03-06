﻿CREATE TABLE [adi].[CCLF1] (
    [URN]                           INT           IDENTITY (1, 1) NOT NULL,
    [CUR_CLM_UNIQ_ID]               NUMERIC (26)  NULL,
    [PRVDR_OSCAR_NUM]               VARCHAR (6)   NULL,
    [BENE_HIC_NUM]                  VARCHAR (22)  NULL,
    [CLM_TYPE_CD]                   SMALLINT      NULL,
    [CLM_FROM_DT]                   DATE          NULL,
    [CLM_THRU_DT]                   DATE          NULL,
    [CLM_BILL_FAC_TYPE_CD]          CHAR (1)      NULL,
    [CLM_BILL_CLSFCTN_CD]           CHAR (1)      NULL,
    [PRNCPL_DGNS_CD]                VARCHAR (7)   NULL,
    [ADMTG_DGNS_CD]                 VARCHAR (7)   NULL,
    [CLM_MDCR_NPMT_RSN_CD]          CHAR (2)      NULL,
    [CLM_PMT_AMT]                   MONEY         NULL,
    [CLM_NCH_PRMRY_PYR_CD]          CHAR (1)      NULL,
    [PRVDR_FAC_FIPS_ST_CD]          CHAR (2)      NULL,
    [BENE_PTNT_STUS_CD]             CHAR (2)      NULL,
    [DGNS_DRG_CD]                   VARCHAR (4)   NULL,
    [CLM_OP_SRVC_TYPE_CD]           CHAR (1)      NULL,
    [FAC_PRVDR_NPI_NUM]             VARCHAR (10)  NULL,
    [OPRTG_PRVDR_NPI_NUM]           VARCHAR (10)  NULL,
    [ATNDG_PRVDR_NPI_NUM]           VARCHAR (10)  NULL,
    [OTHR_PRVDR_NPI_NUM]            VARCHAR (10)  NULL,
    [CLM_ADJSMT_TYPE_CD]            CHAR (2)      NULL,
    [CLM_EFCTV_DT]                  DATE          NULL,
    [CLM_IDR_LD_DT]                 DATE          NULL,
    [BENE_EQTBL_BIC_HICN_NUM]       VARCHAR (11)  NULL,
    [CLM_ADMSN_TYPE_CD]             CHAR (2)      NULL,
    [CLM_ADMSN_SRC_CD]              CHAR (2)      NULL,
    [CLM_BILL_FREQ_CD]              CHAR (1)      NULL,
    [CLM_QUERY_CD]                  CHAR (1)      NULL,
    [DGNS_PRCDR_ICD_IND]            CHAR (1)      NULL,
    [SrcFileName]                   VARCHAR (100) NULL,
    [FileDate]                      DATE          NULL,
    [originalFileName]              VARCHAR (100) NULL,
    [CreateDate]                    DATETIME      NULL,
    [CreateBy]                      VARCHAR (100) NULL,
    [BENE_MBI_ID]                   VARCHAR (11)  NULL,
    [CLM_MDCR_INSTNL_TOT_CHRG_AMT]  VARCHAR (15)  NULL,
    [CLM_MDCR_IP_PPS_CPTL_IME_AMT]  VARCHAR (15)  NULL,
    [CLM_OPRTNL_IME_AMT]            VARCHAR (22)  NULL,
    [CLM_MDCR_IP_PPS_DSPRPRTNT_AMT] VARCHAR (15)  NULL,
    [CLM_HIPPS_UNCOMPD_CARE_AMT]    VARCHAR (15)  NULL,
    [CLM_OPRTNL_DSPRPRTNT_AMT]      VARCHAR (22)  NULL,
    CONSTRAINT [PK__CCLF1__C5B1000EBA2DC3A2] PRIMARY KEY CLUSTERED ([URN] ASC)
);




GO
CREATE STATISTICS [_dta_stat_1398296041_8_1]
    ON [adi].[CCLF1]([CLM_BILL_FAC_TYPE_CD], [URN]);


GO
CREATE STATISTICS [_dta_stat_1398296041_3_26_6_7_1_24_23]
    ON [adi].[CCLF1]([PRVDR_OSCAR_NUM], [BENE_EQTBL_BIC_HICN_NUM], [CLM_FROM_DT], [CLM_THRU_DT], [URN], [CLM_EFCTV_DT], [CLM_ADJSMT_TYPE_CD]);


GO
CREATE STATISTICS [_dta_stat_1398296041_29_1]
    ON [adi].[CCLF1]([CLM_BILL_FREQ_CD], [URN]);


GO
CREATE STATISTICS [_dta_stat_1398296041_24_23]
    ON [adi].[CCLF1]([CLM_EFCTV_DT], [CLM_ADJSMT_TYPE_CD]);


GO
CREATE STATISTICS [_dta_stat_1398296041_2_34]
    ON [adi].[CCLF1]([CUR_CLM_UNIQ_ID], [originalFileName]);


GO
CREATE STATISTICS [_dta_stat_1398296041_2_33_34]
    ON [adi].[CCLF1]([CUR_CLM_UNIQ_ID], [FileDate], [originalFileName]);


GO
CREATE STATISTICS [_dta_stat_1398296041_1_3_26_6]
    ON [adi].[CCLF1]([URN], [PRVDR_OSCAR_NUM], [BENE_EQTBL_BIC_HICN_NUM], [CLM_FROM_DT]);

