CREATE TABLE [ast].[pstLatestEffectiveClmsHdr] (
    [clmSKey]     VARCHAR (50)  NOT NULL,
    [clmHdrURN]   INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astpstLatestEffectiveClmsHdr_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astpstLatestEffectiveClmsHdr_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([clmSKey] ASC)
);

