CREATE TABLE [lst].[lstServiceReps] (
    [ServiceRepKey]   INT           IDENTITY (1, 1) NOT NULL,
    [ServiceRepName]  VARCHAR (100) NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_lstServiceReps_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_lstServiceReps_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_lstServiceReps_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_lstServiceReps_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_ServiceRepKey] PRIMARY KEY CLUSTERED ([ServiceRepKey] ASC)
);


GO

CREATE TRIGGER lst.TR_lstServiceReps_AU
    ON lst.lstServiceReps
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lst.lstServiceReps
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lst.lstServiceReps a
		  WHERE i.ServiceRepKey = a.ServiceRepKey;	   
    END