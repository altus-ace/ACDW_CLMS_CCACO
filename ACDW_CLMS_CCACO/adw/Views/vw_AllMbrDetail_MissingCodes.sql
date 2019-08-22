


CREATE VIEW [adw].[vw_AllMbrDetail_MissingCodes]
AS
     SELECT distinct a.SUBSCRIBER_ID, 
            a.icd10_code AS DXCODE, 
            a.[desc] AS DESCRIPTION, 
            a.HCC as HCCV22,
			convert(date, a.svc_date,101) as SVC_DATE
			
    
     
  FROM [ACDW_CLMS_CCACO].[dbo].[tmp_AHR_HL7_Report_Detail_Dx] a 
 -- where SUBSCRIBER_ID = '078462724A'
