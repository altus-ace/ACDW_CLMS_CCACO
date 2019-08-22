CREATE PROCEDURE [adw].[Load_Pdw_00_MasterJob]    
AS 
    -- TO DO: Add calls to the log sp. all the code and tables exist. add before run again.
    
    -- 1.do a backup?
    -- 2.truncate normalized model tables
    -- 3.do setup
    -- 4.execute each table move
    -- 5.validate

    -- clear the temp db file

    -- 1  Do a bckup: This runs a full copy only backup. It will be slow, but it is safe. 
	   --The old bak file will need to be deleted
	   -- if we had large enough log file, we could replace this with transactions. I see benefits and costs.
		  -- benefits: self restoring, transparent error restoration
		  -- costs: no auto alert of failure, Need to set up special case to deal with error when it occurs, this allows for it.
    --EXEC	  adw.AcdwClmsCCACO_ClmsDoFullCopyBackup;

    -- 2. TRUNCATE Normalized Tables: DO NOT MOVE TO PROC, 
	   -- unless you take the backup with it. 
	   -- Best practice is do not delete with out a backup.     This should be hard to run.
    TRUNCATE TABLE adw.Claims_Details;
    TRUNCATE TABLE adw.Claims_Conditions;
    TRUNCATE TABLE adw.Claims_Diags;
    TRUNCATE TABLE adw.Claims_Procs;
    TRUNCATE TABLE adw.Claims_Member;
    TRUNCATE TABLE adw.Claims_Headers;

    --3. If setup is done already this step could be skipped
    EXEC adw.Load_Pdw_SetManagementTables;

    -- 4. Execute TABLE moves.
    EXEC adw.Load_Pdw_11_ClmsHeadersCclf1;
    EXEC adw.Load_Pdw_12_ClmsDetailsCclf2;
    EXEC adw.Load_Pdw_13_ClmsProcsCclf3;
    EXEC adw.Load_Pdw_14_ClmsProcsCclf4;
    EXEC adw.Load_Pdw_15_ClmsMemsCCLF8;
    EXEC adw.Load_Pdw_20_ClmsHdrsCclf5;
    EXEC adw.Load_Pdw_21_ClmsDtlsCclf5;
    EXEC adw.Load_Pdw_22_ClmsDiagsCclf5;

    -- 5. update mbrs assignable
    -- is there a table for member assignable???
    --EXEC adw.InsertMbrEnrFromAssignable 2018, 3; -- year and quarter

    -- 6. Data normalization
    EXEC adw.DataAdj_00_Master;

