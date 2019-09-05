/****** Script for SelectTopNRows command from SSMS  ******/
USE ACDW_CLMS_CCACO
GO

/*** ***/
MERGE adw.Assignable_Member_History trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.HICN = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		HICN = src.CRNT_HIC_NUM
	;


/*** ***/
MERGE adw.Member_History trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.HICN = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		HICN = src.CRNT_HIC_NUM
	;

	/*** ***/
MERGE adw.Member_Practice_History trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.HICN = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		HICN = src.CRNT_HIC_NUM
	;


	/*** ***/
MERGE adw.Member_Provider_History trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.HICN = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		HICN = src.CRNT_HIC_NUM
	;

/*** ***/
MERGE adw.Member_UnassignedReason_History trg
USING(SELECT DISTINCT a.[CRNT_HIC_NUM]
		,a.[PRVS_HIC_NUM]   
	FROM [adi].[CCLF9] a
	 WHERE CONVERT(DATE, a.[CreateDate]) 
		= (SELECT MAX (CONVERT(date, [CreateDate])) 
				FROM [adi].[CCLF9])
		) src
ON trg.HICN = src.prvs_hic_Num
WHEN MATCHED THEN
	UPDATE SET 
		HICN = src.CRNT_HIC_NUM
	;

