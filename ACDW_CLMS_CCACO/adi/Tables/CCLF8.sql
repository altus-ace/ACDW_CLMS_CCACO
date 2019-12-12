﻿CREATE TABLE [adi].[CCLF8] (
    [adiCCLF8_SKey]             INT           IDENTITY (1, 1) NOT NULL,
    [BENE_HIC_NUM]              VARCHAR (22)  NOT NULL,
    [BENE_FIPS_STATE_CD]        SMALLINT      NULL,
    [BENE_FIPS_CNTY_CD]         SMALLINT      NULL,
    [BENE_ZIP_CD]               VARCHAR (11)  NULL,
    [BENE_DOB]                  DATE          NULL,
    [BENE_SEX_CD]               CHAR (2)      NULL,
    [BENE_RACE_CD]              CHAR (2)      NULL,
    [BENE_AGE]                  SMALLINT      NULL,
    [BENE_MDCR_STUS_CD]         VARCHAR (5)   NULL,
    [BENE_DUAL_STUS_CD]         VARCHAR (5)   NULL,
    [BENE_DEATH_DT]             DATE          NULL,
    [BENE_RNG_BGN_DT]           DATE          NULL,
    [BENE_RNG_END_DT]           DATE          NULL,
    [BENE_1ST_NAME]             VARCHAR (65)  NULL,
    [BENE_LAST_NAME]            VARCHAR (65)  NULL,
    [BENE_MIDL_NAME]            VARCHAR (65)  NULL,
    [BENE_ORGNL_ENTLMT_RSN_CD]  SMALLINT      NULL,
    [BENE_ENTLMT_BUYIN_IND]     VARCHAR (5)   NULL,
    [SrcFileName]               VARCHAR (100) NULL,
    [FileDate]                  DATE          NULL,
    [OriginalFileName]          VARCHAR (100) NULL,
    [CreateDate]                DATETIME      CONSTRAINT [DF_adiCCLF8_CreateDate] DEFAULT (getdate()) NULL,
    [CreateBy]                  VARCHAR (100) CONSTRAINT [DF_adiCCLF8_CreateBy] DEFAULT (suser_sname()) NULL,
    [AstCreatedDate]            DATETIME      NULL,
    [AstCreatedBy]              VARCHAR (100) NULL,
    [BENE_MBI_ID]               VARCHAR (11)  NULL,
    [BENE_PART_A_ENRLMT_BGN_DT] DATE          NULL,
    [BENE_PART_B_ENRLMT_BGN_DT] DATE          NULL,
    [BENE_LINE_1_ADR]           VARCHAR (45)  NULL,
    [BENE_LINE_2_ADR]           VARCHAR (45)  NULL,
    [BENE_LINE_3_ADR]           VARCHAR (40)  NULL,
    [BENE_LINE_4_ADR]           VARCHAR (40)  NULL,
    [BENE_LINE_5_ADR]           VARCHAR (40)  NULL,
    [BENE_LINE_6_ADR]           VARCHAR (40)  NULL,
    [GEO_ZIP_PLC_NAME]          VARCHAR (100) NULL,
    [GEO_USPS_STATE_CD]         VARCHAR (2)   NULL,
    [GEO_ZIP5_CD]               VARCHAR (5)   NULL,
    [GEO_ZIP4_CD]               VARCHAR (4)   NULL,
    PRIMARY KEY CLUSTERED ([adiCCLF8_SKey] ASC)
);




GO
CREATE STATISTICS [_dta_stat_875202218_2_21]
    ON [adi].[CCLF8]([BENE_HIC_NUM], [FileDate]);


GO
CREATE STATISTICS [_dta_stat_875202218_1_2_21]
    ON [adi].[CCLF8]([adiCCLF8_SKey], [BENE_HIC_NUM], [FileDate]);

