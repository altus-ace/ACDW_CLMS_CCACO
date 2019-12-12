CREATE TABLE [adw].[QM_ResultByValueCodeDetails_TESTING] (
    [QMValueCodeKey]          INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]               INT           NOT NULL,
    [ClientMemberKey]         VARCHAR (20)  NOT NULL,
    [ValueCodeSystem]         VARCHAR (20)  NULL,
    [ValueCode]               VARCHAR (20)  NULL,
    [ValueCodePrimarySvcDate] DATE          NULL,
    [QmMsrID]                 VARCHAR (20)  NULL,
    [QmCntCat]                VARCHAR (20)  NULL,
    [QMDate]                  DATE          NOT NULL,
    [RunDate]                 DATETIME      NOT NULL,
    [CreatedBy]               VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]         DATETIME2 (7) NOT NULL,
    [LastUpdatedBy]           VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([QMValueCodeKey] ASC)
);

