CREATE TABLE [dbo].[ztmp_Aggr_SubscriberID] (
    [urn]          INT          IDENTITY (1, 1) NOT NULL,
    [SubscriberID] VARCHAR (50) NULL,
    [Yr]           INT          NULL,
    [CatOfSvc]     VARCHAR (50) NULL,
    [TotBilled]    MONEY        NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

