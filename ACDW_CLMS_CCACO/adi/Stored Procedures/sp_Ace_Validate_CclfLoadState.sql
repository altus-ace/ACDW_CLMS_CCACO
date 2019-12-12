
CREATE PROCEDURE [adi].[sp_Ace_Validate_CclfLoadState]
AS
    -- this should have a param to limit the number or rows returned or maybe slice out a time period.
    -- this should also use dynamic sql to generate the  queries, so new tables are maintained.

    select top 10 'cclf0' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf0 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf1' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf1 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf2' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf2 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf3' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf3 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf4' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf4 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf5' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf5 c	group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf6' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.adiCCLF6_SKey)	AS RowCnt from adi.cclf6 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf7' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.adiCCLF7_SKey)	AS RowCnt from adi.cclf7 c  group by convert(date, c.createdate), c.FileDate, c.OriginalFileName    order by cDate desc
    select top 10 'cclf8' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.adiCCLF8_SKey)	AS RowCnt from adi.cclf8 c	group by convert(date, c.createdate), c.FileDate, c.OriginalFileName	order by cDate desc
    select top 10 'cclf9' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclf9 c	group by convert(date, c.createdate), c.FileDate, c.OriginalFileName	order by cDate desc
    select top 10 'cclfB' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclfB c	group by convert(date, c.createdate), c.FileDate, c.OriginalFileName	order by cDate desc
    select top 10 'cclfA' as AdiTableName, c.OriginalFileName,c.FileDate,CONVERT(date, c.createdate)cDate,	  count(c.urn)				AS RowCnt from adi.cclfA c	group by convert(date, c.createdate), c.FileDate, c.OriginalFileName	order by cDate desc