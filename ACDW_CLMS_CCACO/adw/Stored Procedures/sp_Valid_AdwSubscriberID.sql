-- =============================================
-- Author:		gkuhfeldt
-- Create date: 06/04/2019
-- Description:	validate state of Member ID prior to processing any data.
--				Due to CMS processes, the Bene_Hic_Num, comes in 
-- =============================================
CREATE PROCEDURE adw.sp_Valid_AdwSubscriberID	
AS
BEGIN
    	
    DECLARE @MaxSubIdLength INT = -1;
    SELECT @MaxSubIdLength = MAX(LEN(M.SUBSCRIBER_ID)) FROM adw.M_MEMBER_ENR M
    
    SELECT @MaxSubIdLength AS MaxLength_SubscriberID;
    
    SELECT CASE WHEN (@MaxSubIdLength  < (SELECT Max(LEN(H.SUBSCRIBER_ID)) FROM adw.Claims_Headers H)) THEN 'Headers SubscriberId incorrect' 
        ELSE 'Headers Fine'END AS Headers
        , CASE WHEN (@MaxSubIdLength  < (SELECT Max(LEN(H.SUBSCRIBER_ID)) FROM adw.Claims_Diags H)) THEN 'Diags SubscriberId incorrect' 
        ELSE 'Diags Fine'END AS Diags
        , CASE WHEN (@MaxSubIdLength  < (SELECT Max(LEN(H.SUBSCRIBER_ID)) FROM adw.Claims_Procs H)) THEN 'Procs SubscriberId incorrect' 
        ELSE 'Procs Fine'END AS Procs
        -- Members are more complicated. Must chec if ther
        , CASE WHEN ((SELECT COUNT(*) mbrCnt
    			 FROM (SELECT transTable.SUBSCRIBER_ID OriginalSubId, transTable.NewSubId, m.SUBSCRIBER_ID MbrSubID
    				    FROM (SELECT SUBSCRIBER_ID, LenSubID, SUBSTRING(s.SUBSCRIBER_ID,12, len(s.subscriber_id)) NewSubId
    					   FROM (SELECT len(subscriber_id) LenSubID, SUBSCRIBER_ID
    							 FROM adw.Claims_Member m) s
    				    WHERE s.LenSubID > 11) transTable
    			 LEFT JOIN adw.Claims_Member m  ON transTable.NewSubId = m.SUBSCRIBER_ID
    			 WHERE m.SUBSCRIBER_ID is null) mbrs) 
    			 >= 1) THEN 'Members SubscriberId incorrect' ELSE 'Members fine' END as Mbrs
    
    -- IF the above returns Rows needing attention then run the code below.
     --Fix members who are not in with correct Hicn for subscriber_id, 
        -- CMS Load MBI+HICN into the HICN in current version

END
