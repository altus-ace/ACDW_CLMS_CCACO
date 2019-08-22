CREATE PROCEDURE adw.[SP_QM_CDC_BP]
as

---- NUMERATOR CALC

if OBJECT_ID('tmp_QM_CDC_BP_NUM_T','U') is not null
drop table tmp_QM_CDC_BP_NUM_T

create table tmp_QM_CDC_BP_NUM_T (
member varchar(50)
)

--exampl



--meas year conditions 
insert into tmp_QM_CDC_BP_NUM_T
select distinct SUBSCRIBER_ID from (
--readings that are compliant
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID  from adw.tvf_get_claims_w_dates('Diastolic Less Than 80','Diastolic 80–89' ,'','1/1/2018','12/31/2018' ) 
intersect  
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID from adw.tvf_get_claims_w_dates('Systolic Less Than 140','','','1/1/2018','12/31/2018' ) 
) firsts join (
--most recent bp reading
select distinct  SEQ_CLAIM_ID from (
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID, dense_rank() over (partition by SUBSCRIBER_ID order by PRIMARY_SVC_DATE desc ) as rank from (
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE  from adw.tvf_get_claims_w_dates('Diastolic Less Than 80','Diastolic 80–89' ,'Diastolic Greater Than/Equal To 90','1/1/2018','12/31/2018' ) 
union  
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE  from adw.tvf_get_claims_w_dates('Systolic Less Than 140','Systolic Greater Than/Equal To 140','','1/1/2018','12/31/2018' ) )
b ) c where c.rank =1 ) seconds on firsts.SEQ_CLAIM_ID = seconds.SEQ_CLAIM_ID
--has to be outpatient or nonacute 
join (select distinct SEQ_CLAIM_ID from adw.tvf_get_claims_w_dates('Outpatient','Nonacute Inpatient' ,'','1/1/2018','12/31/2018' ) ) thirds on firsts.SEQ_CLAIM_ID = thirds.SEQ_CLAIM_ID


if OBJECT_ID('tmp_QM_CDC_BP_NUM','U') is not null
drop table tmp_QM_CDC_BP_NUM

create table tmp_QM_CDC_BP_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_CDC_BP_NUM
select distinct * from tmp_QM_CDC_BP_NUM_T
intersect 
select distinct * from tmp_QM_CDC_8_DEN



insert into tmp_QM_MSR_CNT values('CDC_BP',  (select count(*) from tmp_QM_CDC_8_DEN), (select count(*) from tmp_QM_CDC_BP_NUM), 0,convert(date,getdate(),101),NULL,NULL)
