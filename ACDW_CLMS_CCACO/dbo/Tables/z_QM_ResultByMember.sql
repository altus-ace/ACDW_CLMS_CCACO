CREATE TABLE [dbo].[z_QM_ResultByMember] (
    [urn]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [QmMsrId]         VARCHAR (20) NOT NULL,
    [QmCntCat]        VARCHAR (10) NOT NULL,
    [QMDate]          DATE         CONSTRAINT [DF_QM_ResultByMbr_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [CreateDate]      DATETIME     CONSTRAINT [DF_QM_ResultByMbr_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]        VARCHAR (50) CONSTRAINT [DF_QM_ResultByMbr_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_QmResults_MbrKey]
    ON [dbo].[z_QM_ResultByMember]([ClientMemberKey] ASC);


GO
CREATE NONCLUSTERED INDEX [dboQmResultByMember]
    ON [dbo].[z_QM_ResultByMember]([QmCntCat] ASC);

