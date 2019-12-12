CREATE TABLE [adw].[worklistHistory] (
    [worklistHistoryKey] INT           IDENTITY (1, 1) NOT NULL,
    [WorklistBatchKey]   INT           NOT NULL,
    [ClientMemberKey]    VARCHAR (50)  NULL,
    [ClientKey]          INT           NOT NULL,
    [QmMsrID]            VARCHAR (20)  NOT NULL,
    [adiKey]             INT           NULL,
    [adiTableName]       VARCHAR (100) NULL,
    [LoadDate]           DATE          CONSTRAINT [DF_WorklistHistory_New_LoadDate] DEFAULT (getdate()) NULL,
    [DataDate]           DATE          CONSTRAINT [DF_WorklistHistory_New_DataDate] DEFAULT (getdate()) NULL,
    [CreatedDate]        DATETIME      CONSTRAINT [DF_WorklistHistory_New_CreatedDate] DEFAULT (getdate()) NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_WorklistHistory_New_CreatedBy] DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]    DATETIME      CONSTRAINT [DF_WorklistHistory_New_LastUpdatedDate] DEFAULT (getdate()) NULL,
    [LastUpdatedBy]      VARCHAR (50)  CONSTRAINT [DF_WorklistHistory_New_LastUpdatedBy] DEFAULT (suser_sname()) NULL,
    [SourceFileName]     VARCHAR (250) NULL,
    CONSTRAINT [FK_adwWorkListBatchKey_WorklistBatchKey] FOREIGN KEY ([WorklistBatchKey]) REFERENCES [adw].[WorklistBatch] ([WorklistBatchKey])
);

