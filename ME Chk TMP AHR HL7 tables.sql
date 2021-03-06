/****** Script for SelectTopNRows command from SSMS  ******/
USE [ACDW_CLMS_CCACO]
GO

SELECT count([HICN])  as Count
  FROM [dbo].[vw_tmp_AHR_Population]

SELECT count(DISTINCT SubscriberNo)  as CountHeader
  FROM [dbo].[tmp_AHR_HL7_Report_Header]

SELECT count(DISTINCT SUBSCRIBER_ID)  as CountCG
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_CG]

SELECT count(DISTINCT SUBSCRIBER_ID)  as CountDx
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_Dx]

SELECT count(DISTINCT SUBSCRIBER_ID)  as CountIP
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_IP]

SELECT count(DISTINCT SUBSCRIBER_ID)  as CountER
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_ER]

/*** Check indiv Subscriber ID 
DECLARE @SUBSCRIBER_ID varchar(50) = '054964524M'

SELECT *
  FROM [dbo].[vw_tmp_AHR_Population]
  WHERE HICN = @SUBSCRIBER_ID

SELECT *
  FROM [dbo].[tmp_AHR_HL7_Report_Header]
  WHERE SubscriberNo = @SUBSCRIBER_ID

SELECT *
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_CG]
  WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID

SELECT *
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_Dx]
  WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID

SELECT *
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_IP]
  WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID

SELECT *
  FROM [dbo].[tmp_AHR_HL7_Report_Detail_ER]
  WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
***/