
Create VIEW [dbo].[vw_CCACO_CallCenter_Worklist]
AS

select * from (select distinct
'CCACO' [LOB]	
,a.HICN as [ClientMemberKey]
,concat(a.lastname,',',a.firstname) as [Member_Name]	
,a.[DOB]
,concat(b.m_alternate_number,'| ',b.M_Mobile_Number) as [MemberPhoneNumber] 	
,a.aco_npi_name as [PCP_Name]	
,c.PrimaryOfficePhone as[PcpPhoneNumber]	
,concat(PCP__ADDRESS,',',PCP__ADDRESS2,','+PCP_CITY,',',PCP_STATE) as [PcpAddress]	
,'Annual Well Visit' as [Measures_Combined]	
,null as [Total_Gaps]	
,null as [First_Contact_Type]	
,null as [First_Contact_Type_Date]	
,null as [First_Contact_Outcome]	
,null as [Second_Contact_Type]	
,null as [Second_Contact_Type_Date]	
,null as [Second_Contact_Outcome]	
,null as [Third_Contact_Type]	
,null as [Third_Contact_Type_Date]	
,null as [Third_Contact_Outcome]	
,null as [Fourth_Contact_Type]	
,null as [Fourth_Contact_Type_Date]	
,null as [Fourth_Contact_Outcome]	
,null as [Rep_Comment]	
,null as [Priority_Weight]	
,null as [Latest_Outcome]	
,null as [Latest_Action]	
,null as [Latest_Action_Date]	
,null as [Latest_Rep]
from [ACDW_CLMS_CCACO].dbo.vw_dashboard_AWV_NeedingVisit a
join [ACDW_CLMS_CCACO].[adw].[M_MEMBER_ENR] b on b.subscriber_id = a.HICN
join [ACDW_CLMS_CCACO].[dbo].[tmp_Physician_Phone_Numbers] c on c.NPIInd = a.ACO_NPI
left join [ACDW_CLMS_WLC_ecap].lst.List_PCP LPCP on LPCP.PCP_NPI = A.ACO_NPI and replace(replace(replace(replace(c.PrimaryOfficePhone,')',''),'(',''),'-',''),' ','') = LPCP.PCP_PHONE /* use CCACO list pcp for next run */
--where LPCP.PCP_NPI = '1679570246'
) as x where x.memberphonenumber <> '|'
;