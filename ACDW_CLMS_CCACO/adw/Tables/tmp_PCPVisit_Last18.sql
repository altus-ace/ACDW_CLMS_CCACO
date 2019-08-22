CREATE TABLE [adw].[tmp_PCPVisit_Last18] (
    [18_URN]        INT           IDENTITY (1, 1) NOT NULL,
    [SUBSCRIBER_ID] VARCHAR (50)  NULL,
    [LoadDate]      DATE          DEFAULT (sysdatetime()) NULL,
    [LoadBy]        VARCHAR (100) DEFAULT (suser_sname()) NULL,
    CONSTRAINT [18_URN] PRIMARY KEY CLUSTERED ([18_URN] ASC)
);

