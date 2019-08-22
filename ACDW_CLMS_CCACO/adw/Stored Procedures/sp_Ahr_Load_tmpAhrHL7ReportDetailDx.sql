








CREATE PROCEDURE [adw].[sp_Ahr_Load_tmpAhrHL7ReportDetailDx] 

AS
BEGIN

	SET NOCOUNT ON;


IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_Dx]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx]; 

CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx](
	[ID] [int] IDENTITY(2000,1) NOT NULL,
	[SUBSCRIBER_ID] [varchar](50) NULL,
	[ICD10_Code] [varchar](11) NULL,
	[DESC] [varchar](255) NULL,
	[HCC] [varchar](3) NULL,
	[HCC_Description] [varchar](255) NULL,
	[WEIGHT] [decimal](4, 3) NULL,
	[SVC_PROV_FULL_NAME] [varchar](250) NULL,
	[SVC_PROV_NPI] [varchar](11) NULL,
	[SVC_DATE] [date] NULL,
	[LOADDATE] [date] NULL,
	[LOADEDBY] [varchar](50) NULL
)

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx] ADD  DEFAULT (sysdatetime()) FOR [LOADDATE]

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_Dx] ADD  DEFAULT (suser_sname()) FOR [LOADEDBY]

DECLARE @DateStart datetime =  year(getdate())-1 --last year
DECLARE @DateEnd datetime = year(getdate()) --current year
DECLARE @ExclDate datetime =  year(getdate())-2 --2 years ago

;WITH CTE AS(
	SELECT a.subscriber_id, b.primary_svc_date, DIAGCODE as DxCode,replace(DIAGCODE,'.','')[Dx_No_Dec] 
	FROM adw.CLAIMS_DIAGS a 
	JOIN adw.CLAIMS_HEADERS b ON a.SEQ_CLAIM_ID = b.seq_claim_id 
	JOIN dbo.vw_tmp_AHR_Population c ON a.SUBSCRIBER_ID = c.HICN
	WHERE year(b.primary_svc_date) = @DateStart
	EXCEPT
	SELECT a.subscriber_id, b.primary_svc_date, DIAGCODE as DxCode, replace(DIAGCODE,'.','')[Dx_No_Dec]
	FROM adw.CLAIMS_DIAGS a 
	JOIN adw.CLAIMS_HEADERS b on a.SEQ_CLAIM_ID = b.seq_claim_id 
	JOIN dbo.vw_tmp_AHR_Population c ON a.SUBSCRIBER_ID = c.HICN
	WHERE year(b.primary_svc_date) = @DateEnd
	)

INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
	(
		[SUBSCRIBER_ID]
		,[ICD10_Code]
		,[DESC]
		,[HCC]
		,[HCC_Description]
		,[SVC_DATE]
	)
	SELECT 
		c.SUBSCRIBER_ID
		,c.DxCode
		,dx.icd10_description
		,dx.cur_hcc
		,dx.HCC_Description
		,c.PRIMARY_SVC_DATE
	 FROM CTE c
	 INNER JOIN dbo.vw_LatestDx_HCCCodes dx 
	 ON c.Dx_No_Dec = dx.ICD10

