﻿CREATE  FUNCTION [adw].[2020_tvf_Get_ClaimsByValueSet]
(@ValueSet1			VARCHAR(150), 
 @ValueSet2			VARCHAR(150), 
 @ValueSet3			VARCHAR(150), 
 @ValueSet4			VARCHAR(150),  
 @PrimSvcDate_Start VARCHAR(20), 
 @PrimSvcDate_End   VARCHAR(20)
)
RETURNS TABLE
AS RETURN
(
									--DECLARE @ValueSet1 VARCHAR(50) = 'Outpatient'
									--DECLARE @ValueSet2 VARCHAR(50) = 'BMI'
									--DECLARE @ValueSet3 VARCHAR(50) = 'BMI Percentile'
									--DECLARE @ValueSet4 VARCHAR(50) = ''
									--DECLARE @PrimSvcDate_Start VARCHAR(50) = '01/01/2016'
									--DECLARE @PrimSvcDate_End VARCHAR(50) = '12/31/2019'
SELECT		   B1.[SEQ_CLAIM_ID]--, b1.CLAIM_STATUS
			  ,B1.[SUBSCRIBER_ID]
			  ,B1.[CATEGORY_OF_SVC]
			  ,B1.[ICD_PRIM_DIAG]
			  ,B1.[PRIMARY_SVC_DATE]
			  ,B1.[SVC_TO_DATE]
			  ,B1.[CLAIM_THRU_DATE]
			  ,B1.[VEND_FULL_NAME]
			  ,B1.[PROV_SPEC]
			  ,B1.[IRS_TAX_ID]
			  ,B1.[DRG_CODE]
			  ,B1.[BILL_TYPE]		
			  ,B1.[ADMISSION_DATE]
			  ,B1.[CLAIM_TYPE]
			  ,B1.[TOTAL_BILLED_AMT]
			  ,B1.[TOTAL_PAID_AMT]
			  ,DATEDIFF(dd,B1.PRIMARY_SVC_DATE, B1.SVC_TO_DATE)		AS LOS
			  ,DATEDIFF(dd,B1.PRIMARY_SVC_DATE, GETDATE())			AS DaysSincePrimarySvcDate
			  ,VC AS ValueCode
			  ,VCS AS ValueCodeSystem
			  --,VC_SVC_DATE AS ValueCodeSvcDate
			  ,PRIMARY_SVC_DATE AS ValueCodeSvcDate

FROM		  [adw].[Claims_Headers] B1
INNER JOIN
			  (
			  SELECT DISTINCT	C1.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS--,C1.PROCDATE as VC_SVC_DATE
			  FROM				adw.Claims_Procs C1
			  INNER JOIN
			  (
				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM 
				  FROM				lst.List_HEDIS_CODE L1
				  WHERE				L1.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
				  AND				L1.ACTIVE = 'Y'
				  AND				VALUE_CODE_SYSTEM IN('ICD10PCS', 'ICD9PCS')
			  )						L11 
			  ON					L11.VALUE_CODE = C1.PROCCODE
UNION
			  SELECT DISTINCT   C2.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS--,C2.PRIMARY_SVC_DATE as VC_SVC_DATE
			  FROM adw.Claims_Headers C2
			  INNER JOIN
			  (
				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM 
				  FROM				lst.List_HEDIS_CODE L2
				  WHERE				L2.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
				  AND				L2.ACTIVE = 'Y'
				  AND				VALUE_CODE_SYSTEM IN('MSDRG')
			  )						L22
			  ON				L22.VALUE_CODE = C2.DRG_CODE
UNION
			  SELECT DISTINCT	C3.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS--, L333.PRIMARY_SVC_DATE as VC_SVC_DATE
			  FROM				adw.Claims_Diags C3
			  INNER JOIN 
			  --(
				 -- SELECT DISTINCT	SEQ_CLAIM_ID, PRIMARY_SVC_DATE
				 -- FROM				adw.Claims_Headers C33
			  --)						L333
			  --ON				L333.SEQ_CLAIM_ID = C3.SUBSCRIBER_ID
			  --INNER JOIN
			  (
				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM 
				  FROM				lst.List_HEDIS_CODE L3
				  WHERE				L3.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
				  AND				L3.ACTIVE = 'Y'
				  AND				VALUE_CODE_SYSTEM IN('ICD9CM', 'ICD10CM')
			  )						L33
			  ON				L33.VALUE_CODE = C3.DIAGCODE
UNION
			  SELECT DISTINCT	C4.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS--,C4.DETAIL_SVC_DATE as VC_SVC_DATE
			  FROM				adw.Claims_Details C4
			  INNER JOIN
			  (
				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM 
				  FROM				lst.List_HEDIS_CODE L4
				  WHERE				L4.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
				  AND				L4.ACTIVE = 'Y'
				  AND				VALUE_CODE_SYSTEM IN('UBREV')
			  )						L44
			  ON				CAST(L44.VALUE_CODE AS INT) = CAST(C4.REVENUE_CODE AS INT)
UNION
			  SELECT DISTINCT	C5.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS--,C5.DETAIL_SVC_DATE as VC_SVC_DATE
			  FROM				adw.Claims_Details C5
			  INNER JOIN
			  (
				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM 
				  FROM				lst.List_HEDIS_CODE L5
				  WHERE				L5.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
				  AND				L5.ACTIVE = 'Y'
				  AND				VALUE_CODE_SYSTEM IN('NDC')
			  )						L55
			  ON				L55.VALUE_CODE = C5.NDC_CODE
UNION
			  SELECT DISTINCT	C6.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS--,C6.DETAIL_SVC_DATE as VC_SVC_DATE
			  FROM				adw.Claims_Details C6
			  INNER JOIN
			  (
				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM 
				  FROM				lst.List_HEDIS_CODE L6
				  WHERE				L6.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
				  AND				L6.ACTIVE = 'Y'
				  AND				L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT')
			  )						L66
			  ON				L66.VALUE_CODE = C6.PROCEDURE_CODE
--UNION 
--			  SELECT DISTINCT	C7.SEQ_CLAIM_ID,VALUE_CODE as VC,VALUE_CODE_SYSTEM as VCS,C7.DETAIL_SVC_DATE as VC_SVC_DATE
--			  FROM				adw.CLAIMS_DETAILS C7
--              INNER JOIN 
--			  (
--				  SELECT DISTINCT	VALUE_CODE, VALUE_CODE_SYSTEM   
--				  FROM				lst.List_HEDIS_CODE L7 
--				  WHERE				L7.VALUE_SET_NAME IN(@ValueSet1, @ValueSet2, @ValueSet3, @ValueSet4)
--				  AND				L7.ACTIVE = 'Y'
--				  AND				L7.VALUE_CODE_SYSTEM IN('POS')
--			  )						L77 
--			  ON				L77.VALUE_CODE = C7.PLACE_OF_SVC_CODE1
			  )					AS D 
			  ON				D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID
			  WHERE				--B1.PROCESSING_STATUS	= 'P'
		      --AND				B1.CLAIM_STATUS IN (0,1,3,5,'')-- = ( Select Destination From [lst].[ListAceMapping] Where lstAceMappingKey = 338)
			 /* AND*/			CONVERT(DATETIME, B1.PRIMARY_SVC_DATE)	>= 	@PrimSvcDate_Start
			  AND				CONVERT(DATETIME, B1.PRIMARY_SVC_DATE)	<=  @PrimSvcDate_End
)

/***
Usage: 
SELECT *
FROM [adw].[2020_tvf_Get_ClaimsByValueSet] ('Outpatient','BMI','BMI Percentile','','01/01/2016','12/31/2019')--24540--21530
***/