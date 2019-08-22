






CREATE PROCEDURE [adw].[sp_Ahr_Load_tmpAhrHL7ReportDetailIP] 

AS
BEGIN

	SET NOCOUNT ON;


IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_IP]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP]; 

CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP](
	[IP_ID] [int] IDENTITY(4000,1) NOT NULL,
	[SUBSCRIBER_ID] [varchar](50) NULL,
	[ADMIT_DATE] [date] NULL,
	[DISC_DATE] [date] NULL,
	[LOS] [int] NULL,
	[DISC_DISPOSITION] [varchar](25) NULL,
	[PRIMARY_DX] [varchar](11) NULL,
	[DESC] [varchar](max) NULL,
	[SECONDARY_DX] [varchar](11) NULL,
	[SECONDARY_DESC] [varchar](max) NULL,
	[LOCATION] [varchar](250) NULL,
	[LOADDATE] [date] NULL,
	[LOADEDBY] [varchar](250) NULL
)

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP] ADD  DEFAULT (sysdatetime()) FOR [LOADDATE]

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_IP] ADD  DEFAULT (suser_sname()) FOR [LOADEDBY]

DECLARE @BeginDate [DATE] = ( SELECT CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE) )
DECLARE @EndDate [DATE] = ( SELECT CONVERT (DATE, GETDATE()) ) 

INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_IP](
		[SUBSCRIBER_ID]
		,[ADMIT_DATE]
		,[DISC_DATE]
		,[LOS]
		,[DISC_DISPOSITION]
		,[PRIMARY_DX]
		,[DESC]
		,[SECONDARY_DX]
		,[SECONDARY_DESC]
		,[LOCATION]
		)

SELECT DISTINCT --a.*,
		a.SUBSCRIBER_ID
		,a.ADMISSION_DATE
		,a.SVC_TO_DATE
		,DATEDIFF(DAY,a.ADMISSION_DATE,a.SVC_TO_DATE) [LOS]
		,''
		,''
		,''
		,''
		,''
		,n.LBN_NAME
		--,b.VENDOR_ID  
FROM adw.[tvf_get_claims_w_dates]( 'Inpatient Stay','','',@BeginDate,@EndDate ) a 
JOIN adw.Claims_Headers b on a.seq_claim_id = b.seq_claim_id
JOIN dbo.vw_tmp_AHR_Population c ON b.SUBSCRIBER_ID = c.HICN
LEFT JOIN lst.[LIST_NPPES] n on n.NPI = b.VENDOR_ID
              
END




