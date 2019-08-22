CREATE procedure adw.[sp_19_Calc_QM_CCS]
@years int,
@LOB varchar(20)
as
declare @year int = @years

declare @QM varchar(10) = 'CCS'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from 
adw.tvf_get_active_members2(concat('12/31/',@year)) 
where GENDER = 'F' and AGE between 24 and 64 




insert into @tableden 
select a.* from @table1 a 









DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('Cervical Cytology', '', '', concat('1/1/',@year-2), concat('12/31/',@year)) a


insert into @table2 
select SUBSCRIBER_ID from 
adw.tvf_get_active_members2(concat('12/31/',@year)) 
where GENDER = 'F' and AGE between 30 and 64 
intersect 
select distinct A.SUBSCRIBER_ID
from adw.tvf_get_claims_w_dates('Cervical Cytology','' ,'',concat('1/1/',@year-4),concat('12/31/',@year)) A  join 
adw.tvf_get_claims_w_dates('HPV Tests','' ,'',concat('1/1/',@year-4),concat('12/31/',@year) )  B 
on abs((DATEdiff(d,B.PRIMARY_SVC_DATE,A.PRIMARY_SVC_DATE)))<=4
and A.SUBSCRIBER_ID =  B.SUBSCRIBER_ID 
and case when A.[SUBSCRIBER_ID] in (select B.SUBSCRIBER_ID from adw.tvf_get_age2(30,64,CONVERT(varchar, A.PRIMARY_SVC_DATE,101))B ) then 1 else 0 end = 1
 






insert into @tablenumt
select * from @table1
union 
select * from @table2






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
