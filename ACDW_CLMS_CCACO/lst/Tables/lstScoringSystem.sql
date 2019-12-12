CREATE TABLE [lst].[lstScoringSystem] (
    [lstScoringSystemKey] INT            IDENTITY (1, 1) NOT NULL,
    [ClientKey]           INT            NOT NULL,
    [LOB]                 VARCHAR (20)   NOT NULL,
    [LOB_State]           VARCHAR (10)   NULL,
    [EffectiveDate]       DATE           NULL,
    [ExpirationDate]      DATE           NULL,
    [Active]              TINYINT        CONSTRAINT [DF_lstListScoringSystem_Active] DEFAULT ((1)) NOT NULL,
    [ScoringType]         VARCHAR (20)   NULL,
    [P4qIndicator]        CHAR (1)       NOT NULL,
    [MeasureID]           VARCHAR (20)   NOT NULL,
    [MeasureDesc]         VARCHAR (500)  NULL,
    [Score_A]             NUMERIC (9, 3) CONSTRAINT [DF_lstScoringSystem_ScrA] DEFAULT ((0)) NULL,
    [Score_B]             NUMERIC (9, 3) CONSTRAINT [DF_lstScoringSystem_ScrB] DEFAULT ((0)) NULL,
    [Score_C]             NUMERIC (9, 3) CONSTRAINT [DF_lstScoringSystem_ScrC] DEFAULT ((0)) NULL,
    [Score_D]             NUMERIC (9, 3) CONSTRAINT [DF_lstScoringSystem_ScrD] DEFAULT ((0)) NULL,
    [Score_E]             NUMERIC (9, 3) CONSTRAINT [DF_lstScoringSystem_ScrE] DEFAULT ((0)) NULL,
    [Weight_1]            INT            CONSTRAINT [DF_lstScoringSystem_weight1] DEFAULT ((1)) NULL,
    [Weight_2]            INT            CONSTRAINT [DF_lstScoringSystem_weight2] DEFAULT ((1)) NULL,
    [Weight_3]            INT            CONSTRAINT [DF_lstScoringSystem_weight3] DEFAULT ((1)) NULL,
    [Weight_4]            INT            CONSTRAINT [DF_lstScoringSystem_weight4] DEFAULT ((1)) NULL,
    [Weight_5]            INT            CONSTRAINT [DF_lstScoringSystem_weight5] DEFAULT ((1)) NULL,
    [AceQmWeight]         INT            CONSTRAINT [DF_lstScoringSystem_AceQmWeight] DEFAULT ((1)) NULL,
    [AceCmWeight]         INT            CONSTRAINT [DF_lstScoringSystem_AceCmWeight] DEFAULT ((1)) NULL,
    [Pq4BaseValue]        MONEY          CONSTRAINT [DF_lstScoringSystem_Pq4BaseValue] DEFAULT ((0)) NULL,
    [CreatedDate]         DATETIME2 (7)  CONSTRAINT [DF_lstLstScoringSystem_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)   CONSTRAINT [DF_lstLstScoringSystem_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7)  CONSTRAINT [DF_lstLstScoringSystem_LastUpdateDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)   CONSTRAINT [DF_lstLstScoringSystem_LastUpdateBy] DEFAULT ('BoomiDbUser') NOT NULL,
    [SrcFileName]         VARCHAR (100)  NULL,
    PRIMARY KEY CLUSTERED ([lstScoringSystemKey] ASC),
    CONSTRAINT [CK_lstListScoringSystem_Active] CHECK ([Active]=(1) OR [Active]=(0)),
    CONSTRAINT [CK_lstScoringSystem] CHECK ([lst].[ValidateLstScoringSystem]([Active],[EffectiveDate],[ExpirationDate],[ClientKey],[LOB],[LOB_State],[ScoringType],[MeasureID],[MeasureDesc])=(1))
);


GO
ALTER TABLE [lst].[lstScoringSystem] NOCHECK CONSTRAINT [CK_lstScoringSystem];


GO
CREATE NONCLUSTERED INDEX [_dta_index_lstScoringSystem_23_1570820658__K5_K3_K10_8_11_12_13_14_15_16_17]
    ON [lst].[lstScoringSystem]([EffectiveDate] ASC, [LOB] ASC, [MeasureID] ASC)
    INCLUDE([ScoringType], [MeasureDesc], [Score_A], [Score_B], [Score_C], [Score_D], [Score_E], [Weight_1]);


GO
CREATE STATISTICS [_dta_stat_1570820658_10_5]
    ON [lst].[lstScoringSystem]([MeasureID], [EffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1570820658_3_10_5]
    ON [lst].[lstScoringSystem]([LOB], [MeasureID], [EffectiveDate]);

