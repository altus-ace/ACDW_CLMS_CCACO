CREATE PROCEDURE adw.Ahr_CalcLoadDataMaster
AS
    -- add Awv, Pcv, IP, ER , RA as stord procs and tmp tables
    -- Inserts missing codes 
    EXEC adw.Ahr_InsertMbrMissingCodes;
