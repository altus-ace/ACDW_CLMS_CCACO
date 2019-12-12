

Create VIEW [dbo].[vw_Dashboard_CCACO_CallCenter_Summary]
AS

SELECT a.LOB, 
       a.ClientMemberKey, 
       a.Member_Name, 
       a.DOB, 
       a.MemberPhoneNumber, 
       a.PCP_Name, 
       a.PcpPhoneNumber, 
       a.PcpAddress, 
       a.Measures_Combined, 
       a.Total_Gaps, 
       b.copAceWorklistKey, 
       b.srcFileName, 
       b.loadDate, 
       b.CreatedDate, 
       b.CreatedBy, 
       b.Subscriber_ID, 
       b.Provider_Name, 
       b.Last_Service_Date_for_Measure, 
       b.Measure, 
       b.[Plan], 
       b.Member_Phone, 
       b.PCP_Phone, 
       b.Last_Call_Date, 
       b.Last_Outcome, 
       b.First_Call_Date, 
       b.First_Call_Outcome, 
       b.Second_Call_Date, 
       b.Second_Call_Outcome, 
       b.Third_Call_Date, 
       b.Third_Call_Outcome, 
       b.Fourth_Call_Date, 
       b.Fourth_Call_Outcome, 
       b.File_Update_Date, 
       b.List_Generated_Date, 
       b.Comments, 
       b.First_Call_Type, 
       b.Second_Call_Type, 
       b.Third_Call_Type, 
       b.Fourth_Call_Type, 
       b.Latest_Outcome, 
       b.Latest_Action, 
       b.Latest_Action_Date, 
       b.Latest_Rep, 
       b.Priority_Weight
FROM ACDW_CLMS_CCACO.[dbo].[vw_CCACO_CallCenter_Worklist] a
     LEFT JOIN ACDW_CLMS_CCACO.[adi].[copAceWorkList] b ON b.subscriber_id = a.clientmemberkey;

;