CREATE TABLE [adw].[tmp_MbrMissingCodes] (
    [subscriber_id]   VARCHAR (50)  NOT NULL,
    [DiagCode]        VARCHAR (20)  NOT NULL,
    [DiagDescription] VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([subscriber_id] ASC, [DiagCode] ASC)
);

