CREATE TABLE [adw].[QM_ResultByMember_History] (
    [urn]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [QmMsrId]         VARCHAR (20) NOT NULL,
    [QmCntCat]        VARCHAR (10) NOT NULL,
    [QMDate]          DATE         CONSTRAINT [DF_QM_ResultByMbr_History_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [CreateDate]      DATETIME     CONSTRAINT [DF_QM_ResultByMbr_History_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]        VARCHAR (50) CONSTRAINT [DF_QM_ResultByMbr_History_CreateBy] DEFAULT (suser_sname()) NOT NULL
);




GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_15_1720393198__K5D_1_2_3_4_6_7]
    ON [adw].[QM_ResultByMember_History]([QMDate] DESC)
    INCLUDE([urn], [ClientMemberKey], [QmMsrId], [QmCntCat], [CreateDate], [CreateBy]);

