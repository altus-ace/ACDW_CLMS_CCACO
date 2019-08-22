CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx] (
    [ID]                 INT            IDENTITY (2000, 1) NOT NULL,
    [SUBSCRIBER_ID]      VARCHAR (50)   NULL,
    [ICD10_Code]         VARCHAR (11)   NULL,
    [DESC]               VARCHAR (MAX)  NULL,
    [HCC]                VARCHAR (3)    NULL,
    [HCC_Description]    VARCHAR (MAX)  NULL,
    [WEIGHT]             DECIMAL (4, 3) NULL,
    [SVC_PROV_FULL_NAME] VARCHAR (250)  NULL,
    [SVC_PROV_NPI]       VARCHAR (11)   NULL,
    [SVC_DATE]           DATE           NULL,
    [LOADDATE]           DATE           DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]           VARCHAR (50)   DEFAULT (suser_sname()) NULL
);

