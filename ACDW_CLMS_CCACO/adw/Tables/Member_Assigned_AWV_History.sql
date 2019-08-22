CREATE TABLE [adw].[Member_Assigned_AWV_History] (
    [URN]                INT          IDENTITY (1, 1) NOT NULL,
    [RANK]               INT          NOT NULL,
    [HICN]               VARCHAR (50) NOT NULL,
    [FIRST_NAME]         VARCHAR (50) NULL,
    [LAST_NAME]          VARCHAR (50) NULL,
    [SEX]                VARCHAR (1)  NULL,
    [DOB]                DATE         NULL,
    [PREV_BEN_FLG]       INT          NULL,
    [CUR_AGE]            INT          NULL,
    [ELIG_TYPE]          VARCHAR (2)  NULL,
    [TIN]                VARCHAR (50) NULL,
    [TIN_NAME]           VARCHAR (50) NULL,
    [NPI]                VARCHAR (50) NULL,
    [NPI_NAME]           VARCHAR (50) NULL,
    [NPI_PRIM_SPECIALTY] VARCHAR (50) NULL,
    [RUN_DATE]           DATE         NULL,
    [RUN_YEAR]           INT          NULL,
    [RUN_MTH]            INT          NULL,
    [LOAD_DATE]          DATE         DEFAULT (sysdatetime()) NULL,
    [LOAD_USER]          VARCHAR (50) DEFAULT (suser_sname()) NULL
);

