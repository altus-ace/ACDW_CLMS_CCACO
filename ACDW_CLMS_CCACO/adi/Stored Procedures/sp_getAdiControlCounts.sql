/* cntrol counts */
CREATE PROCEDURE [adi].[sp_getAdiControlCounts]
AS

    SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem, 'CCLF1' AS TblSrc, fileDate, COUNT (*) c1 from adi.CCLF1 GROUP BY FileDate
    UNION
    SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem, 'CCLF2' AS TblSrc, fileDate, COUNT (*) c2 FRom adi.CCLF2 GROUP BY FileDate
    UNION
    SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem, 'CCLF3' AS TblSrc, fileDate, COUNT (*) c3 from adi.CCLF3 GROUP BY FileDate
    UNION
    SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem, 'CCLF4' AS TblSrc, fileDate, COUNT (*) c4 from adi.CCLF4 GROUP BY FileDate
    UNION
    SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem, 'CCLF5' AS TblSrc, fileDate, COUNT (*) c5 from adi.CCLF5 GROUP BY FileDate
    UNION
    SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem, 'CCLF8' AS TblSrc, FileDate, COUNT(*) c8 FROM adi.CCLF8 GROUP BY FileDate
    ORDER BY fileDate desc, tblSrc

/* history table?
SELECT 'DB01.ACDW_CLMS_CCACO' as srcSystem
    , (select COUNT (*) c1 from adi.H_CCLF1) as Cnt_H_Cclf1
     , (select COUNT (*) c2 FRom adi.H_CCLF2) as Cnt_H_Cclf2
     , (select COUNT (*) c3 from adi.H_CCLF3) as Cnt_H_Cclf3
     , (select COUNT (*) c4 from adi.H_CCLF4) as Cnt_H_Cclf4
     , (select COUNT (*) c5 from adi.H_CCLF5) as Cnt_H_Cclf5
     , (select COUNT (*) c8 from adi.H_CCLF8) as Cnt_H_Cclf8



    SELECT 'CCLF1' AS TblSrc, fileDate, COUNT (*) RowCnt from adi.CCLF1 GROUP BY FileDate
    UNION
    select 'CCLF2' AS TblSrc, fileDate, COUNT (*) RowCnt FRom adi.CCLF2 GROUP BY FileDate
    UNION 
    select 'CCLF3' AS TblSrc, fileDate, COUNT (*) RowCnt from adi.CCLF3 GROUP BY FileDate
    UNION 
    select 'CCLF4' AS TblSrc, fileDate, COUNT (*) RowCnt from adi.CCLF4 GROUP BY FileDate
    UNION 
    select 'CCLF5' AS TblSrc, fileDate, COUNT (*) RowCnt from adi.CCLF5 GROUP BY FileDate
    UNION
    SELECT s.TblSrc, s.FileDate, COUNT(*) RowCnt FROM (select 'CCLF8' AS TblSrc, GETDATE() AS fileDate, BENE_HIC_NUM from adi.CCLF8) AS s GROUP BY s.TblSrc, s.fileDate
  */  

