﻿CREATE TABLE [dbo].[z_LIST_HEDIS_CODE2] (
    [URN]                INT           IDENTITY (1, 1) NOT NULL,
    [VALUE_SET_NAME]     VARCHAR (100) NULL,
    [VALUE_SET_OID]      VARCHAR (100) NULL,
    [VALUE_SET_VER]      VARCHAR (50)  NULL,
    [VALUE_CODE]         VARCHAR (50)  NULL,
    [VALUE_CODE_NAME]    VARCHAR (MAX) NULL,
    [VALUE_CODE_SYSTEM]  VARCHAR (50)  NULL,
    [CODE_SYSTEM_OID]    VARCHAR (50)  NULL,
    [CODE_SYSTEM_VER]    VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (20)  DEFAULT ('HEDIS Vol2 10032016') NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   DEFAULT ('Y') NULL,
    [Value_code_NoDot]   VARCHAR (15)  NULL
);

