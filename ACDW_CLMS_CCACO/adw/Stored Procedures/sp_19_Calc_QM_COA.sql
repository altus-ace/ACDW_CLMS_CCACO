CREATE procedure adw.[sp_19_Calc_QM_COA]
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QM1 varchar(10) = 'COA_ACP'
declare @QM2 varchar(10) = 'COA_FSA'
declare @QM3 varchar(10) = 'COA_PA'
declare @QM4 varchar(10) = 'COA_MR'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt1 as table (SUBSCRIBER_ID varchar(20))
declare @tablenum1 as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop1 as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt2 as table (SUBSCRIBER_ID varchar(20))
declare @tablenum2 as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop2 as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt3 as table (SUBSCRIBER_ID varchar(20))
declare @tablenum3 as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop3 as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt4 as table (SUBSCRIBER_ID varchar(20))
declare @tablenum4 as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop4 as table (SUBSCRIBER_ID varchar(20))

insert into @table1
select SUBSCRIBER_ID from 
adw.tvf_get_active_members2(concat('12/31/',@year)) 
where AGE between 66 and 120





insert into @tableden 
select a.* from @table1 a 









DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.SUBSCRIBER_ID
FROM adw.tvf_get_claims_w_dates('Advance Care Planning', '', '',  concat('1/1/',@year), concat('12/31/',@year)) A



insert into @tablenumt1
select * from @table1


insert into @tablenum1
select a.* from @tablenumt1 a 
intersect select b.* from @tableden  b



insert into @tablecareop1
select a.* from @tableden a left join @tablenum1 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM1 , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM1 , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum1


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM1 , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop1







DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.SUBSCRIBER_ID
FROM adw.tvf_get_claims_w_dates('Functional Status Assessment', '', '',  concat('1/1/',@year), concat('12/31/',@year)) A
left join 
adw.tvf_get_claims_w_dates('Acute Inpatient', 'Acute Inpatient POS', '',  concat('1/1/',@year), concat('12/31/',@year)) B on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID where b.SEQ_CLAIM_ID is null 

insert into @tablenumt2
select * from @table1


insert into @tablenum2
select a.* from @tablenumt2 a 
intersect select b.* from @tableden  b



insert into @tablecareop2
select a.* from @tableden a left join @tablenum2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM2 , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM2 , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum2


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM2 , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop2









DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.SUBSCRIBER_ID
FROM adw.tvf_get_claims_w_dates('Pain Assessment', '', '',  concat('1/1/',@year), concat('12/31/',@year)) A
left join 
adw.tvf_get_claims_w_dates('Acute Inpatient', 'Acute Inpatient POS', '',  concat('1/1/',@year), concat('12/31/',@year)) B on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID where b.SEQ_CLAIM_ID is null 

insert into @tablenumt3
select * from @table1


insert into @tablenum3
select a.* from @tablenumt3 a 
intersect select b.* from @tableden  b



insert into @tablecareop3
select a.* from @tableden a left join @tablenum3 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM3 , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM3 , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum3


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM3 , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop3






DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.SUBSCRIBER_ID
FROM adw.tvf_get_claims_w_dates('Transitional Care Management Services', '', '',  concat('1/1/',@year), concat('12/31/',@year)) A
left join 
adw.tvf_get_claims_w_dates('Acute Inpatient', 'Acute Inpatient POS', '',  concat('1/1/',@year), concat('12/31/',@year)) B on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID where b.SEQ_CLAIM_ID is null 

insert into @table2 
SELECT DISTINCT A.SUBSCRIBER_ID
FROM adw.tvf_get_claims_w_dates('Medication Review', '', '',  concat('1/1/',@year), concat('12/31/',@year)) A
join adw.tvf_get_claims_w_dates('Medication List', '', '',  concat('1/1/',@year), concat('12/31/',@year)) B on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
left join adw.tvf_get_claims_w_dates('Acute Inpatient', 'Acute Inpatient POS', '',  concat('1/1/',@year), concat('12/31/',@year)) C on a.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID where b.SEQ_CLAIM_ID is null 
--where a.PROV_SPEC in (select * from get_prov_spec) 



insert into @tablenumt4
select * from @table1
union 
select * from @table2


insert into @tablenum4
select a.* from @tablenumt4 a 
intersect select b.* from @tableden  b



insert into @tablecareop4
select a.* from @tableden a left join @tablenum4 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM4 , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM4 , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum4


Insert into adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM4 , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop4
