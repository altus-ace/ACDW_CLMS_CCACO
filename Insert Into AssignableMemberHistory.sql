USE ACDW_CLMS_CCACO
GO
TRUNCATE TABLE adw.[Assignable_Member_History]  

-- Assigned Members
INSERT INTO adw.[Assignable_Member_History]
           ([MBI]
           ,[HICN]
           ,[Fname]
           ,[Lname]
           ,[Sex]
           ,[DOB]
           ,[DOD]
           ,[CM_Flg]
           ,[Mbr_Type]
           ,[MBR_YEAR]
           ,[MBR_QTR]
           ,[LOAD_DATE]
           ,[LOAD_USER])
	SELECT [MBI]
			,[HICN]
			,[FirstName]
			,[LastName]
			,[Sex]
			,[DOB]
			,[DOD]
			,1
			,'A'
			,LEFT(EffQtr,4)
			,RIGHT(EffQtr,1)
			,GETDATE()
			,suser_name()
	FROM   ast.[QASSGNT1] 
	
GO
--Previous join from the from clause
/*FROM ast.[ACE.QASSGNT6] a,  ast.[QASSGNT1] b
	WHERE a.HICN = b.HICN
	AND a.EFFQTR = b.EFFQTR 
	--AND a.EFFQTR = '2018Q3'*/

	/*
-- UnAssigned Members
INSERT INTO adw.[Assignable_Member_History]
           ([MBI]
           ,[HICN]
           ,[Fname]
           ,[Lname]
           ,[Sex]
           ,[DOB]
           ,[DOD]
           ,[CM_Flg]
           ,[Mbr_Type]
           ,[MBR_YEAR]
           ,[MBR_QTR]
           ,[LOAD_DATE]
           ,[LOAD_USER])
	SELECT a.[MBI]--, B.HICN
			,a.[HICN]
			,a.[FirstName]
			,a.[LastName]
			,a.[Sex]
			,a.[DOB]
			,a.[DOD]
			,1
			,'U'
			,LEFT(a.EffQtr,4)
			,RIGHT(a.EffQtr,1)
			,GETDATE()
			,'SNguyen'
	FROM ast.[ACE.QASSGNT6] a LEFT JOIN ast.[QASSGNT1] b
	ON a.HICN = b.HICN AND a.EffQtr = B.EffQtr
	WHERE b.HICN IS NULL */
	--AND a.EFFQTR = '2018Q3'					
GO

