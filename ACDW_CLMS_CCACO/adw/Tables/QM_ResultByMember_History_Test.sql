CREATE TABLE [adw].[QM_ResultByMember_History_Test] (
    [urn]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [QmMsrId]         VARCHAR (20) NOT NULL,
    [QmCntCat]        VARCHAR (10) NOT NULL,
    [QMDate]          DATE         NULL,
    [CreateDate]      DATETIME     NULL,
    [CreateBy]        VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

