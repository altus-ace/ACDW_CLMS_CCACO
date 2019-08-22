CREATE TABLE [lst].[lstClientCodesTypes] (
    [ClientCodesTypeKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientCodeType]     VARCHAR (100) NOT NULL,
    [LoadDate]           DATE          NOT NULL,
    [CreatedDate]        DATETIME2 (7) CONSTRAINT [DF_LstClientCodeTypes_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_LstClientCodeTypes_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME2 (7) CONSTRAINT [DF_LstClientCodeTypes_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  CONSTRAINT [DF_LstClientCodeTypes_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ClientCodesTypeKey] ASC)
);

