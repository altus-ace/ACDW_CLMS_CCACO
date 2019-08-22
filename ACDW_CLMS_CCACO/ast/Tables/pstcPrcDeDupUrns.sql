CREATE TABLE [ast].[pstcPrcDeDupUrns] (
    [urn]         INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astpstcPrcDeDupUrns_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astpstcPrcDeDupUrns_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

