CREATE TABLE [amd].[AceEtlAuditLogErrorLog] (
    [AceEtlAuditLogErrorLogKey] INT            IDENTITY (1, 1) NOT NULL,
    [ParamValues]               VARCHAR (1000) NULL,
    [CreatedDate]               DATETIME2 (7)  DEFAULT (CONVERT([datetime2],getdate())) NULL,
    [CreatedBy]                 VARCHAR (50)   DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([AceEtlAuditLogErrorLogKey] ASC)
);

