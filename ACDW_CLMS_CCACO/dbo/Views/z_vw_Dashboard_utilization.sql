


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view [dbo].[z_vw_Dashboard_utilization]
as
SELECT [MBI]
      ,[HICN]
      ,[FirstName]
      ,[LastName]
      ,[Sex]
      ,[DOB]
      
      ,a.[MBR_YEAR]
      ,a.[MBR_QTR]
    ,(SELECT 
      count(distinct b.[HICN]) 
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_member_demographics_ALL] b where b.npi = a.npi and b.MBR_YEAR = a.MBR_YEAR) as yr_uniq_npi_mbr_cnt
      ,[TIN]
      ,[TIN_NAME]
      ,[NPI]
      ,[NPI_NAME]
	  ,utilization_type
	  ,b.SEQ_CLAIM_ID
	  ,b.PRIMARY_SVC_DATE
  --  ,b.SVC_PROV_NPI
	
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_member_demographics_ALL] a left join (


  select *, year(PRIMARY_SVC_DATE)as MBR_YEAR
  , 
  case when month(primary_svc_date)in (1,2,3) then 1
	   when month(primary_svc_date)in (4,5,6) then 2
	   when month(primary_svc_date)in (7,8,9) then 3
	   when month(primary_svc_date)in (10,11,12) then 4
	   else null end as MBR_QTR, 'ER' as utilization_type
	   from 
  [dbo].[vw_AllMbrDetail_ERVisit] ) b on a.HICN = b.SUBSCRIBER_ID and a.MBR_QTR = b.MBR_QTR and a.MBR_YEAR = b.MBR_YEAR

  union 
  
SELECT [MBI]
      ,[HICN]
      ,[FirstName]
      ,[LastName]
      ,[Sex]
      ,[DOB]
      
      ,a.[MBR_YEAR]
      ,a.[MBR_QTR]
    ,(SELECT 
      count(distinct b.[HICN]) 
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_member_demographics_ALL] b where b.npi = a.npi and b.MBR_YEAR = a.MBR_YEAR) as yr_uniq_npi_mbr_cnt
      ,[TIN]
      ,[TIN_NAME]
      ,[NPI]
      ,[NPI_NAME]
	  ,utilization_type
	  ,b.SEQ_CLAIM_ID
	  ,b.PRIMARY_SVC_DATE
	--  	  ,b.SVC_PROV_NPI
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_member_demographics_ALL] a left join (


  select *, year(PRIMARY_SVC_DATE)as MBR_YEAR
  , 
  case when month(primary_svc_date)in (1,2,3) then 1
	   when month(primary_svc_date)in (4,5,6) then 2
	   when month(primary_svc_date)in (7,8,9) then 3
	   when month(primary_svc_date)in (10,11,12) then 4
	   else null end as MBR_QTR, 'IP' as utilization_type
	   from 
  [dbo].[vw_AllMbrDetail_IPVisit] ) b on a.HICN = b.SUBSCRIBER_ID and a.MBR_QTR = b.MBR_QTR and a.MBR_YEAR = b.MBR_YEAR
   union 
  
SELECT [MBI]
      ,[HICN]
      ,[FirstName]
      ,[LastName]
      ,[Sex]
      ,[DOB]
      
      ,a.[MBR_YEAR]
      ,a.[MBR_QTR]
    ,(SELECT 
      count(distinct b.[HICN]) 
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_member_demographics_ALL] b where b.npi = a.npi and b.MBR_YEAR = a.MBR_YEAR) as yr_uniq_npi_mbr_cnt
      ,[TIN]
      ,[TIN_NAME]
      ,[NPI]
      ,[NPI_NAME]
	  ,utilization_type
	  ,b.SEQ_CLAIM_ID
	  ,b.PRIMARY_SVC_DATE
  --  ,b.SVC_PROV_NPI
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_member_demographics_ALL] a left join (


  select *, year(PRIMARY_SVC_DATE)as MBR_YEAR
  , 
  case when month(primary_svc_date)in (1,2,3) then 1
	   when month(primary_svc_date)in (4,5,6) then 2
	   when month(primary_svc_date)in (7,8,9) then 3
	   when month(primary_svc_date)in (10,11,12) then 4
	   else null end as MBR_QTR, 'PCP' as utilization_type
	   from 
  [dbo].[vw_AllMbrDetail_PCPVisit] ) b on a.HICN = b.SUBSCRIBER_ID and a.MBR_QTR = b.MBR_QTR and a.MBR_YEAR = b.MBR_YEAR
 



