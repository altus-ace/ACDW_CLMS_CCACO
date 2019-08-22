CREATE TABLE [adw].[Member_Practice_History] (
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
    [PCSVS]     INT           NULL,
    [MBR_YEAR]  INT           NULL,
    [MBR_QTR]   INT           NULL,
    [LOAD_DATE] DATE          NULL,
    [LOAD_USER] VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_Mbr_Prac_Hist_MbrYear]
    ON [adw].[Member_Practice_History]([MBR_YEAR] ASC)
    INCLUDE([MBR_QTR]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrProvHist_TinPCSVSMbrQtr]
    ON [adw].[Member_Practice_History]([MBR_YEAR] ASC)
    INCLUDE([TIN], [TIN_NAME], [PCSVS], [MBR_QTR]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrPracHistTinPCSVSMbrQtr]
    ON [adw].[Member_Practice_History]([MBR_YEAR] ASC)
    INCLUDE([TIN], [TIN_NAME], [PCSVS], [MBR_QTR]);

