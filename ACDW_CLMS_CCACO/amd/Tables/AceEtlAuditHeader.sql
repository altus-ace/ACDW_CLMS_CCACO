CREATE TABLE [amd].[AceEtlAuditHeader] (
    [EtlAuditHeaderPkey]   INT           IDENTITY (1, 1) NOT NULL,
    [EtlAuditStatus]       SMALLINT      DEFAULT ((0)) NULL,
    [PackageName]          VARCHAR (200) NULL,
    [ActionStartTime]      DATETIME2 (7) NULL,
    [ActionStopTime]       DATETIME2 (7) NULL,
    [InputSourceName]      VARCHAR (200) NULL,
    [InputCount]           INT           NULL,
    [DestinationName]      VARCHAR (200) NULL,
    [DestinationCount]     INT           NULL,
    [ErrorDestinationName] VARCHAR (200) NULL,
    [ErrorCount]           INT           NULL,
    [CreatedDate]          DATETIME2 (7) DEFAULT (getdate()) NULL,
    [CreatedBy]            VARCHAR (200) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([EtlAuditHeaderPkey] ASC)
);

