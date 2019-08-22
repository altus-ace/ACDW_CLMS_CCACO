CREATE PROCEDURE adw.[SP_QM_CDC_E]
as

---- NUMERATOR CALC

if OBJECT_ID('tmp_QM_CDC_E_NUM_T','U') is not null
drop table tmp_QM_CDC_E_NUM_T

create table tmp_QM_CDC_E_NUM_T (
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Diabetic Retinal Screening','' ,'','1/1/2018','12/31/2018')  a
where PROV_SPEC in ('Optometry','Ophthalmology')

--prior year negative result from screening by professional
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Diabetic Retinal Screening','','','1/1/2017','12/31/2017')a
join  (select distinct SEQ_CLAIM_ID from  adw.tvf_get_claims_w_dates('','Diabetic Retinal Screening Negative','','1/1/2017','12/31/2017'))b
on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
where PROV_SPEC in ('Optometry','Ophthalmology')

--prior year diabetes mellitus without comp from screening by professional
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Diabetic Retinal Screening','','','1/1/2017','12/31/2017')a
join  (select distinct SEQ_CLAIM_ID from  adw.tvf_get_claims_w_dates('','Diabetes Mellitus Without Complications','','1/1/2017','12/31/2017'))b
on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
where PROV_SPEC in ('Optometry','Ophthalmology')

--meas year diabetes ret screening with eye care professional value code
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Diabetic Retinal Screening With Eye Care Professional','','','1/1/2018','12/31/2018')a

--prior year diabetes ret screening with eye care professional value code with negative result
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Diabetic Retinal Screening With Eye Care Professional','','','1/1/2017','12/31/2017')a
join  (select distinct SEQ_CLAIM_ID from  adw.tvf_get_claims_w_dates('','Diabetic Retinal Screening Negative','','1/1/2017','12/31/2017'))b
on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID

--meas year screening negative result
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Diabetic Retinal Screening Negative','','','1/1/2018','12/31/2018')a

--unilateral eye enucleation with a bilateral modifier
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation','','','1/1/1900','12/31/2018')a
join  (select distinct SEQ_CLAIM_ID from  adw.tvf_get_claims_w_dates('Bilateral','','','1/1/1900','12/31/2018'))b
on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID

--two unilateral eye enucleation 14 days or more apart
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Left','','','1/1/1900','12/31/2018')a
join  (select distinct * from  adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Left','','','1/1/1900','12/31/2018'))b
on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID and abs(datediff(day,a.PRIMARY_SVC_DATE,b.PRIMARY_SVC_DATE))>=14  

--left and right unilateral eye enucleation 
insert into tmp_QM_CDC_E_NUM_T
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Left','','','1/1/1900','12/31/2018')a
join  (select distinct * from  adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Right','','','1/1/1900','12/31/2018'))b
on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID 



if OBJECT_ID('tmp_QM_CDC_E_NUM','U') is not null
drop table tmp_QM_CDC_E_NUM

create table tmp_QM_CDC_E_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_CDC_E_NUM
select distinct * from tmp_QM_CDC_E_NUM_T
intersect 
select distinct * from tmp_QM_CDC_8_DEN





insert into tmp_QM_MSR_CNT values('CDC_E',  (select count(*) from tmp_QM_CDC_8_DEN), (select count(*) from tmp_QM_CDC_E_NUM), 0,convert(date,getdate(),101),NULL,NULL)
