CREATE TABLE [adw].[Claims_Diags] (
    [URN]                BIGINT       IDENTITY (1, 1) NOT NULL,
    [SEQ_CLAIM_ID]       VARCHAR (50) NULL,
    [SUBSCRIBER_ID]      VARCHAR (50) NULL,
    [ICD_FLAG]           VARCHAR (1)  NULL,
    [diagNumber]         SMALLINT     NULL,
    [diagCode]           VARCHAR (20) NULL,
    [diagPoa]            VARCHAR (20) NULL,
    [A_CREATED_DATE]     DATETIME     CONSTRAINT [DF_ClaimsDiags_CreatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_CREATED_BY]       VARCHAR (50) CONSTRAINT [DF_ClaimsDiags_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [A_LST_UPDATED_DATE] DATETIME     CONSTRAINT [DF_ClaimsDiags_LastUpdatedDate] DEFAULT (sysdatetime()) NOT NULL,
    [A_LST_UPDATED_BY]   VARCHAR (50) CONSTRAINT [DF_ClaimsDiags_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Diags] PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmDgs_ClmID]
    ON [adw].[Claims_Diags]([SEQ_CLAIM_ID] ASC)
    INCLUDE([SUBSCRIBER_ID], [diagCode]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmDiag_UniqIDSubIDDiagNumDiagCdDiagPOA]
    ON [adw].[Claims_Diags]([ICD_FLAG] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID], [diagNumber], [diagCode], [diagPoa]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDiags_DiagCode]
    ON [adw].[Claims_Diags]([diagCode] ASC)
    INCLUDE([SEQ_CLAIM_ID], [SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [NdxCD_DiagNum]
    ON [adw].[Claims_Diags]([diagNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [NdxClmDgs_Seq_Claim_ID]
    ON [adw].[Claims_Diags]([SEQ_CLAIM_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Diags_15_1449108253__K3]
    ON [adw].[Claims_Diags]([SUBSCRIBER_ID] ASC);


GO
CREATE STATISTICS [_dta_stat_1449108253_2_6_1]
    ON [adw].[Claims_Diags]([SEQ_CLAIM_ID], [diagCode], [URN]);


GO
CREATE STATISTICS [_dta_stat_1449108253_2_1]
    ON [adw].[Claims_Diags]([SEQ_CLAIM_ID], [URN]);


GO

CREATE TRIGGER [adw].ClaimsDiags_AfterUpdate
ON adw.Claims_Diags
AFTER UPDATE 
AS
   UPDATE adw.Claims_Diags
   SET A_LST_UPDATED_DATE = SYSDATETIME()
	, A_LST_UPDATED_BY = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Diags.URN = i.URN;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The 4th character should be a dot.', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Diags', @level2type = N'COLUMN', @level2name = N'diagCode';

