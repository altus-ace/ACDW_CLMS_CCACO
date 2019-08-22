CREATE TABLE [adw].[tmp_Active_Members] (
    [URN]                           INT          IDENTITY (1, 1) NOT NULL,
    [MBI]                           VARCHAR (50) NULL,
    [HICN]                          VARCHAR (50) NOT NULL,
    [MemberId]                      VARCHAR (50) NOT NULL,
    [FirstName]                     VARCHAR (50) NULL,
    [LastName]                      VARCHAR (50) NULL,
    [Sex]                           VARCHAR (1)  NULL,
    [Member_Zip]                    VARCHAR (5)  NULL,
    [Member_Pod]                    VARCHAR (5)  NULL,
    [DOB]                           DATE         NULL,
    [DOD]                           DATE         NULL,
    [AgeGrp]                        VARCHAR (1)  NULL,
    [Exclusion]                     VARCHAR (1)  DEFAULT ('N') NULL,
    [Mbr_Type]                      VARCHAR (1)  NULL,
    [AWV]                           INT          DEFAULT ((0)) NULL,
    [PCP]                           INT          DEFAULT ((0)) NULL,
    [IP]                            INT          DEFAULT ((0)) NULL,
    [ER]                            INT          DEFAULT ((0)) NULL,
    [RA]                            INT          DEFAULT ((0)) NULL,
    [CurrentGaps]                   INT          DEFAULT ((0)) NULL,
    [HospiceCode]                   INT          DEFAULT ((0)) NULL,
    [PCP_Last18Mths]                INT          DEFAULT ((0)) NULL,
    [PCP_Last12Mths]                INT          DEFAULT ((0)) NULL,
    [AHRGaps]                       INT          DEFAULT ((0)) NULL,
    [TIN]                           VARCHAR (50) NULL,
    [TIN_NAME]                      VARCHAR (50) NULL,
    [NPI]                           VARCHAR (50) NULL,
    [NPI_NAME]                      VARCHAR (50) NULL,
    [MBR_YEAR]                      INT          NULL,
    [MBR_QTR]                       INT          NULL,
    [IPVisits_Last12Mths]           INT          NULL,
    [ERVisits_Last12Mths]           INT          NULL,
    [BedDays_Last12Mths]            INT          NULL,
    [Readmissions_Last12Mths]       INT          NULL,
    [IP_FUP_Within_7_Days]          INT          NULL,
    [ER_FUP_Within_7_Days]          INT          NULL,
    [Last_PCP_Visit]                DATE         NULL,
    [Last_PCP_NPI]                  VARCHAR (20) NULL,
    [Total_Cost_Last12Mths]         MONEY        NULL,
    [IP_Costs_Last12Mths]           MONEY        NULL,
    [ER_Costs_Last12Mths]           MONEY        NULL,
    [OP_Costs_Last12Mths]           MONEY        NULL,
    [Rx_Costs_Last12Mths]           MONEY        NULL,
    [Prim_Care_Costs_Last12Mths]    MONEY        NULL,
    [Behavioral_Costs_Last12Mths]   MONEY        NULL,
    [Other_Office_Costs_Last12Mths] MONEY        NULL,
    [Total_Cost_CY]                 MONEY        NULL,
    [IP_Costs_CY]                   MONEY        NULL,
    [ER_Costs_CY]                   MONEY        NULL,
    [OP_Costs_CY]                   MONEY        NULL,
    [Rx_Costs_CY]                   MONEY        NULL,
    [Prim_Care_Costs_CY]            MONEY        NULL,
    [Behavioral_Costs_CY]           MONEY        NULL,
    [Other_Office_Costs_CY]         MONEY        NULL,
    [LOAD_DATE]                     DATE         NULL,
    [LOAD_USER]                     VARCHAR (50) NULL
);


GO
CREATE STATISTICS [_dta_stat_955202503_10_7]
    ON [adw].[tmp_Active_Members]([DOB], [Sex]);


GO
CREATE STATISTICS [_dta_stat_955202503_3_10_7]
    ON [adw].[tmp_Active_Members]([HICN], [DOB], [Sex]);

