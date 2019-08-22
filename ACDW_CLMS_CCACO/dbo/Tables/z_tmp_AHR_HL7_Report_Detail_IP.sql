CREATE TABLE [dbo].[z_tmp_AHR_HL7_Report_Detail_IP] (
    [IP_ID]            INT           IDENTITY (4000, 1) NOT NULL,
    [SUBSCRIBER_ID]    VARCHAR (50)  NULL,
    [ADMIT_DATE]       DATE          NULL,
    [DISC_DATE]        DATE          NULL,
    [LOS]              INT           NULL,
    [DISC_DISPOSITION] VARCHAR (25)  NULL,
    [PRIMARY_DX]       VARCHAR (11)  NULL,
    [DESC]             VARCHAR (MAX) NULL,
    [SECONDARY_DX]     VARCHAR (11)  NULL,
    [SECONDARY_DESC]   VARCHAR (MAX) NULL,
    [LOCATION]         VARCHAR (250) NULL,
    [LOADDATE]         DATE          DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]         VARCHAR (250) DEFAULT (suser_sname()) NULL
);

