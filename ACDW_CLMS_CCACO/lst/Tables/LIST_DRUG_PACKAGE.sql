CREATE TABLE [lst].[LIST_DRUG_PACKAGE] (
    [URN]                INT            IDENTITY (1, 1) NOT NULL,
    [PRODUCTID]          VARCHAR (50)   NOT NULL,
    [PRODUCTNDC]         VARCHAR (15)   NOT NULL,
    [NDCPACKAGECODE]     VARCHAR (20)   NOT NULL,
    [PACKAGEDESCRIPTION] VARCHAR (1000) NOT NULL,
    [ACTIVE]             VARCHAR (1)    DEFAULT ('Y') NOT NULL,
    [LOAD_DATE]          DATE           DEFAULT (getdate()) NULL,
    [LOAD_USER]          VARCHAR (25)   DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

