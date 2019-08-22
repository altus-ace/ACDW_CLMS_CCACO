CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_CG] (
    [ID]            INT           IDENTITY (1000, 1) NOT NULL,
    [SUBSCRIBER_ID] VARCHAR (50)  NULL,
    [CGQM]          VARCHAR (10)  NULL,
    [CGQMDESC]      VARCHAR (150) NULL,
    [LOADDATE]      DATETIME      DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]      VARCHAR (100) DEFAULT (suser_sname()) NULL
);

