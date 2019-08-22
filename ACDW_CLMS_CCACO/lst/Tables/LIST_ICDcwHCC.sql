CREATE TABLE [lst].[LIST_ICDcwHCC] (
    [URN]                 INT           IDENTITY (1, 1) NOT NULL,
    [ICD10]               VARCHAR (15)  NULL,
    [ICD10_DESCRIPTION]   VARCHAR (MAX) NULL,
    [HCCV21_PACE_ESRD]    VARCHAR (10)  NULL,
    [HCCV22]              VARCHAR (10)  NULL,
    [HCCV23]              VARCHAR (10)  NULL,
    [RXHCC]               VARCHAR (10)  NULL,
    [HCCV21_PACE_ESRD_PY] VARCHAR (10)  NULL,
    [HCCV22PYMT_PY]       VARCHAR (10)  NULL,
    [HCCV23PYMT_PY]       VARCHAR (10)  NULL,
    [RXHCCPYMT_PY]        VARCHAR (10)  NULL,
    [PY]                  INT           NULL,
    [PY_DESC]             VARCHAR (25)  NULL,
    [PERM]                VARCHAR (1)   NULL,
    [ACTIVE]              VARCHAR (1)   NULL,
    [A_LAST_UPDATE_DATE]  DATETIME      NULL,
    [A_LAST_UPDATE_BY]    VARCHAR (50)  NULL,
    [A_LAST_UPDATE_FLAG]  VARCHAR (1)   NULL,
    [VERSIONS]            VARCHAR (20)  NULL
);

