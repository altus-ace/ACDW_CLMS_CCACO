CREATE TABLE [adi].[H_CCLF9] (
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
    [BENE_MBI_ID]        VARCHAR (11)  NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

