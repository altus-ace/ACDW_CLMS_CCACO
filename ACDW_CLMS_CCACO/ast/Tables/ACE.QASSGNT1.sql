﻿CREATE TABLE [ast].[ACE.QASSGNT1] (
    [MBI]                 VARCHAR (50) NULL,
    [HICN]                VARCHAR (50) NULL,
    [FirstName]           VARCHAR (50) NULL,
    [LastName]            VARCHAR (50) NULL,
    [Sex]                 VARCHAR (50) NULL,
    [DOB]                 VARCHAR (50) NULL,
    [DOD]                 VARCHAR (50) NULL,
    [CountyName]          VARCHAR (50) NULL,
    [StateName]           VARCHAR (50) NULL,
    [CountyNumber]        VARCHAR (50) NULL,
    [VoluntaryFlag]       VARCHAR (50) NULL,
    [CBFlag]              VARCHAR (50) NULL,
    [CBStepFlag]          VARCHAR (50) NULL,
    [PrevBenFlag]         VARCHAR (50) NULL,
    [HCC1]                VARCHAR (50) NULL,
    [HCC2]                VARCHAR (50) NULL,
    [HCC6]                VARCHAR (50) NULL,
    [HCC8]                VARCHAR (50) NULL,
    [HCC9]                VARCHAR (50) NULL,
    [HCC10]               VARCHAR (50) NULL,
    [HCC11]               VARCHAR (50) NULL,
    [HCC12]               VARCHAR (50) NULL,
    [HCC17 ]              VARCHAR (50) NULL,
    [HCC18 ]              VARCHAR (50) NULL,
    [HCC19 ]              VARCHAR (50) NULL,
    [HCC21 ]              VARCHAR (50) NULL,
    [HCC22 ]              VARCHAR (50) NULL,
    [HCC23 ]              VARCHAR (50) NULL,
    [HCC27 ]              VARCHAR (50) NULL,
    [HCC28 ]              VARCHAR (50) NULL,
    [HCC29 ]              VARCHAR (50) NULL,
    [HCC33 ]              VARCHAR (50) NULL,
    [HCC34 ]              VARCHAR (50) NULL,
    [HCC35 ]              VARCHAR (50) NULL,
    [HCC39 ]              VARCHAR (50) NULL,
    [HCC40 ]              VARCHAR (50) NULL,
    [HCC46 ]              VARCHAR (50) NULL,
    [HCC47 ]              VARCHAR (50) NULL,
    [HCC48 ]              VARCHAR (50) NULL,
    [HCC54 ]              VARCHAR (50) NULL,
    [HCC55 ]              VARCHAR (50) NULL,
    [HCC57 ]              VARCHAR (50) NULL,
    [HCC58 ]              VARCHAR (50) NULL,
    [HCC70 ]              VARCHAR (50) NULL,
    [HCC71 ]              VARCHAR (50) NULL,
    [HCC72 ]              VARCHAR (50) NULL,
    [HCC73 ]              VARCHAR (50) NULL,
    [HCC74 ]              VARCHAR (50) NULL,
    [HCC75 ]              VARCHAR (50) NULL,
    [HCC76 ]              VARCHAR (50) NULL,
    [HCC77 ]              VARCHAR (50) NULL,
    [HCC78 ]              VARCHAR (50) NULL,
    [HCC79 ]              VARCHAR (50) NULL,
    [HCC80 ]              VARCHAR (50) NULL,
    [HCC82 ]              VARCHAR (50) NULL,
    [HCC83 ]              VARCHAR (50) NULL,
    [HCC84 ]              VARCHAR (50) NULL,
    [HCC85 ]              VARCHAR (50) NULL,
    [HCC86 ]              VARCHAR (50) NULL,
    [HCC87 ]              VARCHAR (50) NULL,
    [HCC88 ]              VARCHAR (50) NULL,
    [HCC96 ]              VARCHAR (50) NULL,
    [HCC99 ]              VARCHAR (50) NULL,
    [HCC100 ]             VARCHAR (50) NULL,
    [HCC103 ]             VARCHAR (50) NULL,
    [HCC104 ]             VARCHAR (50) NULL,
    [HCC106 ]             VARCHAR (50) NULL,
    [HCC107 ]             VARCHAR (50) NULL,
    [HCC108 ]             VARCHAR (50) NULL,
    [HCC110 ]             VARCHAR (50) NULL,
    [HCC111 ]             VARCHAR (50) NULL,
    [HCC112 ]             VARCHAR (50) NULL,
    [HCC114 ]             VARCHAR (50) NULL,
    [HCC115 ]             VARCHAR (50) NULL,
    [HCC122 ]             VARCHAR (50) NULL,
    [HCC124 ]             VARCHAR (50) NULL,
    [HCC134 ]             VARCHAR (50) NULL,
    [HCC135 ]             VARCHAR (50) NULL,
    [HCC136 ]             VARCHAR (50) NULL,
    [HCC137 ]             VARCHAR (50) NULL,
    [HCC157 ]             VARCHAR (50) NULL,
    [HCC158 ]             VARCHAR (50) NULL,
    [HCC161 ]             VARCHAR (50) NULL,
    [HCC162 ]             VARCHAR (50) NULL,
    [HCC166 ]             VARCHAR (50) NULL,
    [HCC167 ]             VARCHAR (50) NULL,
    [HCC169 ]             VARCHAR (50) NULL,
    [HCC170 ]             VARCHAR (50) NULL,
    [HCC173 ]             VARCHAR (50) NULL,
    [HCC176 ]             VARCHAR (50) NULL,
    [HCC186 ]             VARCHAR (50) NULL,
    [HCC188 ]             VARCHAR (50) NULL,
    [HCC189 ]             VARCHAR (50) NULL,
    [PartDFlag]           VARCHAR (50) NULL,
    [RS_ESRD]             VARCHAR (50) NULL,
    [RS_Disabled]         VARCHAR (50) NULL,
    [RS_AgedDual]         VARCHAR (50) NULL,
    [RS_AgedNonDual]      VARCHAR (50) NULL,
    [Demo_RS_ESRD]        VARCHAR (50) NULL,
    [Demo_RS_Disabled]    VARCHAR (50) NULL,
    [Demo_RS_AgedDual]    VARCHAR (50) NULL,
    [Demo_RS_AgedNonDual] VARCHAR (50) NULL,
    [EffQtr]              VARCHAR (50) NULL,
    [LOAD_DATE]           DATE         DEFAULT (sysdatetime()) NULL,
    [LOAD_USER]           VARCHAR (50) DEFAULT (suser_sname()) NULL
);

