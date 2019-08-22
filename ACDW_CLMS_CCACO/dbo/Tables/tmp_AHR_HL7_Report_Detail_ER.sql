CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER] (
    [EP_ID]          INT           IDENTITY (3000, 1) NOT NULL,
    [SUBSCRIBER_ID]  VARCHAR (50)  NULL,
    [DATE]           DATE          NULL,
    [PRIMARY_DX]     VARCHAR (11)  NULL,
    [DESC]           VARCHAR (MAX) NULL,
    [SECONDARY_DX]   VARCHAR (11)  NULL,
    [SECONDARY_DESC] VARCHAR (MAX) NULL,
    [LOCATION]       VARCHAR (250) NULL,
    [LOADDATE]       DATE          DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]       VARCHAR (250) DEFAULT (suser_sname()) NULL
);

