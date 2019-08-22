CREATE TABLE [lst].[lstChronicConditionIndicator] (
    [lstCciKey]        INT            IDENTITY (1, 1) NOT NULL,
    [Icd10CmCode]      VARCHAR (15)   NULL,
    [Icd10CmDesc]      VARCHAR (1000) NULL,
    [ChronicIndicator] TINYINT        NULL,
    [BodySystem]       VARCHAR (10)   NULL,
    [EffectiveDate]    DATE           CONSTRAINT [DF_lstCCI_EffDate] DEFAULT ('01/01/1980') NOT NULL,
    [TerminationDate]  DATE           CONSTRAINT [DF_lstCCI_TermDate] DEFAULT ('12/31/2099') NOT NULL,
    [srcFileName]      VARCHAR (100)  NOT NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_lstCCI_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (50)   CONSTRAINT [DF_lstCCI_CreatedBY] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstCciKey] ASC),
    CONSTRAINT [CK_lstCCI_ChronicInd] CHECK ([ChronicIndicator]=(1) OR [ChronicIndicator]=(0))
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SKey', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstChronicConditionIndicator', @level2type = N'COLUMN', @level2name = N'lstCciKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ICD Code', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstChronicConditionIndicator', @level2type = N'COLUMN', @level2name = N'Icd10CmCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ICD Desc', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstChronicConditionIndicator', @level2type = N'COLUMN', @level2name = N'Icd10CmDesc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Is chronic', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstChronicConditionIndicator', @level2type = N'COLUMN', @level2name = N'ChronicIndicator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'I', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstChronicConditionIndicator', @level2type = N'COLUMN', @level2name = N'EffectiveDate';

