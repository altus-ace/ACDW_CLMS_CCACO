﻿CREATE TABLE [lst].[LIST_HEDIS_CODE] (
    [URN]                INT           IDENTITY (1, 1) NOT NULL,
    [VALUE_SET_NAME]     VARCHAR (100) NULL,
    [VALUE_SET_OID]      VARCHAR (100) NULL,
    [VALUE_SET_VER]      VARCHAR (50)  NULL,
    [VALUE_CODE]         VARCHAR (50)  NULL,
    [VALUE_CODE_NAME]    VARCHAR (MAX) NULL,
    [VALUE_CODE_SYSTEM]  VARCHAR (50)  NULL,
    [CODE_SYSTEM_OID]    VARCHAR (50)  NULL,
    [CODE_SYSTEM_VER]    VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (20)  NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   NULL,
    [ACTIVE]             VARCHAR (2)   NULL
);


GO
CREATE NONCLUSTERED INDEX [Ndx_ListHedisCode_ActiveValSetNameValCodeSys]
    ON [lst].[LIST_HEDIS_CODE]([ACTIVE] ASC, [VALUE_SET_NAME] ASC, [VALUE_CODE_SYSTEM] ASC)
    INCLUDE([VALUE_CODE]);


GO
CREATE STATISTICS [_dta_stat_1485248346_5_2_7]
    ON [lst].[LIST_HEDIS_CODE]([VALUE_CODE], [VALUE_SET_NAME], [VALUE_CODE_SYSTEM]);


GO
CREATE STATISTICS [_dta_stat_1485248346_2_7]
    ON [lst].[LIST_HEDIS_CODE]([VALUE_SET_NAME], [VALUE_CODE_SYSTEM]);


GO
CREATE STATISTICS [_dta_stat_1485248346_5_13_2]
    ON [lst].[LIST_HEDIS_CODE]([VALUE_CODE], [ACTIVE], [VALUE_SET_NAME]);


GO
CREATE STATISTICS [_dta_stat_1485248346_7_13]
    ON [lst].[LIST_HEDIS_CODE]([VALUE_CODE_SYSTEM], [ACTIVE]);

