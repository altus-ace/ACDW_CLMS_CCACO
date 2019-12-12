CREATE TABLE [adw].[WorklistResponseBatch] (
    [WorklistResponseBatchKey] INT          IDENTITY (1, 1) NOT NULL,
    [ResponseBatchDate]        DATE         NOT NULL,
    [workListBatchKey]         INT          NULL,
    [CreatedDate]              DATETIME     CONSTRAINT [DF_WorklistResBatch_CreatedDate] DEFAULT (getdate()) NULL,
    [CreatedBy]                VARCHAR (50) CONSTRAINT [DF_WorklistResBatch_CreatedBy] DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]          DATETIME     CONSTRAINT [DF_WorklistResBatch_LastUpdatedDate] DEFAULT (getdate()) NULL,
    [LastUpdatedBy]            VARCHAR (50) CONSTRAINT [DF_WorklistResBatch_LastUpdatedBy] DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([WorklistResponseBatchKey] ASC),
    CONSTRAINT [FK_adwWorklist_BatchKey] FOREIGN KEY ([workListBatchKey]) REFERENCES [adw].[WorklistBatch] ([WorklistBatchKey])
);


GO


CREATE TRIGGER adw.TR_WorklistResponseBatch_AU
    ON [adw].WorklistResponseBatch
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE WorklistResponseBatch
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, WorklistResponseBatch a
		  WHERE i.WorklistResponseBatchKey = a.WorklistResponseBatchKey;	   
    END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FKey To worklist batch', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'WorklistResponseBatch', @level2type = N'COLUMN', @level2name = N'workListBatchKey';

