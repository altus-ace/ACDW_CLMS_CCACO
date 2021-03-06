﻿CREATE TABLE [ast].[ACE.QASSGNT2] (
    [MBI]        VARCHAR (50) NULL,
    [HICN]       VARCHAR (50) NULL,
    [FirstName]  VARCHAR (50) NULL,
    [LastName]   VARCHAR (50) NULL,
    [Sex]        VARCHAR (50) NULL,
    [DOB]        VARCHAR (50) NULL,
    [DOD]        VARCHAR (50) NULL,
    [TIN]        VARCHAR (50) NULL,
    [PCServices] VARCHAR (50) NULL,
    [EffQtr]     VARCHAR (50) NULL,
    [LOAD_DATE]  DATE         DEFAULT (sysdatetime()) NULL,
    [LOAD_USER]  VARCHAR (50) DEFAULT (suser_sname()) NULL
);

