CREATE TABLE [adi].[CCLF2] (
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




GO
CREATE NONCLUSTERED INDEX [_dta_index_CCLF2_15_1430296155__K23_K2_K3_K24_1]
    ON [adi].[CCLF2]([FileDate] ASC, [CUR_CLM_UNIQ_ID] ASC, [CLM_LINE_NUM] ASC, [originalFileName] ASC)
    INCLUDE([URN]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_CCLF2_15_1430296155__K2_K3_K23_K24_1]
    ON [adi].[CCLF2]([CUR_CLM_UNIQ_ID] ASC, [CLM_LINE_NUM] ASC, [FileDate] ASC, [originalFileName] ASC)
    INCLUDE([URN]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_CCLF2_15_1430296155__K12_K11_K13_K14_K1_K2_K3_6_7_8_15_16_17_18_19_20]
    ON [adi].[CCLF2]([PRVDR_OSCAR_NUM] ASC, [BENE_EQTBL_BIC_HICN_NUM] ASC, [CLM_FROM_DT] ASC, [CLM_THRU_DT] ASC, [URN] ASC, [CUR_CLM_UNIQ_ID] ASC, [CLM_LINE_NUM] ASC)
    INCLUDE([CLM_LINE_FROM_DT], [CLM_LINE_THRU_DT], [CLM_LINE_PROD_REV_CTR_CD], [CLM_LINE_SRVC_UNIT_QTY], [CLM_LINE_CVRD_PD_AMT], [HCPCS_1_MDFR_CD], [HCPCS_2_MDFR_CD], [HCPCS_3_MDFR_CD], [HCPCS_4_MDFR_CD]);


GO
CREATE STATISTICS [_dta_stat_1430296155_2_23]
    ON [adi].[CCLF2]([CUR_CLM_UNIQ_ID], [FileDate]);


GO
CREATE STATISTICS [_dta_stat_1430296155_2_12_11_13_14_1_3]
    ON [adi].[CCLF2]([CUR_CLM_UNIQ_ID], [PRVDR_OSCAR_NUM], [BENE_EQTBL_BIC_HICN_NUM], [CLM_FROM_DT], [CLM_THRU_DT], [URN], [CLM_LINE_NUM]);


GO
CREATE STATISTICS [_dta_stat_1430296155_1_23]
    ON [adi].[CCLF2]([URN], [FileDate]);


GO
CREATE STATISTICS [_dta_stat_1430296155_1_2_3_23_24]
    ON [adi].[CCLF2]([URN], [CUR_CLM_UNIQ_ID], [CLM_LINE_NUM], [FileDate], [originalFileName]);

