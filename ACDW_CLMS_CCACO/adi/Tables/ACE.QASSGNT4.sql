CREATE TABLE [adi].[ACE.QASSGNT4] (
    [QASSGNT4Key]      INT           IDENTITY (1, 1) NOT NULL,
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
    [CreatedDate]      DATE          CONSTRAINT [DF_adiACEQASSGNT4_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [DF_adiACEQASSGNT4_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]  DATETIME      CONSTRAINT [DF_adiACEQASSGNT4_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  CONSTRAINT [DF_adiACEQASSGNT4_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([QASSGNT4Key] ASC)
);

