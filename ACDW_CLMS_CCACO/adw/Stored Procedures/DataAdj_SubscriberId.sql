CREATE PROCEDURE adw.DataAdj_SubscriberId  
AS 

    BEGIN TRAN ClmsMbr;

	   MERGE adw.Claims_member TRG
	   USING (--SELECT all mbrs Sub iD, and Calc new sub ID, where it doesnt join clmsMember	   
	   	   SELECT SUBSCRIBER_ID, LenSubID, SUBSTRING(s.SUBSCRIBER_ID,12, len(s.subscriber_id)) NewSubId
	   		  FROM (SELECT len(subscriber_id) LenSubID, SUBSCRIBER_ID
	   				FROM adw.Claims_Member m
	   				    ) s
	   		  WHERE s.LenSubID > 11
	   	   )src
	   ON TRG.SubScriber_id = SRC.Subscriber_ID
	   WHEN MATCHED THEN 
	       UPDATE SET TRG.Subscriber_ID = SRC.NewSubId
	       ;
    COMMIT TRAN ClmsMbr;

    -- Diags
    
    BEGIN TRAN ClmsDg;
    
    MERGE adw.Claims_Diags TRG
    USING (SELECT URN, SUBSCRIBER_ID, LenSubID, SUBSTRING(s.SUBSCRIBER_ID,12, len(s.subscriber_id)) NewSubId
    	   FROM (SELECT URN, len(subscriber_id) LenSubID, SUBSCRIBER_ID
    	   	   FROM adw.Claims_Diags m) s
    	   WHERE s.LenSubID > 11) SRC
    ON TRG.URN = SRC.URN
    WHEN MATCHED THEN 
        UPDATE SET TRG.Subscriber_ID = SRC.NewSubID
        ;
    
    --ROLLBACK TRAN ClmSDg;
    COMMIT TRAN ClmsDg;
    
    --Procs
    BEGIN TRAN ClmsPrc;
    
    MERGE adw.Claims_Procs TRG
    USING (SELECT URN, SUBSCRIBER_ID, LenSubID, SUBSTRING(s.SUBSCRIBER_ID,12, len(s.subscriber_id)) NewSubId
    	   FROM (SELECT URN, len(subscriber_id) LenSubID, SUBSCRIBER_ID
    		  	   FROM adw.Claims_Procs m) s
    	   WHERE s.LenSubID > 11) SRC
    ON TRG.URN = SRC.URN
    WHEN MATCHED THEN 
        UPDATE SET TRG.Subscriber_ID = SRC.NewSubID
        ;
    
    --ROLLBACK TRAN ClmsPrc;
    COMMIT TRAN ClmsPrc;
    
    --Hdrs
    BEGIN TRAN ClmsHdrs;
    
    MERGE adw.Claims_Headers TRG
    USING (SELECT s.SEQ_CLAIM_ID, SUBSCRIBER_ID, LenSubID, SUBSTRING(s.SUBSCRIBER_ID,12, len(s.subscriber_id)) NewSubId
    	   FROM (SELECT m.SEQ_CLAIM_ID, len(m.subscriber_id) LenSubID, m.SUBSCRIBER_ID	   
    		  	   FROM adw.Claims_Headers m) s
    	   WHERE s.LenSubID > 11) SRC
    ON TRG.SEQ_CLAIM_ID = SRC.SEQ_CLAIM_ID
    WHEN MATCHED THEN 
        UPDATE SET TRG.Subscriber_ID = SRC.NewSubID
        ;
    
    --ROLLBACK TRAN ClmsHdrs;
    COMMIT TRAN ClmsHdrs;
