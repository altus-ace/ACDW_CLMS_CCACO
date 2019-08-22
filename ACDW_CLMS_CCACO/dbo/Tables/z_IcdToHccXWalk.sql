CREATE TABLE [dbo].[z_IcdToHccXWalk] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [ICD]       NVARCHAR (50) NOT NULL,
    [DESC]      VARCHAR (MAX) NULL,
    [VER]       INT           NOT NULL,
    [HCC_ESRD]  INT           NULL,
    [HCC]       INT           NULL,
    [RxHCC]     NVARCHAR (50) NULL,
    [INHCCESRD] NVARCHAR (50) NULL,
    [INHCC]     NVARCHAR (50) NULL,
    [INRxHCC]   NVARCHAR (50) NULL,
    [Year]      INT           NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_HCC]
    ON [dbo].[z_IcdToHccXWalk]([HCC] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ID]
    ON [dbo].[z_IcdToHccXWalk]([ID] ASC);

