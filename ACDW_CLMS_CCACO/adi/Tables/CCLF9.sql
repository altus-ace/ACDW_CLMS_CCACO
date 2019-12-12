CREATE TABLE [adi].[CCLF9] (
    [URN]                INT           IDENTITY (1, 1) NOT NULL,
    [CRNT_HIC_NUM]       VARCHAR (11)  NOT NULL,
    [PRVS_HIC_NUM]       VARCHAR (11)  NOT NULL,
    [PRVS_HICN_EFCTV_DT] DATE          NULL,
    [PRVS_HICN_OBSLT_DT] DATE          NULL,
    [BENE_RRB_NUM]       VARCHAR (12)  NULL,
    [SrcFileName]        VARCHAR (100) NULL,
    [FileDate]           DATE          NULL,
    [originalFileName]   VARCHAR (100) NULL,
    [CreateDate]         DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]           VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [HICN_MBI_XREF_IND]  VARCHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);




GO
CREATE STATISTICS [_dta_stat_336056283_2_3]
    ON [adi].[CCLF9]([CRNT_HIC_NUM], [PRVS_HIC_NUM]);


GO
CREATE STATISTICS [_dta_stat_336056283_10_3_2]
    ON [adi].[CCLF9]([CreateDate], [PRVS_HIC_NUM], [CRNT_HIC_NUM]);


GO
CREATE STATISTICS [_dta_stat_336056283_10_2]
    ON [adi].[CCLF9]([CreateDate], [CRNT_HIC_NUM]);

