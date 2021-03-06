/****** Check for number of records by QMDate and CreateDate    ******/
USE [ACDW_CLMS_CCACO]
GO

SELECT [QMDate] ,[CreateDate], COUNT(*) as Cnt
  FROM [adw].[QM_ResultByMember_History]
  GROUP BY [QMDate],[CreateDate]
  ORDER BY [CreateDate]
  GO

/****** Check to see if current load returns the same number of QM as History  ******/

SELECT a.QM, a.ACTIVE,
	(SELECT COUNT(URN)   
	FROM [adw].[QM_ResultByMember_History] b
	WHERE b.QmMsrId = a.QM AND b.QmCntCat = 'DEN'AND b.QMDATE = 
	    (SELECT QMDate FROM
		  (SELECT ROW_NUMBER() OVER (ORDER BY QMDATE DESC) AS Gen_Rank, rh.QMDate
		  FROM (SELECT DISTINCT QMDATE FROM [adw].QM_ResultByMember_History) rh) pqm
		  WHERE pqm.Gen_Rank = 1)
		 ) AS Cur_Den_Cnt, 
	(SELECT COUNT(URN)   
	FROM [adw].[QM_ResultByMember_History] b
	WHERE b.QmMsrId = a.QM AND b.QmCntCat = 'DEN' AND b.QMDATE = 
		(SELECT QMDate FROM
		  (SELECT ROW_NUMBER() OVER (ORDER BY QMDATE DESC) AS Gen_Rank, rh.QMDate
		  FROM (SELECT DISTINCT QMDATE FROM [adw].QM_ResultByMember_History WHERE QmCntCat = 'DEN') rh) pqm
		  WHERE pqm.Gen_Rank = 2)
	) AS Prev_Den_Cnt, 
	(SELECT COUNT(URN)   
	FROM [adw].[QM_ResultByMember_History] b
	WHERE b.QmMsrId = a.QM AND b.QmCntCat = 'DEN' AND b.QMDATE = 
		(SELECT QMDate FROM
		  (SELECT ROW_NUMBER() OVER (ORDER BY QMDATE DESC) AS Gen_Rank, rh.QMDate
		  FROM (SELECT DISTINCT QMDATE FROM [adw].QM_ResultByMember_History WHERE QmCntCat = 'DEN') rh) pqm
		  WHERE pqm.Gen_Rank = 3)
	) AS Prev2_Den_Cnt,
	(SELECT COUNT(URN)   
	FROM [adw].[QM_ResultByMember_History] b
	WHERE b.QmMsrId = a.QM AND b.QmCntCat = 'NUM'AND b.QMDATE = 
	    (SELECT QMDate FROM
		  (SELECT ROW_NUMBER() OVER (ORDER BY QMDATE DESC) AS Gen_Rank, rh.QMDate
		  FROM (SELECT DISTINCT QMDATE FROM [adw].QM_ResultByMember_History) rh) pqm
		  WHERE pqm.Gen_Rank = 1)
		 ) AS Cur_Num_Cnt, 
	(SELECT COUNT(URN)   
	FROM [adw].[QM_ResultByMember_History] b
	WHERE b.QmMsrId = a.QM AND b.QmCntCat = 'NUM'AND b.QMDATE = 
	    (SELECT QMDate FROM
		  (SELECT ROW_NUMBER() OVER (ORDER BY QMDATE DESC) AS Gen_Rank, rh.QMDate
		  FROM (SELECT DISTINCT QMDATE FROM [adw].QM_ResultByMember_History) rh) pqm
		  WHERE pqm.Gen_Rank = 2)
		 ) AS Prev_Num_Cnt  
FROM lst.LIST_QM_Mapping a
ORDER BY a.QM
GO

  
  

/****** Delete / Back out of records per CreateDate  ******/
SELECT *
--DELETE
  FROM [adw].[QM_ResultByMember_History]
  WHERE year([CreateDate]) = 2018
  AND month([CreateDate]) = 10
  AND day([CreateDate]) = 26 
  --AND datepart(hh,[CreateDate]) = 14 --'2018-10-26 14:14:40.250'
  --ORDER BY [CreateDate] ASC
 GO

 /****** Check to M_MEMBER_ENR for just current assignable member  ******/   
SELECT distinct [LOAD_DATE], count(*) as cnt
  FROM [adw].[M_MEMBER_ENR]
  GROUP BY [LOAD_DATE]

SELECT [QmMsrId]
      ,[QmCntCat]
      ,count(urn)
  FROM [ACDW_CLMS_CCACO].[adw].[QM_ResultByMember_CL]
  GROUP BY [QmMsrId]
      ,[QmCntCat]
ORDER BY [QmMsrId]
      ,[QmCntCat]
