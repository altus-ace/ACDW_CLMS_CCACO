CREATE TABLE [lst].[LIST_NPPES_COUNTY] (
    [zip]         VARCHAR (15)  NOT NULL,
    [city]        VARCHAR (100) NULL,
    [state]       VARCHAR (20)  NULL,
    [county]      VARCHAR (65)  NOT NULL,
    [SrcFileName] VARCHAR (100) NULL,
    [FileDate]    DATE          NULL,
    [CreateDate]  DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]    VARCHAR (100) DEFAULT (suser_sname()) NULL,
    CONSTRAINT [PK_List_NPPES_COUNTYID] PRIMARY KEY CLUSTERED ([zip] ASC, [county] ASC)
);

