create procedure [dbo].[z_sp_getAHR] 
 @mbr varchar(30)  


as


select * from [vw_AllMbrDetail] where subscriber_id = @mbr
select distinct svc_prov_npi, LBN, svc_date from [dbo].[vw_AllMbrDetail_LastPCPVisit_CY] where  subscriber_id = @mbr
select * from [vw_QM_CareGap_By_Mbr_With_Desc] where  subscriber_id = @mbr
select distinct primary_svc_date from [dbo].[vw_AllMbrDetail_ERVisit_CY] where  subscriber_id = @mbr
select distinct primary_svc_date from [dbo].[vw_AllMbrDetail_IPVisit_CY] where  subscriber_id = @mbr
select distinct primary_svc_date from [dbo].[vw_AllMbrDetail_AWV_CY] where  subscriber_id = @mbr
select distinct primary_svc_date  from [dbo].[vw_AllMbrDetail_Readmission_CY]where  subscriber_id = @mbr
select diagCode from [dbo].[vw_AllMbrDetail_MissingCodes] where  subscriber_id = @mbr