CREATE TABLE [adw].[AHR_Population_History] (
    [URN]                INT            IDENTITY (1, 1) NOT NULL,
    [HICN]               VARCHAR (50)   NOT NULL,
    [MBI]                VARCHAR (50)   NULL,
    [FirstName]          VARCHAR (50)   NULL,
    [LastName]           VARCHAR (50)   NULL,
    [Sex]                VARCHAR (1)    NULL,
    [DOB]                DATE           NULL,
    [CurrentRS]          DECIMAL (5, 4) DEFAULT ((0)) NULL,
    [CurrentDisplayGaps] INT            DEFAULT ((0)) NULL,
    [CurrentGaps]        INT            DEFAULT ((0)) NULL,
    [Age]                INT            NULL,
    [TIN]                VARCHAR (50)   NULL,
    [TIN_NAME]           VARCHAR (50)   NULL,
    [NPI]                VARCHAR (50)   NULL,
    [NPI_NAME]           VARCHAR (50)   NULL,
    [PRIM_SPECIALTY]     VARCHAR (50)   NULL,
    [RUN_DATE]           DATE           NULL,
    [RUN_YEAR]           INT            NULL,
    [RUN_MTH]            INT            NULL,
    [LOAD_DATE]          DATE           NULL,
    [LOAD_USER]          VARCHAR (50)   NULL,
    [ToSend]             VARCHAR (1)    DEFAULT ('Y') NULL,
    [SentDate]           DATE           NULL
);


GO
CREATE CLUSTERED INDEX [_dta_index_AHR_Population_History_c_15_929438385__K20_K22]
    ON [adw].[AHR_Population_History]([LOAD_DATE] ASC, [ToSend] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_AHR_Population_History_15_929438385__K20_K22_K14]
    ON [adw].[AHR_Population_History]([LOAD_DATE] ASC, [ToSend] ASC, [NPI] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_AHR_Population_History_15_929438385__K22_K20_K14]
    ON [adw].[AHR_Population_History]([ToSend] ASC, [LOAD_DATE] ASC, [NPI] ASC);


GO
CREATE STATISTICS [_dta_stat_929438385_14_20]
    ON [adw].[AHR_Population_History]([NPI], [LOAD_DATE]);

