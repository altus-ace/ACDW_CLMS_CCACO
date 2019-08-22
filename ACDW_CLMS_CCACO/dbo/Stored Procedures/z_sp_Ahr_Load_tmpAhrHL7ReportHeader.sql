CREATE PROCEDURE [dbo].[z_sp_Ahr_Load_tmpAhrHL7ReportHeader]
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
         [PracticeID]   [VARCHAR](50) NULL, 
         [PracticeName] [VARCHAR](100) NULL, 
         [LOADDATE]     [DATE] NULL, 
         [LOADEDBY]     [VARCHAR](250) NULL
        );
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Header]
        ADD DEFAULT(SYSDATETIME()) FOR [LOADDATE];
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Header]
        ADD DEFAULT(SUSER_SNAME()) FOR [LOADEDBY];
        WITH CTE
             AS (SELECT M_Last_Name, 
                        M_First_Name, 
                        [SUBSCRIBER_ID], 
                        NPI_NAME, 
                        M_Date_Of_Birth, 
                        [Age] = DATEDIFF(hour, M_Date_Of_Birth, GETDATE()) / 8766, 
                        M_Gender, 
                        [M_Address_Line1_Res], 
                        [M_Address_Line2_Res], 
                        [M_City_Res], 
                        [M_State_Res], 
                        [M_Zip_Code_Res], 
                        TIN, 
                        TIN_NAME, 
                        ROW_NUMBER() OVER(
                        ORDER BY
                 (
                     SELECT NULL
                 )) AS [RowNo]
                 FROM adw.M_MEMBER_ENR a
                      LEFT JOIN
                 (
                     SELECT *
                     FROM
                     (
                         SELECT a.*, 
                                ROW_NUMBER() OVER(PARTITION BY a.HICN
                                ORDER BY TIN DESC) AS ranks
                         FROM
                         (
                             SELECT *
                             FROM
                             (
                                 SELECT a.HICN, 
                                        a.FIRSTNAME, 
                                        a.LASTNAME, 
                                        a.SEX, 
                                        a.DOB, 
                                        b.TIN, 
                                        b.TIN_NAME, 
                                        b.NPI, 
                                        b.NPI_NAME, 
                                        a.MBR_YEAR, 
                                        a.MBR_QTR,
                                        CASE
                                            WHEN b.NPI_NAME IS NULL
                                            THEN 0
                                            ELSE 1
                                        END AS match_npi, 
                                        DENSE_RANK() OVER(PARTITION BY a.HICN
                                        ORDER BY CASE
                                                     WHEN b.NPI_NAME IS NULL
                                                     THEN 0
                                                     ELSE 1
                                                 END DESC, 
                                                 a.PCSVS DESC, 
                                                 a.TIN DESC, 
                                                 b.NPI DESC) AS rank
                                 FROM
                                 (
                                     SELECT *
                                     FROM adw.Member_Practice_History a
                                     WHERE a.MBR_YEAR =
                                     (
                                         SELECT MAX(MBR_YEAR) AS Expr1
                                         FROM adw.Member_Practice_History AS Member_History_1
                                     )
                                           AND a.MBR_QTR =
                                     (
                                         SELECT MAX(MBR_QTR) AS Expr1
                                         FROM adw.Member_Practice_History
                                         WHERE MBR_YEAR =
                                         (
                                             SELECT MAX(MBR_YEAR)
                                             FROM adw.Member_Practice_History
                                         )
                                     )
                                 ) a
                                 LEFT JOIN
                                 (
                                     SELECT *
                                     FROM adw.Member_Provider_History a
                                     WHERE a.MBR_YEAR =
                                     (
                                         SELECT MAX(MBR_YEAR) AS Expr1
                                         FROM adw.Member_Practice_History AS Member_History_1
                                     )
                                           AND a.MBR_QTR =
                                     (
                                         SELECT MAX(MBR_QTR) AS Expr1
                                         FROM adw.Member_Practice_History
                                         WHERE MBR_YEAR =
                                         (
                                             SELECT MAX(MBR_YEAR) AS Expr1
                                             FROM adw.Member_Practice_History AS Member_History_1
                                         )
                                     )
                                 ) b ON a.HICN = b.HICN
                             ) z
                             WHERE rank = 1
                         ) a
                     ) b
                     WHERE ranks = 1
                 ) b ON a.SUBSCRIBER_ID = b.HICN)
             INSERT INTO [dbo].[tmp_AHR_HL7_Report_Header]
             (LASTNAME, 
              FIRSTNAME, 
              [SubscriberNo], 
              [PCP_LastName], 
              [DOB], 
              [CurrentAge], 
              [Gender], 
              [Address1], 
              [Address2], 
              [City], 
              [State], 
              [Zip], 
              [PracticeID], 
              [PracticeName]
             )
                    SELECT M_Last_Name, 
                           M_First_Name, 
                           [Subscriber_ID], 
                           tmp.NPI_Name, 
                           M_Date_Of_Birth, 
                           tmp.[Age], 
                           M_Gender, 
                           [M_Address_Line1_Res], 
                           [M_Address_Line2_Res], 
                           [M_City_Res], 
                           [M_State_Res], 
                           [M_Zip_Code_Res], 
                           tmp.TIN, 
                           tmp.TIN_NAME
                    FROM CTE tmp
                         INNER JOIN dbo.zvw_tmp_AHR_Population ahr ON tmp.SUBSCRIBER_ID = ahr.HICN;
    END;
