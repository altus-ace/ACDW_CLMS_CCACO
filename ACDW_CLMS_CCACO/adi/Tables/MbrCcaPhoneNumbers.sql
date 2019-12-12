CREATE TABLE [adi].[MbrCcaPhoneNumbers] (
    [MbrPhoneNumberUrn] INT           IDENTITY (1, 1) NOT NULL,
    [LoadDate]          DATE          NOT NULL,
    [DataDate]          DATE          NOT NULL,
    [SrcFileName]       VARCHAR (100) NOT NULL,
    [CreatedDate]       DATE          CONSTRAINT [DF_adiMbrCcaPhoneNumbers_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [DF_adiMbrCcaPhoneNumbers_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATE          CONSTRAINT [DF_adiMbrCcaPhoneNumbers_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  CONSTRAINT [DF_adiMbrCcaPhoneNumbers_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastName]          VARCHAR (50)  NULL,
    [FirstName]         VARCHAR (50)  NULL,
    [DOB]               DATE          NULL,
    [ClientMemberKey]   VARCHAR (50)  NULL,
    [TIN]               VARCHAR (15)  NULL,
    [HomePhone]         VARCHAR (35)  NULL,
    [MobilePhone]       VARCHAR (35)  NULL,
    [Language]          VARCHAR (35)  NULL,
    [FileDate]          DATE          NULL,
    [OriginalFileName]  VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([MbrPhoneNumberUrn] ASC)
);



