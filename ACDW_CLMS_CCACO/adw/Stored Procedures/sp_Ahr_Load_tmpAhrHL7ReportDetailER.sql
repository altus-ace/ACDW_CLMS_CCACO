








CREATE PROCEDURE [adw].[sp_Ahr_Load_tmpAhrHL7ReportDetailER] 

AS
BEGIN

	SET NOCOUNT ON;


IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_ER]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER]; 

CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER](
	[EP_ID] [int] IDENTITY(3000,1) NOT NULL,
	[SUBSCRIBER_ID] [varchar](50) NULL,
	[DATE] [date] NULL,
	[PRIMARY_DX] [varchar](11) NULL,
	[DESC] [varchar](max) NULL,
	[SECONDARY_DX] [varchar](11) NULL,
	[SECONDARY_DESC] [varchar](max) NULL,
	[LOCATION] [varchar](250) NULL,
	[LOADDATE] [date] NULL,
	[LOADEDBY] [varchar](250) NULL
)

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER] ADD  DEFAULT (sysdatetime()) FOR [LOADDATE]

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_ER] ADD  DEFAULT (suser_sname()) FOR [LOADEDBY]

DECLARE @BeginDate [DATE] = ( SELECT CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE) )
DECLARE @EndDate [DATE] = ( SELECT CONVERT (DATE, GETDATE()) ) 

--DECLARE @BeginDate [date] = ( SELECT DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0) )
--DECLARE @EndDate [Date] = ( SELECT DATEADD(MILLISECOND, -3, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0)) )

INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_ER]
           (
			  [SUBSCRIBER_ID]
			  ,[DATE]
			  ,[PRIMARY_DX]
			  ,[DESC]
			  ,[SECONDARY_DX]
			  ,[SECONDARY_DESC]
			  ,[LOCATION]
			)
SELECT DISTINCT 
	a.SUBSCRIBER_ID
	,a.PRIMARY_SVC_DATE
	,''[Primary_Dx]
	,''[Description]
	,''[Secondary_DX]
	,''[2_Description]
	,n.[LBN_Name] + '('+ b.VENDOR_ID + ')'
FROM (
	SELECT * FROM adw.[tvf_get_claims_w_dates]('ED','','',@BeginDate,@EndDate) WHERE CATEGORY_OF_SVC <> 'PHYSICIAN'
	UNION
	(
	SELECT a.* FROM adw.[tvf_get_claims_w_dates]('ED POS','','',@BeginDate,@EndDate) a
	JOIN adw.[tvf_get_claims_w_dates]('ED Procedure Code','','',@BeginDate,@EndDate) b on a.seq_claim_id = b.seq_claim_id
	AND a.CATEGORY_OF_SVC <> 'PHYSICIAN')
	)	a 

JOIN adw.CLAIMS_HEADERS B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
JOIN dbo.vw_tmp_AHR_Population c ON b.SUBSCRIBER_ID = c.HICN
LEFT JOIN lst.[LIST_NPPES] n on n.NPI = b.VENDOR_ID

              
END






