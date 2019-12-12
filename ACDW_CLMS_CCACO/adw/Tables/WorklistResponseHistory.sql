CREATE TABLE [adw].[WorklistResponseHistory] (
    [WorklistResponseKey]  INT           IDENTITY (1, 1) NOT NULL,
    [WorklistBatchKey]     INT           NOT NULL,
    [worklstResponseBatch] INT           NOT NULL,
    [ServiceRepKey]        INT           NULL,
    [ClientMemberKey]      VARCHAR (50)  NOT NULL,
    [ClientKey]            INT           NOT NULL,
    [OutreachOutcomeKey]   INT           NULL,
    [CallActionKey]        INT           NULL,
    [ActionDate]           DATE          NULL,
    [adiKey]               INT           NOT NULL,
    [adiTableName]         VARCHAR (255) NULL,
    [LoadDate]             DATE          CONSTRAINT [DF_WorklistResHis_New_LoadDate] DEFAULT (getdate()) NULL,
    [DataDate]             DATE          CONSTRAINT [DF_WorklistResHis_New_DataDate] DEFAULT (getdate()) NULL,
    [CreatedDate]          DATETIME      CONSTRAINT [DF_WorklistResHis_New_CreatedDate] DEFAULT (getdate()) NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_WorklistResHis_New_CreatedBy] DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]      DATETIME      CONSTRAINT [DF_WorklistResHis_New_LastUpdatedDate] DEFAULT (getdate()) NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_WorklistResHis_New_LastUpdatedBy] DEFAULT (suser_sname()) NULL,
    CONSTRAINT [PK_WorklistResponseKey] PRIMARY KEY CLUSTERED ([WorklistResponseKey] ASC),
    CONSTRAINT [FK_adwWorkListBatch_WorklistBatchKey] FOREIGN KEY ([WorklistBatchKey]) REFERENCES [adw].[WorklistBatch] ([WorklistBatchKey]),
    CONSTRAINT [FK_adwWorkListResBatch_WorklistResBatchKey] FOREIGN KEY ([worklstResponseBatch]) REFERENCES [adw].[WorklistResponseBatch] ([WorklistResponseBatchKey]),
    CONSTRAINT [FK_lstOutreachAction_CallActionKey] FOREIGN KEY ([CallActionKey]) REFERENCES [lst].[lstOutreachAction] ([OutReachActionKey]),
    CONSTRAINT [FK_lstOutreachOutcome_OutreachOutcomeKey] FOREIGN KEY ([OutreachOutcomeKey]) REFERENCES [lst].[lstOutreachOutcome] ([OutreachOutcomeKey]),
    CONSTRAINT [FK_LstServiceRep_ServiceRepKey] FOREIGN KEY ([ServiceRepKey]) REFERENCES [lst].[lstServiceReps] ([ServiceRepKey])
);


GO


CREATE TRIGGER adw.TR_WorklistResponseHistory_AU
    ON [adw].WorklistResponseHistory
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE worklistHistory
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, WorklistResponseHistory a
		  WHERE i.WorklistResponseKey = a.WorklistResponseKey;	   
    END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fkey to list_CLient', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'WorklistResponseHistory', @level2type = N'COLUMN', @level2name = N'ClientKey';

