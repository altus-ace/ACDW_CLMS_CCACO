CREATE PROCEDURE [adw].[ME_LoadPrep]
AS
    /* validate load counts */
    SELECT convert(date, createdate) LoadDate, count(*) cntCclf1
    FROM adi.CCLF1 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) desc
    
    SELECT convert(date, createdate) LoadDate, count(*) cntCclf2
    FROM adi.CCLF2 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    
    SELECT convert(date, createdate) LoadDate, count(*) cntCclf3
    FROM adi.CCLF3 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    
    SELECT convert(date, createdate) LoadDate, count(*) cntCclf4
    FROM adi.CCLF4 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    
    SELECT convert(date, createdate) LoadDate, count(*) cntCclf5
    FROM adi.CCLF5 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) desc
    
    /*SELECT --convert(date, createdate), count(*)    
    FROM adi.CCLF8 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    */
    
    /*
    SELECT convert(date, createdate), count(*)
    FROM adi.CCLF9 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    */
    
    
    /* UPdate Stats */
    
    EXEC sp_updatestats;
    
    
    /* Backup CCACO prior to process */
    DECLARE @nvDate NVARCHAR(10) = REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 102), '.', '');
    DECLARE @BkName NVARCHAR(100) = N'H:\ACECAREDW\PreModelLoad_ACDW_CLMS_CCACO_'+ @nvDate + '.bak' ;
    SELECT @BkName
    
    BACKUP DATABASE ACDW_CLMS_CCACO
        TO  DISK = @bkName
        WITH COPY_ONLY
        , NOFORMAT
        , NOINIT
        ,  NAME = N'ACDW_CLMS_CCACO-Full Database Backup'
        , SKIP
        , NOREWIND
        , NOUNLOAD
        , COMPRESSION
        ,  STATS = 10
