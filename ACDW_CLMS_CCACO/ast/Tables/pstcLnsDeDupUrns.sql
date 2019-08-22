CREATE TABLE [ast].[pstcLnsDeDupUrns] (
    [URN]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astpstcLnsDeDupUrns_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astpstcLnsDeDupUrns_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

