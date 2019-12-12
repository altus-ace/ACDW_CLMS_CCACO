CREATE TABLE [lst].[lstOutreachOutcome] (
    [OutreachOutcomeKey]     INT           IDENTITY (1, 1) NOT NULL,
    [CallOutcomeDescription] VARCHAR (255) NOT NULL,
    [CreatedDate]            DATETIME2 (7) CONSTRAINT [DF_lstOutreachOutcome_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_lstOutreachOutcome_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]        DATETIME2 (7) CONSTRAINT [DF_lstOutreachOutcome_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)  CONSTRAINT [DF_lstOutreachOutcome_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_OutreachOutcomeKey] PRIMARY KEY CLUSTERED ([OutreachOutcomeKey] ASC)
);


GO


CREATE TRIGGER lst.TR_lstOutreachOutcome_AU
    ON lst.lstOutreachOutcome
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lst.lstOutreachOutcome
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lst.lstOutreachOutcome a
		  WHERE i.OutreachOutcomeKey = a.OutreachOutcomeKey;	   
    END