/****** Object:  StoredProcedure [adw].[DataAdj_RevCodeLength]    Script Date: 10/26/2018 3:29:44 PM ******/
CREATE PROCEDURE [adw].[DataAdj_00_Master]
AS

    /* these jobs need to be folded into the ETL to the model. */

    EXEC	  [adw].[DataAdj_DiagDot] ;
    EXEC	  [adw].[DataAdj_DrgCode] ;
    EXEC	  [adw].[DataAdj_RevCodeLength];
    EXEC	  adw.DataAdj_SubscriberId;

