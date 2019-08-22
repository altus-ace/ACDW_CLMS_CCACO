


CREATE procedure  adw.[SP_QM_ART]
as
if OBJECT_ID('tmp_QM_ART_DEN','U') is not null
drop table tmp_QM_ART_DEN

create table tmp_QM_ART_DEN (
member varchar(50)
)
--Denominator:
insert into tmp_QM_ART_DEN
SELECT DISTINCT SUBSCRIBER_ID
FROM (
	select SUBSCRIBER_ID, DOB from adw.tvf_get_active_members(1)
	) A
WHERE datediff(year, DOB, convert(DATE, '12/31/2018', 101)) BETWEEN 18 and 120
intersect 
select distinct  SUBSCRIBER_ID from 
(
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('Outpatient', '', '', '1/1/2018', '11/30/2018') a
join   adw.tvf_get_claims_w_dates('Rheumatoid Arthritis', '', '', '1/1/2018', '11/30/2018')B
			ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
union 
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') a
join   adw.tvf_get_claims_w_dates('Rheumatoid Arthritis', '', '', '1/1/2018', '11/30/2018')B
			ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
join adw.tvf_get_claims_w_dates('Nonacute Inpatient', '', '', '1/1/2018', '11/30/2018') C
            ON A.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID
)X group by SUBSCRIBER_ID 
having count(distinct SEQ_CLAIM_ID)>= 2 
and count(distinct PRIMARY_SVC_DATE)>=2




-----------------numerator
create table tmp_QM_ART_NUM_T (
member varchar(50)
)


if OBJECT_ID('tmp_QM_ART_NUM_T','U') is not null
drop table tmp_QM_ART_NUM_T


create table tmp_QM_ART_NUM_T (
member varchar(50)
)
--Numerator: wellcare visit with pcp measurement year
insert into tmp_QM_ART_NUM_T
SELECT DISTINCT  A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('DMARD', 'DMARD Medications', '', '1/1/2018', '12/31/2018') a





  
if OBJECT_ID('tmp_QM_ART_NUM','U') is not null
drop table tmp_QM_ART_NUM

create table tmp_QM_ART_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_ART_NUM
select distinct * from tmp_QM_ART_NUM_T
intersect 
select distinct * from tmp_QM_ART_DEN







if OBJECT_ID('tmp_QM_ART_NUM','U') is not null
drop table tmp_QM_ART_NUM

create table tmp_QM_ART_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_ART_NUM
select distinct * from tmp_QM_ART_NUM_T
intersect 
select distinct * from tmp_QM_ART_DEN




if OBJECT_ID('tmp_QM_ART_NUM_T','U') is not null
drop table tmp_QM_ART_NUM_T


insert into tmp_QM_MSR_CNT values('ART',  (select count(*) from tmp_QM_ART_DEN), (select count(*) from tmp_QM_ART_NUM),0,convert(date,getdate(),101),NULL,NULL)
