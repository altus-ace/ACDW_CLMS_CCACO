











CREATE VIEW [dbo].[vw_Excel_Worklist_Generate]
AS
WITH CTE
     AS (SELECT DISTINCT 
                x.[LOB], 
                x.[ClientMemberKey], 
                x.[Member_Name], 
                x.[DOB], 
                x.[MemberPhoneNumber], 
                x.[PCP_Name], 
                x.[PcpPhoneNumber], 
                x.[PcpAddress],
				X.[Annual_Wellness _Visit], 
                x.OpenMeasure, 
				x.Total_Gaps,
                x.[First_Contact_Type], 
                x.[First_Contact_Type_Date], 
                x.[First_Contact_Outcome], 
                x.[Second_Contact_Type], 
                x.[Second_Contact_Type_Date], 
                x.[Second_Contact_Outcome], 
                x.[Third_Contact_Type], 
                x.[Third_Contact_Type_Date], 
                x.[Third_Contact_Outcome], 
                x.[Fourth_Contact_Type], 
                x.[Fourth_Contact_Type_Date], 
                x.[Fourth_Contact_Outcome], 
                x.[Rep_Comment], 
                x.[Priority_Weight], 
                x.[Latest_Outcome], 
                x.[Latest_Action], 
                x.[Latest_Action_Date], 
                x.[Latest_Rep]
         FROM
         (
             SELECT DISTINCT 
                    'CCACO' [LOB], 
                    a.HICN AS [ClientMemberKey], 
                    concat(a.lastname, ',', a.firstname) AS [Member_Name], 
                    a.[DOB], 
                    concat(b.m_alternate_number, '| ', b.M_Mobile_Number) AS [MemberPhoneNumber], 
                    a.aco_npi_name AS [PCP_Name], 
                    c.PrimaryOfficePhone AS [PcpPhoneNumber], 
                    concat(PCP__ADDRESS, ',', PCP__ADDRESS2, ',' + PCP_CITY, ',', PCP_STATE) AS [PcpAddress],
				    'Annual Well Visit' AS [Annual_Wellness _Visit],
					 CASE
                        WHEN  QM.QmMsrId = 'BCS'
                        THEN 'Breast Cancer Screening'
                        WHEN  QM.QmMsrId = 'COL'
                        THEN 'Colorectal Cancer Screening'
                        WHEN QM.QmMsrId = 'CDC_9'
                        THEN 'Diabetes Poor Control '
                    END AS OpenMeasure, 
					NULL AS [Total_Gaps], 
					--count(ClientMemberKey) as TotalGaps,
                    NULL AS [First_Contact_Type], 
                    NULL AS [First_Contact_Type_Date], 
                    NULL AS [First_Contact_Outcome], 
                    NULL AS [Second_Contact_Type], 
                    NULL AS [Second_Contact_Type_Date], 
                    NULL AS [Second_Contact_Outcome], 
                    NULL AS [Third_Contact_Type], 
                    NULL AS [Third_Contact_Type_Date], 
                    NULL AS [Third_Contact_Outcome], 
                    NULL AS [Fourth_Contact_Type], 
                    NULL AS [Fourth_Contact_Type_Date], 
                    NULL AS [Fourth_Contact_Outcome], 
                    NULL AS [Rep_Comment],
               CASE
                   WHEN cwl.Fourth_Call_Outcome IS NOT NULL  and CWL.Fourth_Call_Outcome <> ''
                   THEN CASE
							WHEN cwl.Fourth_Call_Outcome IN('Recent doctor visit', 'Appointment Scheduled', 'Doc office issue', 'Incorrect doctor', 'Incorrect contact details')
                            THEN 'Do_Not_Call'
                            WHEN cwl.Fourth_Call_Outcome IN('No Response', 'Member Hang up', 'Other')
                            THEN 'First_Priority'
                            WHEN CWL.Fourth_Call_Outcome IN('Unwilling to schedule', 'Call back request')
                            THEN 'Second_Priority'
                            ELSE cwl.Fourth_Call_Outcome
                        END
                   WHEN cwl.Third_Call_Outcome IS NOT NULL and CWL.Third_Call_Outcome <> ''
                   THEN CASE
                            WHEN cwl.Third_Call_Outcome IN('Recent doctor visit', 'Appointment Scheduled', 'Doc office issue', 'Incorrect doctor', 'Incorrect contact details')
                            THEN 'Do_Not_Call'
                            WHEN cwl.Third_Call_Outcome IN('No Response', 'Member Hang up', 'Other')
                            THEN 'First_Priority'
                            WHEN CWL.Third_Call_Outcome IN('Unwilling to schedule', 'Call back request')
                            THEN 'Second_Priority'
                            ELSE cwl.Third_Call_Outcome
                        END
                   WHEN cwl.Second_Call_Outcome IS NOT NULL and CWL.Second_Call_Outcome <> ''
                   THEN CASE
                            WHEN cwl.second_call_outcome IN('Recent doctor visit', 'Appointment Scheduled', 'Doc office issue', 'Incorrect doctor', 'Incorrect contact details')
                            THEN 'Do_Not_Call'
                            WHEN cwl.second_Call_Outcome IN('No Response', 'Member Hang up', 'Other')
                            THEN 'First_Priority'
                            WHEN CWL.Second_Call_Outcome IN('Unwilling to schedule', 'Call back request')
                            THEN 'Second_Priority'
                           ELSE cwl.Second_Call_Outcome
                        END
                   WHEN cwl.First_Call_Outcome IS NOT NULL and CWL.First_Call_Outcome <> ''
                   THEN CASE
                            WHEN cwl.First_Call_Outcome IN('Recent doctor visit', 'Appointment Scheduled', 'Doc office issue', 'Incorrect doctor', 'Incorrect contact details')
                            THEN 'Do_Not_Call'
                            WHEN cwl.First_Call_Outcome IN('No Response', 'Member Hang up', 'Other')
                            THEN 'First_Priority'
                            WHEN cwl.First_Call_Outcome IN('Unwilling to schedule', 'Call back request')
                            THEN 'Second_Priority'
							when cwl.First_Call_Outcome is null 
							THEN 'First_Priority'
                            ELSE 'First_Priority'
                        END
						else 'First_Priority'
               END AS [Priority_Weight],
                    CASE
                        WHEN cwl.Fourth_Call_Outcome IS NOT NULL and CWL.Fourth_Call_Outcome <> ''
                        THEN cwl.Fourth_Call_Outcome
                        WHEN cwl.Third_Call_Outcome IS NOT NULL and CWL.Third_Call_Outcome <> ''
                        THEN cwl.Third_Call_Outcome
                        WHEN cwl.Second_Call_Outcome IS NOT NULL and CWL.Second_Call_Outcome <> ''
                        THEN cwl.Second_Call_Outcome
                        WHEN cwl.First_Call_Outcome IS NOT NULL and CWL.First_Call_Outcome <> ''
                        THEN cwl.First_Call_Outcome
                    END AS [Latest_Outcome],
                    --cwl.First_Call_Outcome AS [Latest_Outcome], 
                    CASE
                        WHEN cwl.Fourth_Call_Date IS NOT NULL and CWL.Fourth_Call_Date <> ''
                        THEN cwl.Fourth_Call_Date
                        WHEN cwl.Third_Call_Date IS NOT NULL and CWL.Third_Call_Date <> ''
                        THEN cwl.Third_Call_Date
                        WHEN cwl.Second_Call_Date IS NOT NULL and CWL.Second_Call_Date <> ''
                        THEN cwl.Second_Call_Date
                        WHEN cwl.First_Call_Date IS NOT NULL and CWL.First_Call_Date <> ''
                        THEN cwl.First_Call_Date
                    END AS [Latest_Action_Date],
                    CASE
                        WHEN cwl.First_Call_Date IS NOT NULL 
                        THEN 'Call'
						when cwl.First_Call_Date = '' then null
                        ELSE NULL
                    END AS [Latest_Action],  
                    --CWL.First_Call_Date AS [Latest_Action_Date], 
                    CASE
                        WHEN cwl.First_Call_Date IS NOT NULL
						THEN LEFT(cwl.srcFileName, 5)
						when cwl.First_Call_Date = '' then null
                        ELSE NULL
                    END AS [Latest_Rep]
       FROM [ACDW_CLMS_CCACO].dbo.vw_dashboard_AWV_NeedingVisit a
                  LEFT JOIN [adi].[copAceWorkList] CWL ON CWL.Subscriber_ID = a.HICN and loaddate = (select max(loaddate) from adi.copAceWorkList)
                  LEFT JOIN [adw].[QM_ResultByMember_History] QM ON a.HICN = QM.ClientMemberKey and qm.QMDate = (SELECT MAX(QMDate)  FROM [adw].[QM_ResultByMember_History]) and qm.QmCntCat = 'COP'
                  JOIN [ACDW_CLMS_CCACO].[adw].[M_MEMBER_ENR] b ON b.subscriber_id = a.HICN and b.m_alternate_number is not null and b.M_Mobile_Number is not null 
                  JOIN [ACDW_CLMS_CCACO].[dbo].[tmp_Physician_Phone_Numbers] c ON c.NPIInd = a.ACO_NPI and c.PrimaryOfficePhone <> ''
                  LEFT JOIN [ACDW_CLMS_CCACO].lst.List_PCP LPCP ON LPCP.PCP_NPI = A.ACO_NPI
                                                                   AND replace(replace(replace(replace(c.PrimaryOfficePhone, ')', ''), '(', ''), '-', ''), ' ', '') = LPCP.PCP_PHONE
  --group by a.HICN, a.LASTNAME,a.FIRSTNAME,a.DOB,M_Alternate_Number, M_Mobile_Number, ACO_NPI_NAME, PrimaryOfficePhone, PCP__ADDRESS, PCP__ADDRESS2,PCP_CITY,PCP_STATE,QmMsrId,cwl.Fourth_Call_Outcome, cwl.Third_Call_Outcome, cwl.Second_Call_Outcome, cwl.First_Call_Outcome, cwl.Fourth_Call_Date, cwl.Third_Call_Date, cwl.Second_Call_Date, CWL.First_Call_Date, cwl.srcFileName
           ) AS x
         WHERE x.memberphonenumber <> '|'
		 )
     SELECT distinct Y.LOB, 
            Y.ClientMemberKey, 
            Y.Member_Name, 
            Y.DOB, 
            Y.MemberPhoneNumber, 
            Y.PCP_Name, 
            Y.PcpPhoneNumber, 
            Y.PcpAddress, 
			Y.[Annual_Wellness _Visit],
            Measure = STUFF(
			(select '--'+t1.openmeasure from CTE t1
			where t1.clientmemberkey = y.clientmemberkey for xml path ('')),1,1,''), 
			case when len(STUFF(
			(select '--'+t1.openmeasure from CTE t1
			where t1.clientmemberkey = y.clientmemberkey for xml path ('')),1,1,'')) in ('24','28') then '2' when len(STUFF(
			(select '--'+t1.openmeasure from CTE t1
			where t1.clientmemberkey = y.clientmemberkey for xml path ('')),1,1,'')) > '50' then '3' else 1 end as Total_Gaps,
            Y.First_Contact_Type, 
            Y.First_Contact_Type_Date, 
            Y.First_Contact_Outcome, 
            Y.Second_Contact_Type, 
            Y.Second_Contact_Type_Date, 
            Y.Second_Contact_Outcome, 
            Y.Third_Contact_Type, 
            Y.Third_Contact_Type_Date, 
            Y.Third_Contact_Outcome, 
            Y.Fourth_Contact_Type, 
            Y.Fourth_Contact_Type_Date, 
            Y.Fourth_Contact_Outcome, 
            Y.Rep_Comment, 
            Y.Priority_Weight, 
            Y.Latest_Outcome, 
            Y.Latest_Action, 
            Y.Latest_Action_Date, 
            Y.Latest_Rep
     FROM CTE Y 
	 where y.Priority_Weight <> 'Do_Not_Call';