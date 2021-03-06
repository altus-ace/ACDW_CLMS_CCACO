/****** Script for SelectTopNRows command from SSMS  ******/
USE [ACDW_CLMS_CCACO]
GO
-- Drop Tables
DROP TABLE [adw].[QM_ResultByMember_CL]; 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Create Tables
CREATE TABLE [adw].[QM_ResultByMember_CL](
	[urn] [int] IDENTITY(1,1) NOT NULL,
	[ClientMemberKey] [varchar](50) NOT NULL,
	[QmMsrId] [varchar](20) NOT NULL,
	[QmCntCat] [varchar](10) NOT NULL,
	[QMDate] [date] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateBy] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[urn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [adw].[QM_ResultByMember_CL] ADD  CONSTRAINT [DF_QM_ResultByMbr_CL_QmDate]  DEFAULT (CONVERT([date],getdate())) FOR [QMDate]
GO

ALTER TABLE [adw].[QM_ResultByMember_CL] ADD  CONSTRAINT [DF_QM_ResultByMbr_CL_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

ALTER TABLE [adw].[QM_ResultByMember_CL] ADD  CONSTRAINT [DF_QM_ResultByMbr_CL_CreateBy]  DEFAULT (suser_sname()) FOR [CreateBy]
GO

-- Insert Into Tables
INSERT INTO [adw].[QM_ResultByMember_CL]
           ([ClientMemberKey]
           ,[QmMsrId]
           ,[QmCntCat]
           ,[QMDate]
           )
     SELECT [ClientMemberKey]
			,[QmMsrId]
			,[QmCntCat]
			,[QMDate]
  FROM [adw].[QM_ResultByMember_History]
  WHERE QMDATE = (SELECT max(qmdate)
    FROM [adw].[QM_ResultByMember_History])
GO
