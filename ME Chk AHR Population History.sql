USE [ACDW_CLMS_CCACO]
GO

/****** Check to AHR History  ******/
  SELECT RUN_YEAR, RUN_MTH, COUNT(*) AS CNT
  FROM adw.[AHR_Population_History]
  GROUP BY RUN_YEAR, RUN_MTH
  ORDER BY RUN_YEAR DESC, RUN_MTH DESC

  select * from adw.[AHR_Population_History] where LOAD_DATE = (select max(load_date) from adw.[AHR_Population_History] )
  --select * from dbo.vw_tmp_AHR_Population


/****** Delete / Back out of records per Run Year and Mth  ******/
  -- DELETE  FROM [AHR_Population_History] WHERE RUN_YEAR = 2018 AND RUN_MTH = 10

--UPDATE [adw].[Member_Unassigned_AWV_History]
--SET RUN_MTH = 2
--WHERE RUN_MTH = 3 AND RUN_YEAR = 2019

--UPDATE [adw].[Member_Assigned_AWV_History]
--SET RUN_MTH = 2
--WHERE RUN_MTH = 3 AND RUN_YEAR = 2019

--UPDATE [adw].[AHR_Population_History]
--SET RUN_MTH = 2
--WHERE RUN_MTH = 3 AND RUN_YEAR = 2019

