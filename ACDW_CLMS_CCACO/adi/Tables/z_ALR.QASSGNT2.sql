CREATE TABLE [adi].[z_ALR.QASSGNT2] (
    [QASSGNT2Key]      INT           NOT NULL,
    [OriginalFileName] VARCHAR (100) NOT NULL,
    [SrcFileName]      VARCHAR (100) NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [CreatedDate]      DATE          NOT NULL,
    [CreatedBy]        VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]  SMALLDATETIME NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  NOT NULL,
    [MBI]              VARCHAR (11)  NULL,
    [HICN]             VARCHAR (12)  NULL,
    [FirstName]        VARCHAR (30)  NULL,
    [LastName]         VARCHAR (40)  NULL,
    [Sex]              VARCHAR (1)   NULL,
    [DOB]              VARCHAR (10)  NULL,
    [DOD]              VARCHAR (10)  NULL,
    [TIN]              VARCHAR (10)  NULL,
    [PCServices]       VARCHAR (8)   NULL,
    [EffQtr]           VARCHAR (50)  NULL
);


GO
CREATE CLUSTERED INDEX [_dta_index_ALR.QASSGNT2_c_15_1092250996__K4]
    ON [adi].[z_ALR.QASSGNT2]([LoadDate] ASC);


GO
CREATE STATISTICS [_dta_stat_1092250996_13_4]
    ON [adi].[z_ALR.QASSGNT2]([Sex], [LoadDate]);

