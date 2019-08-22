CREATE TABLE [adw].[Claims_Conditions] (
    [URN]                BIGINT       IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]       VARCHAR (50) NOT NULL,
    [SUBSCRIBER_ID]      VARCHAR (50) NOT NULL,
    [CONDNUMBER]         SMALLINT     NOT NULL,
    [CONDITION_CODE]     VARCHAR (20) NULL,
    [A_CREATED_DATE]     DATETIME     CONSTRAINT [DF_ClaimsConditions_CreatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_CREATED_BY]       VARCHAR (50) CONSTRAINT [DF_ClaimsConditions_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [A_LST_UPDATED_DATE] DATETIME     CONSTRAINT [DF_ClaimsConditions_LastUpdatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_LST_UPDATED_BY]   VARCHAR (50) CONSTRAINT [DF_ClaimsConditions_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NdxCC_CondCode]
    ON [adw].[Claims_Conditions]([CONDITION_CODE] ASC);


GO
CREATE NONCLUSTERED INDEX [NdxCC_CondNum]
    ON [adw].[Claims_Conditions]([CONDNUMBER] ASC);


GO

CREATE TRIGGER [adw].ClaimsConditions_AfterUpdate
ON adw.Claims_Conditions
AFTER UPDATE 
AS
   UPDATE adw.Claims_Conditions
   SET A_LST_UPDATED_DATE = SYSDATETIME()
	, A_LST_UPDATED_BY = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Conditions.URN = i.URN;
