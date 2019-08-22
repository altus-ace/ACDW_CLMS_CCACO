CREATE procedure adw.[sp_19_Calc_QM_SPR]
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QM varchar(10) = 'SPR'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @table3 as table(
member varchar(50), IESD_date date, prior730day date
)
declare @table4 as table(
member varchar(50), IESD_date date
)
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from 
adw.tvf_get_active_members2(concat('1/31/',@year)) 
where AGE BETWEEN 42 AND 120




insert into @table3
select D.SUBSCRIBER_ID,D.EPISODE_DATE, D.prior730days from (select distinct 
C.SUBSCRIBER_ID, C.EPISODE_DATE, dateadd(day,-730,c.EPISODE_DATE) as prior730days
from 
(
select distinct B.SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE, dense_rank() over (partition by SUBSCRIBER_ID order by EPISODE_DATE) as rank 
from 
(
select A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE from (
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('ED', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', concat('7/1/',@year-1), concat('6/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
except (
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('ED', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
union 
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('ED', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) b on  ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
	AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
)
)A
union
--Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
(
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, a.SVC_TO_DATE as EpisodeDate
	FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', concat('7/1/',@year-1), concat('6/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) c
	 on a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.SEQ_CLAIM_ID<> c.SEQ_CLAIM_ID and a.SVC_TO_DATE <=c.ADMISSION_DATE and abs(datediff(day,a.SVC_TO_DATE,c.ADMISSION_DATE))<=1
	where A.SEQ_CLAIM_ID not in (select SEQ_CLAIM_ID from  adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '', concat('7/1/',@year-1), concat('6/30/',@year)) b )
)

)B
)C where C.rank =1 
)D










insert into @table4
select E.SUBSCRIBER_ID,E.EPISODE_DATE from
(select distinct 
C.SUBSCRIBER_ID, C.EPISODE_DATE
from 
(
select distinct B.SUBSCRIBER_ID, SEQ_CLAIM_ID,EPISODE_DATE, dense_rank() over (partition by SUBSCRIBER_ID order by EPISODE_DATE) as rank 
from 
(
select A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE from (
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('ED', '', '', concat('1/1/',@year-100), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis',  concat('1/1/',@year-100), concat('6/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
except
(
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('ED', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
union
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
	FROM adw.tvf_get_claims_w_dates('ED', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) b on ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
					AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
	)
)A
union
--Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
(
SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, a.SVC_TO_DATE as EpisodeDate
	FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) a
	join adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis',  concat('1/1/',@year-100), concat('6/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) c
	 on a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.SEQ_CLAIM_ID<> c.SEQ_CLAIM_ID and a.SVC_TO_DATE <=c.ADMISSION_DATE and abs(datediff(day,a.SVC_TO_DATE,c.ADMISSION_DATE))<=1
	where A.SEQ_CLAIM_ID not in (select SEQ_CLAIM_ID from  adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) b )
) 

)B
)C where C.rank =1 
)E


insert into @tableden 
SELECT a.* from @table1 a join (
select distinct member 
from (
select A.member, case when B.IESD_date <=A.prior730day then 0 else 1 end as is_den from
@table3 A
left join  
@table4 B on A.member = B.member
) A where is_den = 1) b on a.SUBSCRIBER_ID = b.member








DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
select distinct  member from 
(
select distinct A.member , A.IESD_date,
(SELECT count(B.SEQ_CLAIM_ID)
	FROM adw.tvf_get_claims_w_dates('Spirometry', '', '',  concat('1/1/',@year-100), concat('6/30/',@year)) B where A.member =B.SUBSCRIBER_ID  ) as cnt

from (select * from (
select A.member, A.IESD_date,A.prior730day, case when B.IESD_date <=A.prior730day then 0 else 1 end as is_den from
@table3 A
left join  
@table4 B on A.member = B.member
) A where is_den = 1) A
)Z  where cnt >=1




insert into @tablenumt
select * from @table1







insert into @tablenum
select a.* from @tablenumt a 
intersect select b.* from @tableden  b



insert into @tablecareop
select a.* from @tableden a left join @tablenum b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 

Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop
