/****** Script for SelectTopNRows command from SSMS  ******/
USE ACDW_CLMS_CCACO
GO

/*** CLAIMS_HEADERS 54894 in 12sec***/
MERGE adw.CLAIMS_HEADERS trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.SUBSCRIBER_ID = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		SUBSCRIBER_ID = src.CRNT_HIC_NUM
	;

/*** CLAIMS_DIAGS 166077 in 2:03sec***/
MERGE adw.CLAIMS_DIAGS trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.SUBSCRIBER_ID = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		SUBSCRIBER_ID = src.CRNT_HIC_NUM
	;

/*** CLAIMS_PROCS 1104 in 0:05sec***/
MERGE adw.CLAIMS_PROCS trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.SUBSCRIBER_ID = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		SUBSCRIBER_ID = src.CRNT_HIC_NUM
	;

/*** CLAIMS_Member 1078 in 0:01sec***/
MERGE adw.CLAIMS_Member trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   , m.subscriber_id
	FROM [adi].[CCLF9] a
		LEFT JOIN adw.claims_member M ON a.CRNT_HIC_NUM = M.SUBSCRIBER_ID
	WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) FROM [adi].[CCLF9])
		and M.SUBSCRIBER_ID is null		
		) src
ON trg.SUBSCRIBER_ID = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		SUBSCRIBER_ID = src.CRNT_HIC_NUM
	;


	