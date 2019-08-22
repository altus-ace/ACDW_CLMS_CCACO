/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view [z_vw_HICN_ER_COgaps]
as 
SELECT  a.[MBI]
      ,a.[HICN]
      ,a.[Fname]
      ,a.[Lname]
      ,a.[Sex]
      ,a.[DOB]
      ,a.[DOD]
      ,a.[CM_Flg]
      ,a.[Mbr_Type]
	 ,b.cnt
	--,c.tot_num_open as num_of_open_co
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_Mbr_Unassigned_Exc_Deaths]a
 join (select z.SUBSCRIBER_ID , count(distinct z.primary_svc_date) as cnt from [ACDW_CLMS_CCACO].[dbo].[vw_AllMbrDetail_ERVisit] z 
  where z.PRIMARY_SVC_DATE between dateadd(month,-12,'2018-09-25') and '2018-09-25' group by z.SUBSCRIBER_ID  )b
   on a.HICN = b.subscriber_id
 join (
   SELECT  zz.clientMemberKey,  sum(zz.[MsrDen]) - sum(zz.[MsrNum]) as tot_num_open
  FROM  [ACDW_CLMS_CCACO].[dbo].[vw_QM_MbrCareOp_Detail] zz
  group by zz.clientMemberKey) c on a.HICN = c.clientMemberKey
