USE [ACDW_CLMS_CCACO]
GO
TRUNCATE TABLE adw.[Member_Provider_History]

INSERT INTO adw.[Member_Provider_History]
           ([MBI]
           ,[HICN]
           ,[FirstName]
           ,[LastName]
           ,[Sex]
           ,[DOB]
           ,[DOD]
           ,[TIN]
           ,[TIN_NAME]
           ,[NPI]
           ,[NPI_NAME]
		   ,[ACO_NPI]
           ,[MBR_YEAR]
           ,[MBR_QTR]
           ,[LOAD_DATE]
           ,[LOAD_USER])
     SELECT a.[MBI]
		  ,a.[HICN]
		  ,LEFT(a.[FirstName],50)
		  ,LEFT(a.[LastName],50)
		  ,LEFT(a.[Sex],1)
		  ,CAST(a.[DOB] as date)
		  ,CAST(a.[DOD] as date)
		  ,RTRIM(a.[TIN])
		  ,(SELECT TOP 1 LEFT(b.[PCP_PRACTICE_NAME],100) FROM lst.LIST_PCP_PRACTICE b WHERE a.TIN = b.[PCP_PRACTICE_TIN]) as PRACT_NAME
		  ,RTRIM(a.[NPI])
		  ,(SELECT TOP 1 b.[PCP_LAST_NAME]+', '+b.[PCP_FIRST_NAME] FROM lst.LIST_PCP b WHERE a.NPI = b.[PCP_NPI]) as PCP_NAME
   		  ,(SELECT TOP 1 LEFT(b.[PCP_NPI],1) FROM lst.LIST_PCP b WHERE a.NPI = b.[PCP_NPI]) as ACO_NPI  
			,LEFT(a.[EffQtr],4)
		  ,RIGHT(a.[EffQtr],1)
		  ,CAST(getdate() as date)
		  ,SUSER_NAME()
	  FROM ast.[ACE.QASSGNT4] a 
	  LEFT JOIN lst.[LIST_PCP] b
	  ON a.NPI = b.PCP_NPI
	  --WHERE a.[EffQtr] = '2018Q3'

GO


