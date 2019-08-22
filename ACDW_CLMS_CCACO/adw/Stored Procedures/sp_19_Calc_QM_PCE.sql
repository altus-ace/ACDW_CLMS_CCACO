CREATE procedure adw.[sp_19_Calc_QM_PCE]
@years int,
@LOB varchar(20)
as
declare @year int = @years

declare @QMB varchar(10) = 'PCE_B'
declare @QMS varchar(10) = 'PCE_S'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20),SEQ_CLAIM_ID varchar(50),EPISODE_DATE date )
declare @table3 as table (SUBSCRIBER_ID varchar(20))
declare @table4 as table (
SUBSCRIBER_ID varchar(50),
claim varchar(50),
EPISODE_DATE date, 
den int, 
primary_svc_date_med date , 
num int
)
declare @table5 as table (
SUBSCRIBER_ID varchar(50),
claim varchar(50),
EPISODE_DATE date, 
den int, 
primary_svc_date_med date , 
num int
)
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumtB as table (SUBSCRIBER_ID varchar(20))
declare @tablenumB as table (SUBSCRIBER_ID varchar(20))
declare @tablecareopB as table (SUBSCRIBER_ID varchar(20))
declare @tablenumtS as table (SUBSCRIBER_ID varchar(20))
declare @tablenumS as table (SUBSCRIBER_ID varchar(20))
declare @tablecareopS as table (SUBSCRIBER_ID varchar(20))

insert into @table1
select SUBSCRIBER_ID from 
adw.tvf_get_active_members2(concat('1/1/',@year)) 
where AGE  BETWEEN 40 AND 120
;


insert into @table2
SELECT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE as EPISODE_DATE 
FROM (
	SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
		FROM adw.tvf_get_claims_w_dates('ED', '', '',  concat('1/1/',@year), concat('11/30/',@year)) a
		join adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', concat('1/1/',@year), concat('11/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	--exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
	except(
			SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('ED', '', '', concat('1/1/',@year), concat('11/30/',@year)) a
				join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('1/1/',@year), concat('11/30/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
			union 
			SELECT DISTINCT A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, A.PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('ED', '', '', concat('1/1/',@year), concat('11/30/',@year)) a
				join adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('1/1/',@year), concat('11/30/',@year)) b on ( abs(DATEDIFF(day,b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <=1) and A.SUBSCRIBER_ID = B.SUBSCRIBER_ID 
					AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
		)
	)A



union
--Den cond 2 and cond 3 direct transfer , a and b are used for acute inpatient stay with the where statement and a and c are used to account for direct transfers: Acute Inpatient Discharge with 3 related lung conditions
(
SELECT DISTINCT 
       A.SUBSCRIBER_ID, A.SEQ_CLAIM_ID, case when c.ADMISSION_DATE is null then a.SVC_TO_DATE else c.SVC_TO_DATE end as EpisodeDate
FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('1/1/',@year), concat('11/30/',@year)) a
     JOIN adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis',concat('1/1/',@year), concat('11/30/',@year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
     JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('1/1/',@year), concat('11/30/',@year)) c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                            AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                            AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                            AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
WHERE A.SEQ_CLAIM_ID NOT IN
	(SELECT SEQ_CLAIM_ID
		FROM adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '', concat('1/1/',@year), concat('11/30/',@year)) )
		)



insert into @table3
select distinct SUBSCRIBER_ID from @table2

insert into @tableden 
select a.* from @table1 a join @table3 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID






DELETE FROM @table1
DELETE FROM @table3 


insert into @table4
select a.* , 1 as den , b.PRIMARY_SVC_DATE , case when b.PRIMARY_SVC_DATE is null then 0 else 1 end as num from @table2 a 
left join ( select * from adw.tvf_get_claims_w_dates('Bronchodilator Medications', '', '', concat('1/1/',@year), concat('11/30/',@year))) b
on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.EPISODE_DATE <= b.PRIMARY_SVC_DATE and abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=30 and a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID








insert into @tablenumtB
select distinct SUBSCRIBER_ID from (
select SUBSCRIBER_ID, sum(den) as den, sum(num) as num , case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end as perc from @table4 group by SUBSCRIBER_ID
having case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end  =1
)A







insert into @tablenumB
select a.* from @tablenumtB a 
intersect select b.* from @tableden  b



insert into @tablecareopB
select a.* from @tableden a left join @tablenumB b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 

select *, concat(@QMB, '_DEN') ,@RUNDATE ,@RUNTIME , (select sum(b.den) from @table4 b where b.SUBSCRIBER_ID = a.SUBSCRIBER_ID)from @tableden a

select *, concat(@QMB, '_NUM') ,@RUNDATE,@RUNTIME, (select sum(b.num) from @table4 b where b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) from @tablenumB a

select *, concat(@QMB, '_COP') ,@RUNDATE ,@RUNTIME from @tablecareopB




Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMB, 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMB, 'NUM' ,@RUNDATE,@RUNTIME from @tablenumB


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMB, 'COP' ,@RUNDATE ,@RUNTIME from @tablecareopB







insert into @table5
select a.* , 1 as den , b.PRIMARY_SVC_DATE , case when b.PRIMARY_SVC_DATE is null then 0 else 1 end as num from @table2 a 
left join ( select * from adw.tvf_get_claims_w_dates('Systemic Corticosteroid Medications', '', '', concat('1/1/',@year), concat('11/30/',@year))) b
on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.EPISODE_DATE <= b.PRIMARY_SVC_DATE and abs(datediff(day,a.EPISODE_DATE , b.PRIMARY_SVC_DATE))<=14 and a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID







insert into @tablenumtS
select distinct SUBSCRIBER_ID from (
select SUBSCRIBER_ID, sum(den) as den, sum(num) as num , case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end as perc from @table5 group by SUBSCRIBER_ID
having case when sum(den)= 0 then 0 else convert(float,sum(num))/sum(den) end  =1
)A







insert into @tablenumS
select a.* from @tablenumtS a 
intersect select b.* from @tableden  b



insert into @tablecareopS
select a.* from @tableden a left join @tablenumS b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 

select *, concat(@QMS, '_DEN') ,@RUNDATE ,@RUNTIME , (select sum(b.den) from @table4 b where b.SUBSCRIBER_ID = a.SUBSCRIBER_ID)from @tableden a

select *, concat(@QMS, '_NUM') ,@RUNDATE,@RUNTIME, (select sum(b.num) from @table4 b where b.SUBSCRIBER_ID = a.SUBSCRIBER_ID) from @tablenumS a

select *, concat(@QMS, '_COP') ,@RUNDATE ,@RUNTIME from @tablecareopS





Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMS , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMS , 'NUM' ,@RUNDATE,@RUNTIME from @tablenumS


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMS , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareopS
