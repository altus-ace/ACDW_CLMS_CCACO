
--Validation for Membership Count

DECLARE @Loaddate DATE = (SELECT MAX(LOADDATE) FROM [adi].[ALR.QASSGNT1] )
DECLARE @Load_date DATE = (SELECT MAX(LOAD_DATE) FROM [ast].[QASSGNT1] )
DECLARE @Load_date1 DATE = (SELECT MAX(LOAD_DATE) FROM [ast].[ACE.QASSGNT2] )

SELECT count(*)RwnCnt   FROM [adi].[ALR.QASSGNT1]  WHERE LOADDATE = @Loaddate
SELECT count(*) RwnCnt FROM [ast].[QASSGNT1]  WHERE LOAD_DATE = @Load_date


SELECT count(*)  RwnCnt FROM [adi].[ALR.QASSGNT2]  WHERE LOADDATE = @Loaddate
SELECT count(*) RwnCnt FROM [ast].[ACE.QASSGNT2]  WHERE LOAD_DATE = @Load_date1

SELECT count(*)  RwnCnt FROM [adi].[ALR.QASSGNT4]  WHERE LOADDATE = @Loaddate
SELECT count(*) RwnCnt FROM [ast].[ACE.QASSGNT4]  WHERE LOAD_DATE = @Load_date1

 


