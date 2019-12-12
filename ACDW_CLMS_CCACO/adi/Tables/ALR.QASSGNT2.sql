CREATE TABLE [adi].[ALR.QASSGNT2] (
    [QASSGNT2Key]      INT           IDENTITY (1, 1) NOT NULL,
    [OriginalFileName] VARCHAR (100) NOT NULL,
    [SrcFileName]      VARCHAR (100) NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [CreatedDate]      DATE          NOT NULL,
    [CreatedBy]        VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]  DATETIME      NOT NULL,
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
    [EffQtr]           VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([QASSGNT2Key] ASC)
);

