CREATE TABLE [dbo].[zMember_UnassignedReason_History] (
    [URN]                  INT          IDENTITY (1, 1) NOT NULL,
    [MBI]                  VARCHAR (50) NULL,
    [HICN]                 VARCHAR (50) NULL,
    [Fname]                VARCHAR (50) NULL,
    [Lname]                VARCHAR (50) NULL,
    [Sex]                  VARCHAR (50) NULL,
    [DOB]                  VARCHAR (50) NULL,
    [DOD]                  VARCHAR (50) NULL,
    [Plurality]            VARCHAR (1)  NULL,
    [1MthCoverage]         VARCHAR (1)  NULL,
    [1MthHealthPlan]       VARCHAR (1)  NULL,
    [NotUSResident]        VARCHAR (1)  NULL,
    [InOtherSSInitiatives] VARCHAR (1)  NULL,
    [NoPCPVisit]           VARCHAR (1)  NULL,
    [MBR_YEAR]             INT          NULL,
    [MBR_QTR]              INT          NULL,
    [LOAD_DATE]            DATE         NULL,
    [LOAD_USER]            VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

