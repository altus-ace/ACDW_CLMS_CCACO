CREATE TABLE [ast].[ACE.QASSGNT5] (
    [MBI]                  VARCHAR (50) NULL,
    [HICN]                 VARCHAR (50) NULL,
    [FirstName]            VARCHAR (50) NULL,
    [LastName]             VARCHAR (50) NULL,
    [Sex]                  VARCHAR (50) NULL,
    [DOB]                  VARCHAR (50) NULL,
    [DOD]                  VARCHAR (50) NULL,
    [Plurality]            VARCHAR (50) NULL,
    [1MthCoverage]         VARCHAR (50) NULL,
    [1MthHealthPlan]       VARCHAR (50) NULL,
    [NotUSResident]        VARCHAR (50) NULL,
    [InOtherSSInitiatives] VARCHAR (50) NULL,
    [NoPCPVisit]           VARCHAR (50) NULL,
    [EffQtr]               VARCHAR (50) NULL,
    [LOAD_DATE]            DATE         DEFAULT (sysdatetime()) NULL,
    [LOAD_USER]            VARCHAR (50) DEFAULT (suser_sname()) NULL
);

