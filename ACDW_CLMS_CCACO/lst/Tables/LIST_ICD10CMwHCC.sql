CREATE TABLE [lst].[LIST_ICD10CMwHCC] (
    [URN]                INT           IDENTITY (1, 1) NOT NULL,
    [ICD10]              VARCHAR (15)  NULL,
    [ICD10_DESCRIPTION]  VARCHAR (MAX) NULL,
    [HCCV21]             VARCHAR (10)  NULL,
    [HCCV22]             VARCHAR (10)  NULL,
    [RXHCC]              VARCHAR (10)  NULL,
    [HCCPACE_PY]         VARCHAR (10)  NULL,
    [HCCPYMT_PY]         VARCHAR (10)  NULL,
    [RXHCCPYMT_PY]       VARCHAR (10)  NULL,
    [PY]                 INT           NULL,
    [PY_DESC]            VARCHAR (25)  NULL,
    [PERM]               VARCHAR (1)   DEFAULT ((0)) NULL,
    [ACTIVE]             VARCHAR (1)   NULL,
    [A_LAST_UPDATE_DATE] DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (50)  DEFAULT ('CMS Final ICD10HCC RxHCC') NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   DEFAULT ('Y') NULL
);

