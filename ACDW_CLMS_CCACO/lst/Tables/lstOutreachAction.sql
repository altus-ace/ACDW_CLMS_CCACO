CREATE TABLE [lst].[lstOutreachAction] (
    [OutReachActionKey]         INT           IDENTITY (1, 1) NOT NULL,
    [OutReachActionDescription] VARCHAR (255) NOT NULL,
    [CreatedDate]               DATETIME2 (7) CONSTRAINT [DF_lstOutreachAction_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                 VARCHAR (50)  CONSTRAINT [DF_lstOutreachAction_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]           DATETIME2 (7) CONSTRAINT [DF_lstOutreachAction_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (50)  CONSTRAINT [DF_lstOutreachAction_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_CallActionKey] PRIMARY KEY CLUSTERED ([OutReachActionKey] ASC)
);


GO


CREATE TRIGGER lst.TR_lstOutreachAction_AU
    ON lst.lstOutreachAction
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lst.lstOutreachAction
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lst.lstOutreachAction a
		  WHERE i.OutReachActionKey = a.OutReachActionKey;	   
    END