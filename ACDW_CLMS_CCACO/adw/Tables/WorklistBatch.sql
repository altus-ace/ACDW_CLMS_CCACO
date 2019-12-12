CREATE TABLE [adw].[WorklistBatch] (
    [WorklistBatchKey] INT          IDENTITY (1, 1) NOT NULL,
    [BatchDate]        DATETIME     NOT NULL,
    [CreatedDate]      DATETIME     CONSTRAINT [DF_WorklistBatch_CreatedDate] DEFAULT (getdate()) NULL,
    [CreatedBy]        VARCHAR (50) CONSTRAINT [DF_WorklistBatch_CreatedBy] DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]  DATETIME     CONSTRAINT [DF_WorklistBatch_LastUpdatedDate] DEFAULT (getdate()) NULL,
    [LastUpdatedBy]    VARCHAR (50) CONSTRAINT [DF_WorklistBatch_LastUpdatedBy] DEFAULT (suser_sname()) NULL,
    CONSTRAINT [PK_WorklistBatchKey] PRIMARY KEY CLUSTERED ([WorklistBatchKey] ASC)
);


GO


CREATE TRIGGER adw.TR_WorklistBatch_AU
    ON [adw].[WorklistBatch]
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE WorklistBatch
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, WorklistBatch a
		  WHERE i.WorklistBatchKey = a.WorklistBatchKey;	   
    END