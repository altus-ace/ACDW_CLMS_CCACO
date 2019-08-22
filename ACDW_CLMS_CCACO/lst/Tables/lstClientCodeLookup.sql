CREATE TABLE [lst].[lstClientCodeLookup] (
    [ClientCodeLookupKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]           INT           NOT NULL,
    [ClientCode]          VARCHAR (20)  NOT NULL,
    [ClientCodeDesc]      VARCHAR (50)  NOT NULL,
    [ClientCodeTypesKey]  INT           NOT NULL,
    [LoadDate]            DATE          CONSTRAINT [DF_lstClientCodeLookup_LoadDate] DEFAULT (getdate()) NOT NULL,
    [CreatedDate]         DATETIME2 (7) CONSTRAINT [DF_LstClientCodeLookup_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_LstClientCodeLookup_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7) CONSTRAINT [DF_LstClientCodeLookup_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)  CONSTRAINT [DF_LstClientCodeLookup_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ClientCodeLookupKey] ASC),
    CONSTRAINT [FK_lstClientCodeLookup_TolstClientCodeTypes] FOREIGN KEY ([ClientCodeTypesKey]) REFERENCES [lst].[lstClientCodesTypes] ([ClientCodesTypeKey])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Skey ', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstClientCodeLookup', @level2type = N'COLUMN', @level2name = N'ClientCodeLookupKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client code value, the look up key', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstClientCodeLookup', @level2type = N'COLUMN', @level2name = N'ClientCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client value, the look up result value', @level0type = N'SCHEMA', @level0name = N'lst', @level1type = N'TABLE', @level1name = N'lstClientCodeLookup', @level2type = N'COLUMN', @level2name = N'ClientCodeDesc';

