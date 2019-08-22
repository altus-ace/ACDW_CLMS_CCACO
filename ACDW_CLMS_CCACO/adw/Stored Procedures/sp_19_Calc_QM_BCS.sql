
CREATE procedure [adw].[sp_19_Calc_QM_BCS]
@years int,
@LOB varchar(20)
as
DECLARE @year int = @years

DECLARE @QM Varchar(10) = 'BCS'
DECLARE @RUNDATE Date = getdate()
DECLARE @RUNTIME Datetime = getdate()

DECLARE @table1 as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @table2 as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @tableden as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @tablenumt as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @tablenum as Table (SUBSCRIBER_ID Varchar(20))
DECLARE @tablecareop as Table (SUBSCRIBER_ID Varchar(20))


INSERT INTO @table1
SELECT SUBSCRIBER_ID FROM 
adw.tvf_get_active_members2(concat('12/31/',@year)) 
WHERE GENDER = 'F' and AGE between 50 and 74 

INSERT INTO @tableden 
SELECT a.* FROM @table1 a 

DELETE FROM @table1
DELETE FROM @table2

INSERT INTO @table1 
SELECT SUBSCRIBER_ID FROM adw.tvf_get_claims_w_dates('Mammography','' ,'',concat('10/1/',@year-2),concat('12/31/',@year))

INSERT INTO @tablenumt
SELECT * FROM @table1


INSERT INTO @tablenum
SELECT a.* FROM @tablenumt a 
INTERSECT SELECT b.* FROM @tableden  b

INSERT INTO @tablecareop
SELECT a.* FROM @tableden a left join @tablenum b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID WHERE b.SUBSCRIBER_ID is null 


INSERT INTO adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
SELECT *, @QM , 'DEN' ,@RUNDATE ,@RUNTIME FROM @tableden


INSERT INTO adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
SELECT *, @QM , 'NUM' ,@RUNDATE,@RUNTIME FROM @tablenum


INSERT INTO adw.QM_ResultByMember_History([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
SELECT *, @QM , 'COP' ,@RUNDATE ,@RUNTIME FROM @tablecareop
