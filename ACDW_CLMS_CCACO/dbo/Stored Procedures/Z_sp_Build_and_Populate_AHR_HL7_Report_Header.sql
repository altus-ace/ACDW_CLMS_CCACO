
CREATE PROCEDURE [dbo].[Z_sp_Build_and_Populate_AHR_HL7_Report_Header]
AS
    BEGIN
        SET NOCOUNT ON;
        IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Header]', 'U') IS NOT NULL
            DROP TABLE [dbo].[tmp_AHR_HL7_Report_Header];
        CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Header]
        ([ID]           [INT] IDENTITY(1, 1) NOT NULL, 
         LASTNAME     [VARCHAR](100) NULL, 
         FIRSTNAME    [VARCHAR](100) NULL, 
         [SubscriberNo] [VARCHAR](50) NULL, 
         [PCP_LastName] [VARCHAR](100) NULL, 
         [DOB]          [DATE] NULL, 
         [CurrentAge]   [INT] NULL, 
         [Gender]       [VARCHAR](1) NULL, 
         [Address1]     [VARCHAR](100) NULL, 
         [Address2]     [VARCHAR](100) NULL, 
         [City]         [VARCHAR](50) NULL, 
         [State]        [VARCHAR](2) NULL, 
         [Zip]          [VARCHAR](10) NULL, 
         [PracticeID]   [INT] NULL, 
         [PracticeName] [VARCHAR](100) NULL, 
         [LOADDATE]     [DATE] NULL, 
         [LOADEDBY]     [VARCHAR](250) NULL
        );
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Header]
        ADD DEFAULT(SYSDATETIME()) FOR [LOADDATE];
        --GO;

        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Header]
        ADD DEFAULT(SUSER_SNAME()) FOR [LOADEDBY];
        --GO
        --Populate table

        WITH CTE
             AS (SELECT M_Last_Name, 
                        M_First_Name, 
                        [SUBSCRIBER_ID], 
                        NPI_NAME, 
                        M_Date_Of_Birth, 
                        [Age] = DATEDIFF(hour, M_Date_Of_Birth, GETDATE()) / 8766, 
                        M_Gender,

                        /*[Address1],[Address2],[City],[State],[Zip],*/

                        TIN, 
                        TIN_NAME, 
                        ROW_NUMBER() OVER(
                        ORDER BY
                 (
                     SELECT NULL
                 )) AS [RowNo]
                 FROM adw.M_MEMBER_ENR a
                      LEFT JOIN adw.vw_Mbr_Assigned_TIN_NPI b ON a.SUBSCRIBER_ID = b.HICN)
             INSERT INTO [dbo].[tmp_AHR_HL7_Report_Header]
             (LASTNAME, 
              FIRSTNAME, 
              [SubscriberNo], 
              [PCP_LastName], 
              [DOB], 
              [CurrentAge], 
              [Gender],

              /*[Address1],[Address2],[City],[State],[Zip]*/

              [PracticeID], 
              [PracticeName]
             )
                    SELECT M_Last_Name, 
                           M_First_Name, 
                           [Subscriber_ID], 
                           NPI_Name, 
                           M_Date_Of_Birth, 
                           DATEDIFF(hour, M_Date_Of_Birth, GETDATE()) / 8766 AS [Age], 
                           M_Gender,

                           /*'NULL','NULL','NULL','NULL','NULL',*/

                           TIN, 
                           TIN_NAME
                    FROM CTE;
    END;
