CREATE view [z_vw_Annual_visit_Assignment] 
as 
select a.HICN ,a.mbr_type,  case when b.had_annual is null then 0 else b.had_annual end as had_annual,
case when c.had_pcp is null then 0 else c.had_pcp end as had_pcp from (select a.HICN, a.Mbr_Type from Active_Members a ) a 
left join  (select * , 1 as had_annual from vw_Annual_Wellness_Visit) b on a.HICN = b.subscriber_id 
left join  (select * , 1 as had_pcp from vw_pcp_visit) c on a.HICN = c.subscriber_id
