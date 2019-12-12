CREATE TABLE [adi].[CCLF0] (
    [URN]               INT           IDENTITY (1, 1) NOT NULL,
    [FileNumber]        VARCHAR (13)  NULL,
    [FileDescription]   VARCHAR (20)  NULL,
    [TotalRecordsCount] INT           NULL,
    [RecordLength]      INT           NULL,
    [SrcFileName]       VARCHAR (100) NULL,
    [FileDate]          DATE          NULL,
    [originalFileName]  VARCHAR (100) NULL,
    [CreateDate]        DATETIME      NULL,
    [CreateBy]          VARCHAR (100) NULL,
    CONSTRAINT [PK__CCLF0__C5B1000EBA2DC3A2] PRIMARY KEY CLUSTERED ([URN] ASC)
);

