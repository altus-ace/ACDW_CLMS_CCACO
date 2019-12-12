CREATE TABLE [adw].[QM_ResultByMember_TESTING] (
    [urn]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [QmMsrId]         VARCHAR (20) NOT NULL,
    [QmCntCat]        VARCHAR (10) NOT NULL,
    [QMDate]          DATE         NULL,
    [CreateDate]      DATETIME     NOT NULL,
    [CreateBy]        VARCHAR (50) CONSTRAINT [DF_CREATEBY] DEFAULT (suser_name()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