--SELECT
--		DISTINCT 
--		ch.[SUBSCRIBER_ID]
--		--,[Primary_SVC_DATE]
--		,t.[DIAGCODE] AS [DxCODE]
--		,dx.ICD10_DESCRIPTION
--		,dx.CUR_HCC
--		,dx.[HCC_Description]
--		,0.000 AS [Weight]
--		--,max([Primary_SVC_DATE]) over (partition by t.[DIAGCODE] )[Primary_SVC_DATE] 
--FROM [dbo].[CLAIMS_HEADERS]  ch
--	INNER JOIN #gaps t on t.SUBSCRIBER_ID = ch.SUBSCRIBER_ID and t.Dx_No_Dec = ch.[ICD_PRIM_DIAG]
--	JOIN 
--	  (SELECT a.[ICD10]
--		,a.[ICD10_DESCRIPTION]
--		,a.[HCCV22] as CUR_HCC
--		,b.HCC_Description
--		FROM [LIST_ICD10CMwHCC] a, 
--		(SELECT DISTINCT HCC_No, HCC_Description, max(year) as MaxYr
--		FROM [ACDW_CLMS_CCACO].[dbo].[LIST_HCC_CODES]
--		GROUP BY HCC_No, HCC_Description
--		) b
--		WHERE a.ACTIVE = 1 AND a.HCCV22 = b.HCC_No) dx 
--		ON dx.ICD10 = replace(t.[DIAGCODE],'.','')
--	--	(SELECT a.[ICD10]
--	--	,a.[ICD10_DESCRIPTION]
--	--	,a.[HCCV22] as CUR_HCC
--	--	,b.HCC_Description
--	--	FROM [LIST_ICD10CMwHCC] a, LIST_HCC_CODES b
--	--	WHERE a.ACTIVE = 1 AND a.HCCV22 = b.HCC_No AND b.Year = (SELECT MAX(YEAR) FROM LIST_HCC_CODES)
--	--	) dx ON dx.ICD10 = replace(t.[DIAGCODE],'.','')

--	--LEFT JOIN [LIST_NPPES] n on n.npi = ch.SVC_PROV_NPI
--WHERE /*n.EntityType = 1 and*/ year([Primary_SVC_DATE]) > year(getdate())-2 
--GROUP BY [PRIMARY_SVC_DATE]
--		,ch.[SUBSCRIBER_ID]
--		,ch.ICD_PRIM_DIAG
--		,[SVC_PROV_FULL_NAME]
--		,dx.ICD10_DESCRIPTION
--		,dx.CUR_HCC
--		,dx.[HCC_Description]
--		,ch.[SVC_PROV_NPI]
--		--,n.[LBN_Name]
--		--,FirstName
--		--,LastName
--		--,NPI
--		,t.[DIAGCODE]


----SELECT
----     distinct 
----	  ch.[SUBSCRIBER_ID]
----	  --,[Primary_SVC_DATE]
----	  ,t.[diagCode][DxCODE]
----	  --,c.CODE
----	  ,hc.VALUE_CODE_NAME
----	  ,h.HCC_No
----	  ,h.[HCC_Description]
----	  ,0.000[Weight]
----      ,''[SVC_PROV_FULL_NAME] --n.FirstName + ' ' + n.LastName 
----	  ,n.NPI[SVC_PROV_NPI] --n.NPI 
----	  ,max([Primary_SVC_DATE]) over (partition by c.CODE )[Primary_SVC_DATE] --t.[diagCode])[Primary_SVC_DATE]
----FROM [dbo].[Claims_Headers]  ch
----	Inner Join #gaps t on t.SUBSCRIBER_ID = ch.SUBSCRIBER_ID and t.Dx_No_Dec = ch.[ICD_PRIM_DIAG]
----	join [dbo].[LIST_HEDIS_CODE] hc on hc.VALUE_CODE = t.[diagCode]
----	join LIST_DX_CODES c on c.CODE = replace(t.[diagCode],'.','')
----	left join [dbo].[LIST_HCC_CODES] h on h.hcc_ID = c.HCC_ID
----	join [dbo].[LIST_NPPES] n on n.npi = ch.SVC_PROV_NPI
----where n.EntityType = 1 and year([Primary_SVC_DATE]) > @ExclDate --and ch.SUBSCRIBER_ID = '{9450649116'
----group by [PRIMARY_SVC_DATE],ch.[SUBSCRIBER_ID],ch.ICD_PRIM_DIAG,[SVC_PROV_FULL_NAME]
----	,hc.VALUE_CODE_NAME,h.HCC_No,h.[HCC_Description],ch.[SVC_PROV_NPI],FirstName,LastName,NPI,c.CODE,t.[diagCode]
----order by ch.[SUBSCRIBER_ID]--, ch.[PRIMARY_SVC_DATE]

              
END






