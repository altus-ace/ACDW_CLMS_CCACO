





CREATE PROCEDURE [adw].[sp_Ahr_Load_tmpAhrHL7ReportHeader] 

AS
BEGIN

	SET NOCOUNT ON;


IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Header]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[tmp_AHR_HL7_Report_Header]; 

CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Header](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[SubscriberNo] [varchar](50) NULL,
	[PCP_LastName] [varchar](100) NULL,
	[DOB] [date] NULL,
	[CurrentAge] [int] NULL,
	[Gender] [varchar](1) NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[PracticeID] [varchar] (50) NULL,
	[PracticeName] [varchar](100) NULL,
	[LOADDATE] [date] NULL,
	[LOADEDBY] [varchar](250) NULL
)

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Header] ADD  DEFAULT (sysdatetime()) FOR [LOADDATE]

ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Header] ADD  DEFAULT (suser_sname()) FOR [LOADEDBY]

	;WITH CTE AS(

		SELECT M_Last_Name,M_First_Name,[Subscriber_ID],NPI_Name,M_Date_Of_Birth,[Age] = DATEDIFF(hour,M_Date_Of_Birth,GETDATE())/8766
			,M_Gender,[M_Address_Line1_Res],[M_Address_Line2_Res],[M_City_Res],[M_State_Res],[M_Zip_Code_Res],TIN,TIN_NAME,row_number() over (order by (select NULL)) as [RowNo]
		FROM  adw.M_MEMBER_ENR a 
		LEFT JOIN (
			SELECT * 
			FROM (
				select a.* , ROW_NUMBER() over (partition by a.hicn order by tin desc) as ranks 
				from (
					select * from (
						select a.HICN, a.FirstName, a.LastName, a.Sex, a.DOB, b.TIN, b.TIN_NAME,  b.NPI, b.NPI_NAME , a.MBR_YEAR, a.MBR_QTR 
						,case when b.NPI_name is null then 0 else 1 end as match_npi , dense_rank() over (partition by a.hicn order by case when b.NPI_name is null then 0 else 1 end desc , a.PCSVS desc, a.tin desc, b.npi desc 
					) as rank
					FROM (
							select * 
							from adw.[Member_Practice_History] a
							where a.MBR_YEAR = (SELECT MAX(MBR_YEAR) AS Expr1
									FROM adw.Member_Practice_History AS Member_History_1)
							AND a.MBR_QTR = 
								(SELECT MAX(MBR_QTR)  AS Expr1
								FROM adw.Member_Practice_History  
								where MBR_YEAR = (SELECT MAX(MBR_YEAR) FROM  adw.Member_Practice_History)			  
								) 
						) a
					LEFT JOIN 
							(select * from adw.[Member_Provider_History] a
								where a.MBR_YEAR = (SELECT MAX(MBR_YEAR) AS Expr1
									FROM adw.Member_Practice_History AS Member_History_1)
							AND a.MBR_QTR = 
								(SELECT MAX(MBR_QTR) AS Expr1
								FROM adw.Member_Practice_History  
								where MBR_YEAR = (SELECT MAX(MBR_YEAR) AS Expr1 FROM adw.Member_Practice_History AS Member_History_1)
							 	)   
						) b  
					on a.hicn = b.hicn
						) z where rank = 1
					) a 
			) b where ranks = 1
		) b on a.SUBSCRIBER_ID = b.HICN
		 							
	)
		INSERT INTO [dbo].[tmp_AHR_HL7_Report_Header] 
			(
				[LastName],[FirstName],[SubscriberNo],[PCP_LastName],[DOB],[CurrentAge],[Gender],[Address1],[Address2],[City],[State],[Zip]
				,[PracticeID],[PracticeName]
			)
		SELECT  M_Last_Name,M_First_Name,[Subscriber_ID],tmp.NPI_Name,M_Date_Of_Birth,tmp.[Age]
				,M_Gender,[M_Address_Line1_Res],[M_Address_Line2_Res],[M_City_Res],[M_State_Res],[M_Zip_Code_Res],tmp.TIN,tmp.TIN_NAME
		FROM    CTE tmp
		INNER JOIN dbo.vw_tmp_AHR_Population ahr
		ON tmp.SUBSCRIBER_ID = ahr.HICN
              
END


