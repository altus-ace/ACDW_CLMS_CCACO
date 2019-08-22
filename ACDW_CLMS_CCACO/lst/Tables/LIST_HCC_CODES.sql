CREATE TABLE [lst].[LIST_HCC_CODES] (
    [HCC_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [HCC_No]          INT            NOT NULL,
    [HCC_Description] NVARCHAR (MAX) NULL,
    [Disease_Hier]    NVARCHAR (50)  NULL,
    [Year]            INT            NOT NULL,
    [LoadDate]        DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_LIST_HCC_CODES] PRIMARY KEY CLUSTERED ([HCC_ID] ASC)
);

