

CREATE procedure  adw.[SP_QM_WC0]
as
if OBJECT_ID('tmp_QM_WC0_DEN','U') is not null
drop table tmp_QM_WC0_DEN

create table tmp_QM_WC0_DEN (
member varchar(50)
)

insert into tmp_QM_WC0_DEN
select distinct SUBSCRIBER_ID --, m_date_of_birth, dateadd(month,15,M_Date_Of_Birth) 
 from (
		select * from adw.tvf_get_active_members(1) 
	) a
	where year(dateadd(month,15,DOB) ) = 2018
	





if OBJECT_ID('tmp_QM_WC0_NUM_T','U') is not null
drop table tmp_QM_WC0_NUM_T

create table tmp_QM_WC0_NUM_T(
member varchar(50)
)



insert into tmp_QM_WC0_NUM_T
select distinct SUBSCRIBER_ID from (
select a.SUBSCRIBER_ID, a.m_date_of_birth, dateadd(month,15,a.M_Date_Of_Birth) as x15_mth,
(select count(distinct SEQ_CLAIM_ID) from adw.tvf_get_claims_w_dates('Well-Care','' ,'','1/1/1900',dateadd(month,15,a.M_Date_Of_Birth) )  b
where PROV_SPEC in ('Family Practice','General Practic','Internal Medici','Pediatrics','Obstetrics & Gy','Nurse Practitio','Physician Assis','Nurse Prac - Me','Family Nurse Pr')
and b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) as num_of_wc_vis
 from (
SELECT distinct SUBSCRIBER_ID, M_Date_Of_Birth, dense_rank() over (partition by SUBSCRIBER_ID order by CAST(STR(MBR_YEAR) + '-' + STR(MBR_MTH) + '-01' AS DATE) desc) as rank
	from adw.M_MEMBER_ENR) a where rank =1 and year(dateadd(month,15,M_Date_Of_Birth) ) = 2018
	)A where A.num_of_wc_vis = 0





  
if OBJECT_ID('tmp_QM_WC0_NUM','U') is not null
drop table tmp_QM_WC0_NUM

create table tmp_QM_WC0_NUM(
member varchar(50)
)





--meas year screening by professional
insert into tmp_QM_WC0_NUM
select distinct * from tmp_QM_WC0_NUM_T
intersect 
select distinct * from tmp_QM_WC0_DEN




insert into tmp_QM_MSR_CNT values('WC0',  (select count(*) from tmp_QM_WC0_DEN), (select count(*) from tmp_QM_WC0_NUM), 0,convert(date,getdate(),101),NULL,NULL)
