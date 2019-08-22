CREATE TABLE [adw].[Member_Provider_History] (
    [URN]       INT           IDENTITY (1, 1) NOT NULL,
    [MBI]       VARCHAR (50)  NULL,
    [HICN]      VARCHAR (50)  NULL,
    [FirstName] VARCHAR (50)  NULL,
    [LastName]  VARCHAR (50)  NULL,
    [Sex]       VARCHAR (5)   NULL,
    [DOB]       DATE          NULL,
    [DOD]       DATE          NULL,
    [TIN]       VARCHAR (25)  NULL,
    [TIN_NAME]  VARCHAR (100) NULL,
    [NPI]       VARCHAR (25)  NULL,
    [NPI_NAME]  VARCHAR (100) NULL,
    [ACO_NPI]   VARCHAR (1)   NULL,
    [MBR_YEAR]  INT           NULL,
    [MBR_QTR]   INT           NULL,
    [LOAD_DATE] DATE          NULL,
    [LOAD_USER] VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrProvHist_HicnTinNpiMbrQtr]
    ON [adw].[Member_Provider_History]([MBR_YEAR] ASC)
    INCLUDE([HICN], [TIN], [NPI], [MBR_QTR]);

