
CREATE PROCEDURE adw.[SP_QM_PCE_S]
as


if OBJECT_ID('tmp_QM_PCE_S_VIS','U') is not null
drop table tmp_QM_PCE_S_VIS


create table tmp_QM_PCE_S_VIS (
member varchar(50),
claim varchar(50),
EPISODE_DATE date, 
den int, 
primary_svc_date_med date , 
num int
)

insert into tmp_QM_PCE_S_VIS
select a.* , 1 as den , b.PRIMARY_SVC_DATE , case when b.PRIMARY_SVC_DATE is null then 0 else 1 end as num from tmp_QM_PCE_B_TB1 a 
left join ( select * from adw.tvf_get_claims_w_dates('Systemic Corticosteroid Medications', '', '', '1/1/2018', '11/30/2018')) b
on a.member = b.SUBSCRIBER_ID and a.EPISODE_DATE <= b.PRIMARY_SVC_DATE and abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=14 and a.claim <> b.SEQ_CLAIM_ID
where member in (select * from tmp_QM_PCE_B_DEN1) 





if OBJECT_ID('tmp_QM_PCE_S_NUM_T','U') is not null
drop table tmp_QM_PCE_S_NUM_T


create table tmp_QM_PCE_S_NUM_T (
member varchar(50)
)
--Numerator step 1 
insert into tmp_QM_PCE_S_NUM_T
select distinct member from (
select member, sum(den) as den, sum(num) as num , case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end as perc from tmp_QM_PCE_S_VIS group by member
having case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end  =1
)A


  
if OBJECT_ID('tmp_QM_PCE_S_NUM','U') is not null
drop table tmp_QM_PCE_S_NUM

create table tmp_QM_PCE_S_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_PCE_S_NUM
select distinct * from tmp_QM_PCE_S_NUM_T
intersect 
select distinct * from tmp_QM_PCE_B_DEN





insert into tmp_QM_MSR_CNT values('PCE_S',  (select count(*) from tmp_QM_PCE_B_DEN), (select count(*) from tmp_QM_PCE_S_NUM), 0,convert(date,getdate(),101), (select sum(den) from tmp_QM_PCE_S_VIS), (select sum(num) from tmp_QM_PCE_S_VIS))
