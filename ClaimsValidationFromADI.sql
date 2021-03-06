

  SELECT		'CCLF1' As AdiName, FileDate,  COUNT(URN) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF1] GROUP BY		 FileDate
  SELECT		'CCLF2' As AdiName,FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF2] GROUP BY		FileDate
  --SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF3] GROUP BY		FileDate
  SELECT		'CCLF4' As AdiName, FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF4] GROUP BY		FileDate
  --SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF5] GROUP BY		FileDate --
  --SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF6] GROUP BY		FileDate
  --SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF7] GROUP BY		FileDate
  --SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF8] GROUP BY		FileDate
  --SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF9] GROUP BY		FileDate
 



 SELECT 'CCLF1' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(urn) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF1] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
 SELECT 'CCLF2' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(urn) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF2] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
 --SELECT 'CCLF3' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(urn) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF3] Group By  Convert(Date, FileDate) Order By [FileDate]Desc
 SELECT 'CCLF4' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(urn) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF4] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
-- SELECT 'CCLF5' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(urn) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF5] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
 -- SELECT		FileDate, COUNT(FileDate) RwCnt FROM [ACDW_CLMS_CCACO].[adi].[ACO_CCLF5] GROUP BY		FileDate 
 --SELECT 'CCLF6' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(FileDate) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF6] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
 --SELECT 'CCLF7' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(FileDate) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF7] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
 --SELECT 'CCLF8' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(FileDate) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF8] Group By  Convert(Date, FileDate) Order By [FileDate] Desc
 --SELECT 'CCLF9' AS AdiTableName, CONVERT(Date, FileDate)cDate, Count(urn) AS RowCnt FROM  [ACDW_CLMS_CCACO].[adi].[CCLF9] Group By  Convert(Date, FileDate) Order By [FileDate] Desc

 select * from [adi].[CCLF9] order by CreateDate desc
 select * from [adi].[ACO_CCLF9] order by CreateDate desc

 SELECT * FROM  adi.CCLF1 where filedate  = '2019-08-08'

 /*2019-08-08
2019-07-22*/


select CONVERT(Date, max(FileDate))cDate from [ACDW_CLMS_CCACO].[adi].[CCLF1] 


