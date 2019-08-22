CREATE TABLE [ast].[pstCclf1_DeDupClmsHdr] (
    [clm_URN]     INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astPstCclf1_DeDupClmsHdr_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astPstCclf1_DeDupClmsHdr_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([clm_URN] ASC)
);

