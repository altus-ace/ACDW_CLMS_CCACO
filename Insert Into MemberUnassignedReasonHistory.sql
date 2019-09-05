USE [ACDW_CLMS_CCACO]
GO
TRUNCATE TABLE adw.[Member_UnassignedReason_History]

INSERT INTO adw.[Member_UnassignedReason_History]
           ([MBI]
           ,[HICN]
           ,[Fname]
           ,[Lname]
           ,[Sex]
           ,[DOB]
           ,[DOD]
           ,[Plurality]
           ,[1MthCoverage]
           ,[1MthHealthPlan]
           ,[NotUSResident]
           ,[InOtherSSInitiatives]
           ,[NoPCPVisit]
           ,[MBR_YEAR]
           ,[MBR_QTR]
           ,[LOAD_DATE]
           ,[LOAD_USER])
     SELECT [MBI]
		  ,[HICN]
		  ,[FirstName]
		  ,[LastName]
		  ,LEFT([Sex],1)
		  ,CAST([DOB] as date)
		  ,[DOD]
		  ,[Plurality]
		  ,[1MthCoverage]
		  ,[1MthHealthPlan]
		  ,[NotUSResident]
		  ,[InOtherSSInitiatives]
		  ,[NoPCPVisit]
		  ,LEFT([EffQtr],4)
		  ,RIGHT([EffQtr],1)
		  ,CAST(getdate() as date)
		  ,'Snguyen'
		FROM ast.[ACE.QASSGNT5]
  	  --WHERE [EffQtr] = '2018Q3'

  
GO


