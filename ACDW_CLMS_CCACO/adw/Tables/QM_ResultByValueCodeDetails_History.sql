CREATE TABLE [adw].[QM_ResultByValueCodeDetails_History] (
    [QMValueCodeKey]              INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]                   INT           NOT NULL,
    [ClientMemberKey]             VARCHAR (20)  NOT NULL,
    [Value_Code_System]           VARCHAR (20)  NULL,
    [Value_Code]                  VARCHAR (20)  NULL,
    [Value_Code_Primary_Svc_Date] DATE          NOT NULL,
    [QmMsrID]                     VARCHAR (20)  NOT NULL,
    [QmCntCat]                    VARCHAR (20)  NOT NULL,
    [QMDate]                      DATE          NOT NULL,
    [RunDate]                     DATETIME      NOT NULL,
    [CreatedBy]                   VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]             DATETIME2 (7) NOT NULL,
    [LastUpdatedBy]               VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([QMValueCodeKey] ASC)
);

