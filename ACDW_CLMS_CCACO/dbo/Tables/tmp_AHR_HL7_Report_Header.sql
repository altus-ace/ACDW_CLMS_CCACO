CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Header] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [LastName]     VARCHAR (100) NULL,
    [FirstName]    VARCHAR (100) NULL,
    [SubscriberNo] VARCHAR (50)  NULL,
    [PCP_LastName] VARCHAR (100) NULL,
    [DOB]          DATE          NULL,
    [CurrentAge]   INT           NULL,
    [Gender]       VARCHAR (1)   NULL,
    [Address1]     VARCHAR (100) NULL,
    [Address2]     VARCHAR (100) NULL,
    [City]         VARCHAR (50)  NULL,
    [State]        VARCHAR (2)   NULL,
    [Zip]          VARCHAR (10)  NULL,
    [PracticeID]   VARCHAR (50)  NULL,
    [PracticeName] VARCHAR (100) NULL,
    [LOADDATE]     DATE          DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]     VARCHAR (250) DEFAULT (suser_sname()) NULL
);

