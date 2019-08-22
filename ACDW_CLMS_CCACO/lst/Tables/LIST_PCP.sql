﻿CREATE TABLE [lst].[LIST_PCP] (
    [PCP_URN]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [CLIENT_ID]        VARCHAR (50)  NULL,
    [PCP_NPI]          VARCHAR (50)  NULL,
    [PCP_FIRST_NAME]   VARCHAR (50)  NULL,
    [PCP_MI]           VARCHAR (50)  NULL,
    [PCP_LAST_NAME]    VARCHAR (50)  NULL,
    [PCP__ADDRESS]     VARCHAR (50)  NULL,
    [PCP__ADDRESS2]    VARCHAR (50)  NULL,
    [PCP_CITY]         VARCHAR (50)  NULL,
    [PCP_STATE]        VARCHAR (50)  NULL,
    [PCP_ZIP]          VARCHAR (50)  NULL,
    [PCP_PHONE]        VARCHAR (50)  NULL,
    [PCP_CLIENT_ID]    VARCHAR (50)  NULL,
    [PCP_PRACTICE_TIN] VARCHAR (50)  NULL,
    [PRIM_SPECIALTY]   VARCHAR (100) NULL,
    [ACTIVE]           VARCHAR (50)  NULL,
    [LOAD_DATE]        DATETIME      NULL,
    [LOAD_USER]        VARCHAR (50)  NULL,
    [CAMPAIGN_RUN_ID]  INT           NULL,
    [T_Modify_by]      VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([PCP_URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_LstListPcp_PCP_NPI]
    ON [lst].[LIST_PCP]([PCP_NPI] ASC) WITH (FILLFACTOR = 100);

