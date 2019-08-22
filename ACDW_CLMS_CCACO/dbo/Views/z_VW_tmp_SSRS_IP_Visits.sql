








CREATE VIEW [dbo].[z_VW_tmp_SSRS_IP_Visits]
AS

select a.vendor_id
,a.subscriber_id
,a.[ADMISSION_DATE] as Admit_date
,a.[SVC_TO_DATE] as Disc_date
,b.lbn_Name as Hospital
 from dbo.vw_AllMbrDetail_ERVisit a
 
 inner join [dbo].[LIST_NPPES] b on b.NPI = a.vendor_ID  

where SUBSCRIBER_ID in ('{9858821310','{9944615146', '047446051A','049521046A','{6054816810','037581666A','041563129A')
