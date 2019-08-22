CREATE TABLE [lst].[LIST_CPT] (
    [URN]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [CPT_CODE]  VARCHAR (20)  NULL,
    [CPT_DESC]  VARCHAR (150) NULL,
    [CPT_VER]   INT           NULL,
    [ACTIVE]    VARCHAR (1)   NULL,
    [LOAD_DATE] DATE          NULL,
    [LOAD_USER] VARCHAR (25)  NULL
);

