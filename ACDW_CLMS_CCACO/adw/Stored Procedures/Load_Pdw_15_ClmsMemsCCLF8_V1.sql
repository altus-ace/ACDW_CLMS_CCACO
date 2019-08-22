

CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMemsCCLF8_V1]
AS 
    -- insert Claims.Members
    INSERT INTO adw.Claims_Member
           ([SUBSCRIBER_ID]
           ,[DOB]
           ,[MEMB_LAST_NAME]
           ,[MEMB_MIDDLE_INITIAL]
           ,[MEMB_FIRST_NAME]           
           ,[GENDER]
           ,[MEMB_ZIP]           
           )
    SELECT 
	   m.BENE_HIC_NUM		    as SUBSCRIBER_ID		    
	   ,m.BENE_DOB			    as DOB				    
	   ,m.BENE_LAST_NAME		    as MEMB_LAST_NAME		    
	   ,m.BENE_MIDL_NAME		    as MEMB_MIDDLE_INITIAL	    
	   ,m.BENE_1ST_NAME		    as MEMB_FIRST_NAME	    
	   ,m.BENE_SEX_CD		    as GENDER			    
	   ,m.BENE_ZIP_CD		    as MEMB_ZIP			    
    FROM adi.CCLF8 m
