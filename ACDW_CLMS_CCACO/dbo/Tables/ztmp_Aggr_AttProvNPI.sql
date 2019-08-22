CREATE TABLE [dbo].[ztmp_Aggr_AttProvNPI] (
    [urn]       INT          IDENTITY (1, 1) NOT NULL,
    [ProvNpi]   VARCHAR (15) NULL,
    [Yr]        INT          NULL,
    [CatOfSvc]  VARCHAR (50) NULL,
    [TotBilled] MONEY        NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

