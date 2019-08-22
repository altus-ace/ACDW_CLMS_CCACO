CREATE procedure  adw.[SP_QM_CDC_9]
as


--intersect all numerator conditions
--numerator condition: hba1c test with greater than 9

if OBJECT_ID('tmp_QM_CDC_9_NUM_T','U') is not null
drop table tmp_QM_CDC_9_NUM_T

create table tmp_QM_CDC_9_NUM_T (
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_CDC_9_NUM_T
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', '1/1/2017', '12/31/2018') a
	join (
select  * from (
  select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE,dense_rank() over(partition by SUBSCRIBER_ID order by PRIMARY_SVC_DATE desc) as rank, code
   from (select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE,'HbA1c Level Less Than 7.0' as code from adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0','' ,'','1/1/2018','12/31/2018' ) 
   union 
   select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE,'HbA1c Level Greater Than 9.0' as code from adw.tvf_get_claims_w_dates('','HbA1c Level Greater Than 9.0' ,'','1/1/2018','12/31/2018' ) 
   union  
   select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID,PRIMARY_SVC_DATE,'HbA1c Level 7.0-9.0' as code from adw.tvf_get_claims_w_dates('','' ,'HbA1c Level 7.0-9.0','1/1/2018','12/31/2018' ) 
  )A ) C where rank = 1 and code = 'HbA1c Level Greater Than 9.0'
  )B on A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
--numerator condition union: members with hba1c test but with no results (the most recent one)
union
select distinct SUBSCRIBER_ID 
from (
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID 
from (
SELECT DISTINCT  SUBSCRIBER_ID, SEQ_CLAIM_ID,dense_rank() over(partition by SUBSCRIBER_ID order by PRIMARY_SVC_DATE desc) as rank
	FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', '1/1/2018', '12/31/2018')
	) A where A.rank = 1
except
select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID from adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0','HbA1c Level Greater Than 9.0' ,'HbA1c Level 7.0-9.0','1/1/2018','12/31/2018' ) 
)Z
--numerator condition union: members with no hba1c test 
union 
(
select distinct SUBSCRIBER_ID from adw.M_MEMBER_ENR
except
SELECT DISTINCT  SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', '1/1/2018', '12/31/2018')
	)




	
if OBJECT_ID('tmp_QM_CDC_9_NUM','U') is not null
drop table tmp_QM_CDC_9_NUM

create table tmp_QM_CDC_9_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_CDC_9_NUM
select distinct * from tmp_QM_CDC_9_NUM_T
intersect 
select distinct * from tmp_QM_CDC_8_DEN



insert into tmp_QM_MSR_CNT values('CDC_9',  (select count(*) from tmp_QM_CDC_8_DEN), (select count(*) from tmp_QM_CDC_9_NUM), 0,convert(date,getdate(),101),NULL,NULL)
