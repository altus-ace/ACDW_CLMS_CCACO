

CREATE procedure  adw.[SP_QM_PCE_B]
as

if OBJECT_ID('tmp_QM_PCE_B_DEN1','U') is not null
drop table tmp_QM_PCE_B_DEN1

create table tmp_QM_PCE_B_DEN1 (
member varchar(50)
)

INSERT INTO tmp_QM_PCE_B_DEN1 (member)
SELECT DISTINCT SUBSCRIBER_ID
FROM (
	SELECT SUBSCRIBER_ID
		,DOB
		,datediff(year,DOB, convert(DATE, '01/01/2018', 101)) AS years
	FROM (
		select * from adw.tvf_get_active_members(1) 
	) A) a
WHERE datediff(year, DOB, convert(DATE, '01/01/2018', 101)) BETWEEN 40
		AND 120
;


if OBJECT_ID('tmp_QM_PCE_B_TB1','U') is not null
drop table tmp_QM_PCE_B_TB1

create table tmp_QM_PCE_B_TB1 (
member varchar(50), 
claim varchar(50),
EPISODE_DATE date 
)

INSERT INTO tmp_QM_PCE_B_TB1 
SELECT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE 
FROM (
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
		FROM adw.tvf_get_claims_w_dates('ED', '', '', '1/1/2018', '11/30/2018') a
		join adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', '1/1/2018', '11/30/2018') b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
	except(
			SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('ED', '', '', '1/1/2018', '11/30/2018') a
				join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
			union 
			SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('ED', '', '', '1/1/2018', '11/30/2018') a
				join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') b on ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
					AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
		)
	)A



union
--Den cond 2 and cond 3 direct transfer , a and b are used for acute inpatient stay with the where statement and a and c are used to account for direct transfers: Acute Inpatient Discharge with 3 related lung conditions
(
SELECT DISTINCT 
       A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, case when c.ADMISSION_DATE is null then a.SVC_TO_DATE else c.SVC_TO_DATE end as EpisodeDate
FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') a
     JOIN adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', '1/1/2018', '11/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
     JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                            AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                            AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                            AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
WHERE A.SEQ_CLAIM_ID NOT IN
	(SELECT SEQ_CLAIM_ID
		FROM adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '', '1/1/2018', '11/30/2018') )
		)













if OBJECT_ID('tmp_QM_PCE_B_DEN2','U') is not null
drop table tmp_QM_PCE_B_DEN2

create table tmp_QM_PCE_B_DEN2 (
member varchar(50) 
)

INSERT INTO tmp_QM_PCE_B_DEN2 (member)
select distinct member from tmp_QM_PCE_B_TB1 



if OBJECT_ID('tmp_QM_PCE_B_DEN','U') is not null
drop table tmp_QM_PCE_B_DEN

create table tmp_QM_PCE_B_DEN (
member varchar(50)
)
--Denominator: 40 years or older on jan of meas year
INSERT into tmp_QM_PCE_B_DEN
SELECT member
FROM tmp_QM_PCE_B_DEN1
intersect
SELECT member
FROM tmp_QM_PCE_B_DEN2;

-----------------numerator

--Cynthia recommended the episode date should be the first episode date , since they would be put on a medication and get refills, but another nurse said as long as there is one visit
--coded as for any copd episode, if there is a medication dispensed within 30 days it counts , it's actually by episode visits instead of member





if OBJECT_ID('tmp_QM_PCE_B_VIS','U') is not null
drop table tmp_QM_PCE_B_VIS


create table tmp_QM_PCE_B_VIS (
member varchar(50),
claim varchar(50),
EPISODE_DATE date, 
den int, 
primary_svc_date_med date , 
num int
)

insert into tmp_QM_PCE_B_VIS
select a.* , 1 as den , b.PRIMARY_SVC_DATE , case when b.PRIMARY_SVC_DATE is null then 0 else 1 end as num from tmp_QM_PCE_B_TB1 a 
left join ( select * from adw.tvf_get_claims_w_dates('Bronchodilator Medications', '', '', '1/1/2018', '11/30/2018')) b
on a.member = b.SUBSCRIBER_ID and a.EPISODE_DATE <= b.PRIMARY_SVC_DATE and abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=30 and a.claim <> b.SEQ_CLAIM_ID
where member in (select * from tmp_QM_PCE_B_DEN1) 





if OBJECT_ID('tmp_QM_PCE_B_NUM_T','U') is not null
drop table tmp_QM_PCE_B_NUM_T


create table tmp_QM_PCE_B_NUM_T (
member varchar(50)
)
--Numerator step 1 
insert into tmp_QM_PCE_B_NUM_T
select distinct member from (
select member, sum(den) as den, sum(num) as num , case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end as perc from tmp_QM_PCE_B_VIS group by member
having case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end  =1
)A


  
if OBJECT_ID('tmp_QM_PCE_B_NUM','U') is not null
drop table tmp_QM_PCE_B_NUM

create table tmp_QM_PCE_B_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_PCE_B_NUM
select distinct * from tmp_QM_PCE_B_NUM_T
intersect 
select distinct * from tmp_QM_PCE_B_DEN





insert into tmp_QM_MSR_CNT values('PCE_B',  (select count(*) from tmp_QM_PCE_B_DEN), (select count(*) from tmp_QM_PCE_B_NUM), 0,convert(date,getdate(),101), (select sum(den) from tmp_QM_PCE_B_VIS), (select sum(num) from tmp_QM_PCE_B_VIS))
