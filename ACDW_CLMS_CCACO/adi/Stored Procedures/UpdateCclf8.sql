CREATE PROCEDURE adi.UpdateCclf8
AS 
    MERGE adi.CCLF8 trg
    USING (SELECT u.BENE_HIC_NUM, 
               u.BENE_FIPS_STATE_CD, 
               u.BENE_FIPS_CNTY_CD, 
               u.BENE_ZIP_CD, 
               u.BENE_DOB, 
               u.BENE_SEX_CD, 
               u.BENE_RACE_CD, 
               u.BENE_AGE, 
               u.BENE_MDCR_STUS_CD, 
               u.BENE_DUAL_STUS_CD, 
               u.BENE_DEATH_DT, 
               u.BENE_RNG_BGN_DT, 
               u.BENE_RNG_END_DT, 
               u.BENE_1ST_NAME, 
               u.BENE_LAST_NAME, 
               u.BENE_MIDL_NAME, 
               u.BENE_ORGNL_ENTLMT_RSN_CD, 
               u.BENE_ENTLMT_BUYIN_IND, 
               u.SrcFileName, 
               u.FileDate, 
               u.OriginalFileName, 
               u.CreateDate, 
               u.CreateBy, 
               u.AstCreatedDate, 
               u.AstCreatedBy
        FROM [ast].[CCLF8_Updates] u
        ) AS src
    ON trg.BENE_HIC_NUM = src.BENE_HIC_NUM
    WHEN MATCHED THEN  update
        SET 
        	 trg.[BENE_FIPS_STATE_CD]		 = src.[BENE_FIPS_STATE_CD] 
    	,trg.[BENE_FIPS_CNTY_CD] 		 = src.[BENE_FIPS_CNTY_CD] 
    	,trg.[BENE_ZIP_CD] 			 = src.[BENE_ZIP_CD] 
    	,trg.[BENE_DOB] 			 = src.[BENE_DOB] 
    	,trg.[BENE_SEX_CD] 			 = src.[BENE_SEX_CD] 
    	,trg.[BENE_RACE_CD]			 = src.[BENE_RACE_CD]
    	,trg.[BENE_AGE] 			 = src.[BENE_AGE] 
    	,trg.[BENE_MDCR_STUS_CD] 		 = src.[BENE_MDCR_STUS_CD] 
    	,trg.[BENE_DUAL_STUS_CD] 		 = src.[BENE_DUAL_STUS_CD] 
    	,trg.[BENE_DEATH_DT] 		 = src.[BENE_DEATH_DT] 
    	,trg.[BENE_RNG_BGN_DT]		 = src.[BENE_RNG_BGN_DT]
    	,trg.[BENE_RNG_END_DT]		 = src.[BENE_RNG_END_DT]
    	,trg.[BENE_1ST_NAME] 		 = src.[BENE_1ST_NAME] 
    	,trg.[BENE_LAST_NAME]		 = src.[BENE_LAST_NAME]
    	,trg.[BENE_MIDL_NAME]		 = src.[BENE_MIDL_NAME]
    	,trg.[BENE_ORGNL_ENTLMT_RSN_CD] = src.[BENE_ORGNL_ENTLMT_RSN_CD]
    	,trg.[BENE_ENTLMT_BUYIN_IND] 	 = src.[BENE_ENTLMT_BUYIN_IND] 
    	,trg.[SrcFileName] 			 = src.[SrcFileName] 
    	,trg.[FileDate] 			 = src.[FileDate] 
    	,trg.[OriginalFileName] 		 = src.[OriginalFileName] 	
    	,trg.[AstCreatedDate] 		 = src.[AstCreatedDate] 
    	,trg.[AstCreatedBy] 			 = src.[AstCreatedBy] 
        ;

    --TRUNCATE TABLE ast.CCLF8_UPdates
