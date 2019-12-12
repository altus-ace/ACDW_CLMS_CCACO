

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view [dbo].[tmp_Rpt_182_Mbr_Practice_Provider_TS] 
as 
SELECT distinct  cast(a.[HICN] as varchar) as HICN
      ,cast(a.[Fname] as varchar) as FirstName
      ,a.[Lname] as LastName
      ,a.[Sex] as Sex
      ,cast(a.[DOB] as date) as DOB
      ,a.[Mbr_Type] 
      ,cast(a.[MBR_YEAR] as int) as Mbr_Year
      ,Cast(a.[MBR_QTR] as int) as [MBR_QTR]
	  ,cast(b.TIN as int) as TIN
	  ,b.TIN_NAME
	  ,cast(c.NPI as int) as NPI
	  ,c.NPI_NAME
FROM [ACDW_CLMS_CCACO].[adw].[Assignable_Member_History] a
LEFT JOIN ACDW_CLMS_CCACO.adw.Member_Practice_History b
 ON b.HICN = a.HICN
LEFT JOIN ACDW_CLMS_CCACO.adw.Member_Provider_History c
 ON c.HICN = a.HICN