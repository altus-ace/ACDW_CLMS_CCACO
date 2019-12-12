


CREATE procedure [ADW].[sp_19_Calc_QM_CHL]
@years int,
@LOB varchar(20)
as
declare @year int = @years

declare @QM varchar(10) = 'CHL'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from adw.[tvf_get_active_members2](concat('12/31/',@year)) 
where  GENDER = 'F' and AGE BETWEEN 16 and 24 


insert into @table2
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Pregnancy', 'Sexual Activity', 'Pregnancy Tests', concat('1/1/',@year), concat('12/31/',@year))
union 
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Contraceptive Medications', '', '', concat('1/1/',@year), concat('12/31/',@year))

insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID










DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Chlamydia Tests', '', '', concat('1/1/',@year), concat('12/31/',@year)) a



insert into @tablenumt
select * from @table1






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