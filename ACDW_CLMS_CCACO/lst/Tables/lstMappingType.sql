CREATE TABLE [lst].[lstMappingType] (
    [MappingTypeKey]     INT           IDENTITY (1, 1) NOT NULL,
    [MappingDescription] VARCHAR (250) NULL,
    [CreatedDate]        DATETIME2 (7) CONSTRAINT [DF_ListMappingType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_ListMappingType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME2 (7) CONSTRAINT [DF_ListMappingType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  CONSTRAINT [DF_ListMappingType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([MappingTypeKey] ASC)
);

