USE [ACDW_CLMS_CCACO]
GO
TRUNCATE TABLE adw.[Member_Practice_History]

INSERT INTO adw.[Member_Practice_History]
           ([MBI]
           ,[HICN]
           ,[FirstName]
           ,[LastName]
           ,[Sex]
           ,[DOB]
           ,[DOD]
           ,[TIN]
           ,[TIN_NAME]
           ,[PCSVS]
           ,[MBR_YEAR]
           ,[MBR_QTR]
           ,[LOAD_DATE]
           ,[LOAD_USER])
     SELECT a.[MBI]
		  ,a.[HICN]
		  ,a.[FirstName]
		  ,a.[LastName]
		  ,LEFT(a.[Sex],1)
		  ,CAST (a.[DOB] as date)
		  ,a.[DOD]
		  ,a.[TIN]
		  ,(SELECT TOP 1 b.PCP_PRACTICE_NAME FROM lst.LIST_PCP_PRACTICE b WHERE a.TIN = b.PCP_PRACTICE_TIN) as TIN_NAME
		  ,CAST (a.[PCServices] as int) as PCSVCS
		  ,LEFT(a.[EffQtr],4)
		  ,RIGHT(a.[EffQtr],1)
		  ,CAST(getdate() as date)
		  ,SUSER_NAME()
		FROM ast.[ACE.QASSGNT2] a
		--WHERE a.[EffQtr] = '2018Q3'

GO


