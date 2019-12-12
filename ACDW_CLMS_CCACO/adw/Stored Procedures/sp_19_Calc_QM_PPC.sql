

CREATE procedure [ADW].[sp_19_Calc_QM_PPC]
@years int,
@LOB varchar(20)
as
declare @year int = @years

declare @QM varchar(10) = 'PPC_Pre'
declare @QM2 varchar(10) = 'PPC_Post'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table11 as table (SUBSCRIBER_ID varchar(20), delivery_date Date , firstTrimStart Date, firstTrimEnd Date, postStart Date, postEnd Date)
declare @table22 as table (SUBSCRIBER_ID varchar(20), SEQ_CLAIM_ID varchar(20))

declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))
declare @tablenumtp as table (SUBSCRIBER_ID varchar(20))
declare @tablenump as table (SUBSCRIBER_ID varchar(20))
declare @tablecareopp as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from adw.[tvf_get_active_members2](concat('12/31/',@year)) 


insert into @table11
SELECT distinct subscriber_id, primary_svc_date as delivery_date, dateadd(day, -280,primary_svc_date) as firstTrimStart, dateadd(day, -176,primary_svc_date) as firstTrimEnd
, dateadd(day, 21, primary_svc_date) as postStart, dateadd(day,56, primary_svc_date) as postEnd

	FROM adw.[tvf_get_claims_w_dates]('Deliveries', '', '', concat('11/06/',@year-1), concat('11/05/',@year))
	where subscriber_id not in (SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Non-live Births', '', '', concat('11/06/',@year-1), concat('11/05/',@year)))


insert into @table2
select distinct subscriber_id from @table11


insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID










DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT distinct a.SUBSCRIBER_ID
	FROM adw.[tvf_get_claims_w_dates]('Prenatal Bundled Services', 'Stand Alone Prenatal Visits', '', concat('1/1/',@year-1), concat('12/31/',@year)) a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd

insert into @table22
SELECT distinct a.SUBSCRIBER_ID, SEQ_CLAIM_ID
	FROM adw.[tvf_get_claims_w_dates]('Prenatal Visits', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd

insert into @table2
SELECT distinct a.SUBSCRIBER_ID
	FROM adw.[tvf_get_claims_w_dates]('Obstetric Panel', 'Prenatal Ultrasound', '', concat('1/1/',@year-1), concat('12/31/',@year)) a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd
	where a.SUBSCRIBER_ID in (select distinct subscriber_id from @table22) 
union 
SELECT distinct a.SUBSCRIBER_ID
	FROM adw.[tvf_get_claims_w_dates]('Pregnancy Diagnosis', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd
		where a.SEQ_CLAIM_ID in (select distinct seq_claim_id from @table22) 
union
SELECT distinct a.subscriber_id 
	FROM [adw].[tvf_get_claims_w_dates_5opt]('Toxoplasma Antibody'  ,'Rubella Antibody' ,'Cytomegalovirus Antibody' ,'Herpes Simplex' ,'' , concat('1/1/',@year-1), concat('12/31/',@year))a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd
	where a.SUBSCRIBER_ID in (select distinct subscriber_id from @table22) 
	group by a.subscriber_id 
	having count(distinct value_set_name)>=4

union

SELECT distinct a.subscriber_id 
	FROM [adw].[tvf_get_claims_w_dates_5opt]('Rubella Antibody','ABO' ,'' ,'' ,'' , concat('1/1/',@year-1), concat('12/31/',@year))a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd
	where a.SUBSCRIBER_ID in (select distinct subscriber_id from @table22) 
	group by a.subscriber_id 
	having count(distinct value_set_name)>=2

union

SELECT distinct a.subscriber_id 
	FROM [adw].[tvf_get_claims_w_dates_5opt]('Rubella Antibody','Rh' ,'' ,'' ,'' , concat('1/1/',@year-1), concat('12/31/',@year))a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd
    where a.SUBSCRIBER_ID in (select distinct subscriber_id from @table22) 
	group by a.subscriber_id 
	having count(distinct value_set_name)>=2

union

SELECT distinct a.subscriber_id 
	FROM [adw].[tvf_get_claims_w_dates_5opt]('Rubella Antibody','ABO and Rh' ,'' ,'' ,'' , concat('1/1/',@year-1), concat('12/31/',@year))a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.firstTrimStart and b.firstTrimEnd
	where a.SUBSCRIBER_ID in (select distinct subscriber_id from @table22) 
	group by a.subscriber_id 
	having count(distinct value_set_name)>=2



	

insert into @tablenumt
select * from @table1
union 
select * from @table2






insert into @tablenum
select a.* from @tablenumt a 
intersect select b.* from @tableden  b



insert into @tablecareop
select a.* from @tableden a left join @tablenum b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 



Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop







DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT a.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Postpartum Visits','Cervical Cytology','Postpartum Bundled Services' ,concat('01/01/',@year),concat('12/31/',@year))a
	join @table11 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE between b.postStart and b.postEnd



insert into @tablenumtp
select * from @table1






insert into @tablenump
select a.* from @tablenumtp a 
intersect select b.* from @tableden  b



insert into @tablecareopp
select a.* from @tableden a left join @tablenump b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 



Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM2, 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM2 , 'NUM' ,@RUNDATE,@RUNTIME from @tablenump


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM2 , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareopp