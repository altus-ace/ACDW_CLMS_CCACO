CREATE TABLE [lst].[LIST_DRG] (
    [URN]                             BIGINT        IDENTITY (1, 1) NOT NULL,
    [DRG_CODE]                        VARCHAR (20)  NULL,
    [DRG_DESC]                        VARCHAR (150) NULL,
    [DRG_MDC_MajorDiagnosticCategory] VARCHAR (150) NULL,
    [MDC_DESC]                        VARCHAR (300) NULL,
    [MedMorSurgP]                     VARCHAR (20)  NULL,
    [DRG_VER]                         INT           NULL,
    [ACTIVE]                          VARCHAR (1)   NULL,
    [LOAD_DATE]                       DATE          NULL,
    [LOAD_USER]                       VARCHAR (25)  NULL
);

