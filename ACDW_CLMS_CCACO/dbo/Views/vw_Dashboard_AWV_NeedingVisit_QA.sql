



CREATE VIEW [dbo].[vw_Dashboard_AWV_NeedingVisit_QA]
AS
     SELECT b.[HICN], 
            b.[LAST_NAME] as LASTNAME,
			b.[FIRST_NAME] as [FIRSTNAME],
            b.[SEX], 
            b.[DOB], 
			d.[M_Alternate_Number] as [Home Phone],
			d.[M_Mobile_Number] as [Mobile Phone],
			a.mbr_type as MBR_TYPE,
			c.SVC_PROV_NPI as LastSvcNPI,
			c.LBN as  LastSvcName, 
            c.SVC_DATE AS LastSvcDate, 
            b.NPI AS ACO_NPI, 
            b.NPI_NAME AS ACO_NPI_NAME

     FROM
     (
         SELECT *
         FROM adw.[tmp_Active_Members]
         WHERE Exclusion = 'N'
     ) a
 JOIN (
SELECT [URN]
      ,[RANK]
      ,[HICN]
      ,[FIRST_NAME]
      ,[LAST_NAME]
      ,[SEX]
      ,[DOB]
      ,[PREV_BEN_FLG]
      ,[CUR_AGE]
      ,[ELIG_TYPE]
      ,[TIN]
      ,[TIN_NAME]
      ,[NPI]
      ,[NPI_NAME]
      ,[NPI_PRIM_SPECIALTY]
      ,[RUN_DATE]
      ,[RUN_YEAR]
      ,[RUN_MTH]
      ,[LOAD_DATE]
      ,[LOAD_USER]
  FROM [ACDW_CLMS_CCACO].[adw].[Member_Assigned_AWV_History] where run_year  = ( select max(run_year) from [adw].[Member_Assigned_AWV_History])  
  and RUN_MTH =  (select Max(run_mth) from [adw].[Member_Assigned_AWV_History] where run_year = ( select max(run_year) from [adw].[Member_Assigned_AWV_History])  )
) b ON a.HICN = b.HICN
left join [adw].[vw_AllMbrDetail_LastPCPVisit] c on a.HICN = c.SUBSCRIBER_ID 
left join adw.M_MEMBER_ENR d on a.HICN = d.subscriber_id