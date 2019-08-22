CREATE TABLE [adw].[Claims_Procs] (
    [URN]                BIGINT       IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]       VARCHAR (50) NULL,
    [SUBSCRIBER_ID]      VARCHAR (50) NULL,
    [ProcNumber]         SMALLINT     NULL,
    [ProcCode]           VARCHAR (20) NULL,
    [ProcDate]           VARCHAR (50) NULL,
    [A_CREATED_DATE]     DATETIME     CONSTRAINT [DF_ClaimsProcs_CreatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_CREATED_BY]       VARCHAR (50) CONSTRAINT [DF_ClaimsProcs_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [A_LST_UPDATED_DATE] DATETIME     CONSTRAINT [DF_ClaimsProcs_LastUpdatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_LST_UPDATED_BY]   VARCHAR (50) CONSTRAINT [DF_ClaimsProcs_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Procs] PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsProc_ProcCode]
    ON [adw].[Claims_Procs]([ProcCode] ASC)
    INCLUDE([URN], [SEQ_CLAIM_ID], [SUBSCRIBER_ID], [ProcNumber], [ProcDate]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsProc_SeqClaimID]
    ON [adw].[Claims_Procs]([SEQ_CLAIM_ID] ASC)
    INCLUDE([URN], [SUBSCRIBER_ID], [ProcNumber], [ProcCode], [ProcDate]);


GO
CREATE NONCLUSTERED INDEX [NdxCP_ProcNum]
    ON [adw].[Claims_Procs]([ProcNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [NdxCP_SubscriberID]
    ON [adw].[Claims_Procs]([SUBSCRIBER_ID] ASC)
    INCLUDE([URN], [SEQ_CLAIM_ID], [ProcNumber], [ProcCode], [ProcDate]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Procs_15_1497108424__K3]
    ON [adw].[Claims_Procs]([SUBSCRIBER_ID] ASC);


GO
CREATE STATISTICS [_dta_stat_1497108424_5_2]
    ON [adw].[Claims_Procs]([ProcCode], [SEQ_CLAIM_ID]);

