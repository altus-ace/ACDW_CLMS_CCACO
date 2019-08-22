CREATE procedure adw.[sp_19_Calc_QM_CDC_N]
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QM varchar(10) = 'CDC_N'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select distinct a.SUBSCRIBER_ID from 
adw.tvf_get_active_members2(concat('12/31/',@year)) a join (SELECT DISTINCT SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '',  concat('1/1/',@year), concat('12/31/',@year))) b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
where AGE  BETWEEN 18 AND 75



insert into @table2
SELECT DISTINCT SUBSCRIBER_ID --, count(distinct SEQ_CLAIM_ID), count(distinct PRIMARY_SVC_DATE)
		FROM (
			SELECT A.*
			FROM (
				SELECT SUBSCRIBER_ID
					,SEQ_CLAIM_ID
					,PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('Outpatient', 'ED', 'Nonacute Inpatient',  concat('1/1/',@year-1), concat('12/31/',@year))
				
				UNION
				
				SELECT SUBSCRIBER_ID
					,SEQ_CLAIM_ID
					,PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('Observation', '', '',  concat('1/1/',@year-1), concat('12/31/',@year))
				) A
			INNER JOIN (
				SELECT SUBSCRIBER_ID
					,SEQ_CLAIM_ID
					,PRIMARY_SVC_DATE
				FROM adw.tvf_get_claims_w_dates('Diabetes', '', '',  concat('1/1/',@year-1), concat('12/31/',@year))
				) B
				ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
			) C
		GROUP BY SUBSCRIBER_ID
		HAVING (count(DISTINCT SEQ_CLAIM_ID) >= 2)
			AND (count(DISTINCT PRIMARY_SVC_DATE) >= 2)


insert into @table2
SELECT DISTINCT A.SUBSCRIBER_ID--, A.SEQ_CLAIM_ID
		FROM adw.tvf_get_claims_w_dates('Acute Inpatient', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) A join adw.tvf_get_claims_w_dates('Diabetes', '', '',  concat('1/1/',@year-1), concat('12/31/',@year)) B
		on A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID




insert into @table2
SELECT DISTINCT SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('Diabetes Medications', '', '',  concat('1/1/',@year-1), concat('12/31/',@year))



insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID










DELETE FROM @table1
DELETE FROM @table2

insert into @table1 
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('Urine Protein Tests','Nephropathy Treatment' ,'CKD Stage 4', concat('1/1/',@year), concat('12/31/',@year))  a

insert into @table1 
select distinct a.SUBSCRIBER_ID from adw.tvf_get_claims_w_dates('ESRD','Kidney Transplant' ,'ACE Inhibitor/ARB Medications', concat('1/1/',@year), concat('12/31/',@year))  a

insert into @table1 
select distinct a.SUBSCRIBER_ID from adw.tvf_get_provspec(39,'','','','','') a where year(a.PRIMARY_SVC_DATE) = 2018






insert into @tablenumt
select distinct * from @table1





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
