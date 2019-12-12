CREATE TABLE [adi].[z.ALR.QASSGNT4] (
    [QASSGNT4Key]      INT           NOT NULL,
    [MBI]              VARCHAR (50)  NULL,
    [HICN]             VARCHAR (50)  NULL,
    [FirstName]        VARCHAR (50)  NULL,
    [LastName]         VARCHAR (50)  NULL,
    [Sex]              VARCHAR (50)  NULL,
    [DOB]              VARCHAR (50)  NULL,
    [DOD]              VARCHAR (50)  NULL,
    [TIN]              VARCHAR (50)  NULL,
    [NPI]              VARCHAR (50)  NULL,
    [EffQtr]           VARCHAR (50)  NULL,
    [OriginalFileName] VARCHAR (100) NOT NULL,
    [SrcFileName]      VARCHAR (100) NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [CreatedDate]      DATE          NOT NULL,
    [CreatedBy]        VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]  SMALLDATETIME NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  NOT NULL
);

