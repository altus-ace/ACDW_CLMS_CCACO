CREATE VIEW [dbo].[z_VW_tmp_SSRS_Mbr_PCP]
AS


 Select a.HICN as Subscriber_ID
	,a.FirstName
	,a.LastName
	,a.DOB
	,a.MBI
	,case when a.Sex = '1' then 'M' else 'F' End as Gender
	,b.M_Address_Line1_Res
	,b.M_Address_Line2_Res
	,b.M_City_Res
	,b.M_State_Res
	,b.M_Zip_Code_Res
	,b.M_Mobile_Number
	,c.TIN
	,c.NPI
	,upper(c.NPI_NAME) as NPI_Name
	,upper(C.TIN_NAME) as TIN_NAME
 from [acdw_clms_CCACO].[dbo].[tmp_Active_Members] a
 inner join
  [acdw_clms_CCACO].[dbo].[M_MEMBER_ENR] b on b.subscriber_id=a.HICN
  inner join [ACDW_CLMS_CCACO].[dbo].[vw_Mbr_Assigned_TIN_NPI] c on c.HICN = a.HICN
where a.HICN in ('{9858821310','{9944615146', '047446051A','049521046A','{6054816810','037581666A','041563129A')


