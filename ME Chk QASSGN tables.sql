USE [ACDW_CLMS_CCACO]
GO
/*** Run dts to Insert into ACE.QASSGNTx Tables ***/

SELECT [EffQtr] ,COUNT(HICN) as RecCnt
FROM ast.[ACE.QASSGNT1]
GROUP BY [EffQtr] ORDER BY [EffQtr] DESC

SELECT [EffQtr] ,COUNT(HICN) as RecCnt
FROM ast.[ACE.QASSGNT2]
GROUP BY [EffQtr] ORDER BY [EffQtr] DESC

SELECT [EffQtr] ,COUNT(HICN) as RecCnt
FROM ast.[ACE.QASSGNT4]
GROUP BY [EffQtr] ORDER BY [EffQtr] DESC

SELECT [EffQtr] ,COUNT(HICN) as RecCnt
FROM ast.[ACE.QASSGNT5]
GROUP BY [EffQtr] ORDER BY [EffQtr] DESC

SELECT [EffQtr] ,COUNT(HICN) as RecCnt
FROM ast.[ACE.QASSGNT6]
GROUP BY [EffQtr] ORDER BY [EffQtr] DESC

/*** Run dts to Insert into QASSGNT1 ***/

SELECT [EffQtr] ,COUNT(HICN) as RecCnt
FROM ast.[QASSGNT1]
GROUP BY [EffQtr] ORDER BY [EffQtr] DESC