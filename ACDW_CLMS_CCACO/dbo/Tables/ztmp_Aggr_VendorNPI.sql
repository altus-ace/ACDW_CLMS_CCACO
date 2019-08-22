CREATE TABLE [dbo].[ztmp_Aggr_VendorNPI] (
    [urn]       INT          IDENTITY (1, 1) NOT NULL,
    [VendorNpi] VARCHAR (15) NULL,
    [Yr]        INT          NULL,
    [CatOfSvc]  VARCHAR (50) NULL,
    [TotBilled] MONEY        NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

