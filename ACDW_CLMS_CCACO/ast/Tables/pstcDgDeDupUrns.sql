CREATE TABLE [ast].[pstcDgDeDupUrns] (
    [urn]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astpstcDgDeDupUrns_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astpstcDgDeDupUrns_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

