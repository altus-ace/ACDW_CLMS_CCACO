CREATE TABLE [dbo].[z_MbrAssignable] (
    [URN]              INT           IDENTITY (1, 1) NOT NULL,
    [MBI]              VARCHAR (50)  NULL,
    [HICN]             VARCHAR (50)  NULL,
    [Fname]            VARCHAR (50)  NULL,
    [Lname]            VARCHAR (50)  NULL,
    [Sex]              VARCHAR (50)  NULL,
    [DOB]              VARCHAR (50)  NULL,
    [DOD]              VARCHAR (50)  NULL,
    [CM_Flg]           VARCHAR (50)  NULL,
    [Mbr_Type]         VARCHAR (50)  NULL,
    [SrcFileName]      VARCHAR (100) NULL,
    [FileDate]         DATE          NULL,
    [OriginalFileName] VARCHAR (100) NULL,
    [CreateDate]       DATETIME      NULL,
    [CreateBy]         VARCHAR (100) NULL
);

