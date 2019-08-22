
  CREATE view [dbo].[zvw_Awv_Full_List_History]
	  as 
	  select hicn, first_name, last_name, sex, dob, mbr_type, aco_npi as NPI , concat(d.PCP_LAST_NAME,', ',d.PCP_FIRST_NAME) as NPI_NAME, run_mth, RUN_YEAR   from  [ACDW_CLMS_CCACO].[dbo].[Member_Unassigned_AWV_History] a left join  LIST_PCP d ON a.ACO_NPI = d.PCP_NPI
	  where hicn in (select hicn from [tmp_Active_Members] where exclusion = 'N') 
	  union   
	  select hicn, first_name, last_name, sex, dob, 'A' as mbr_type, NPI , NPI_NAME, RUN_MTH, RUN_YEAR from [ACDW_CLMS_CCACO].[dbo].[Member_Assigned_AWV_History]
	  where hicn in (select hicn from [tmp_Active_Members] where exclusion = 'N') 
