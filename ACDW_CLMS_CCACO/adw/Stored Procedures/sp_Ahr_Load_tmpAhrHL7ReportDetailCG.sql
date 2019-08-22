


CREATE PROCEDURE [adw].[sp_Ahr_Load_tmpAhrHL7ReportDetailCG]
AS
    BEGIN
        SET NOCOUNT ON;
        IF OBJECT_ID('[dbo].[tmp_AHR_HL7_Report_Detail_CG]', 'U') IS NOT NULL
            DROP TABLE [dbo].[tmp_AHR_HL7_Report_Detail_CG];
        CREATE TABLE [dbo].[tmp_AHR_HL7_Report_Detail_CG]
        ([ID]            [INT] IDENTITY(1000, 1) NOT NULL, 
         [SUBSCRIBER_ID] [VARCHAR](50) NULL, 
         [CGQM]          [VARCHAR](10) NULL, 
         [CGQMDESC]      [VARCHAR](150) NULL, 
         [LOADDATE]      [DATETIME] NULL, 
         [LOADEDBY]      [VARCHAR](100) NULL
        );
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_CG]
        ADD DEFAULT(SYSDATETIME()) FOR [LOADDATE];
        ALTER TABLE [dbo].[tmp_AHR_HL7_Report_Detail_CG]
        ADD DEFAULT(SUSER_SNAME()) FOR [LOADEDBY];
        WITH CTE
             AS (SELECT DISTINCT 
                        ClientMemberKey AS SUBSCRIBER_ID, 
                        QmMsrId AS CGQM, 
                        b.[AHR_QM_DESC] AS CGQMDESC
                 FROM
                 (
                     SELECT src.ClientMemberKey, 
                            src.QmMsrId, 
                            src.MsrDen, 
                            src.MsrNum,
                            CASE
                                WHEN MsrDen - MsrNum = 1
                                THEN 1
                                ELSE 0
                            END [GAP]
                     FROM
                     (
                         SELECT ClientMemberKey, 
                                QmMsrId, 
                                case when SUM(CASE
                                        WHEN(QmCntCat = 'DEN')
                                        THEN 1
                                        ELSE 0
                                    END) >=1 then 1 else 0 end AS MsrDen, 
                               case when SUM(CASE
                                        WHEN(QmCntCat = 'NUM')
                                        THEN 1
                                        ELSE 0
                                    END) >=1 then 1 else 0 end AS MsrNum
                         FROM adw.QM_ResultByMember_CL
                         GROUP BY ClientMemberKey, 
                                  QmMsrId
                     ) src
                     JOIN dbo.vw_tmp_AHR_Population

                     /*Active_Members*/

                     m ON src.ClientMemberKey = m.HICN
                 ) co
                 LEFT JOIN lst.LIST_QM_Mapping b ON co.QmMsrId = b.QM
                 LEFT JOIN lst.LIST_AHRTIPS c ON co.QmMsrId = c.QM_ID
                 WHERE [Gap] = 1
                       AND b.ACTIVE = 'Y')
             INSERT INTO [dbo].[tmp_AHR_HL7_Report_Detail_CG]
             ([SUBSCRIBER_ID], 
              [CGQM], 
              [CGQMDESC]
             )
                    SELECT [SUBSCRIBER_ID], 
                           [CGQM], 
                           [CGQMDESC]
                    FROM CTE
                    ORDER BY [SUBSCRIBER_ID], 
                             [CGQM];
    END;


