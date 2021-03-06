/****** Script for SelectTopNRows command from SSMS  ******/
USE [ACDW_CLMS_CCACO]
GO
-- Drop Tables
DROP TABLE adw.[tmp_PCPVisit_Last12]; 
DROP TABLE adw.[tmp_PCPVisit_Last18]; 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Create Tables
CREATE TABLE adw.[tmp_PCPVisit_Last12](
       [12_URN] [int] IDENTITY(1,1) NOT NULL,
       [SUBSCRIBER_ID][varchar](50) NULL,
       [LoadDate][date] NULL,
       [LoadBy][varchar](100) NULL,
CONSTRAINT [12_URN] PRIMARY KEY CLUSTERED 
(
       [12_URN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE adw.[tmp_PCPVisit_Last12] ADD  DEFAULT (sysdatetime()) FOR [LoadDate]
GO

ALTER TABLE adw.[tmp_PCPVisit_Last12] ADD  DEFAULT (suser_sname()) FOR [LoadBy]
GO



CREATE TABLE adw.[tmp_PCPVisit_Last18](
       [18_URN] [int] IDENTITY(1,1) NOT NULL,
       [SUBSCRIBER_ID][varchar](50) NULL,
       [LoadDate][date] NULL,
       [LoadBy][varchar](100) NULL,
CONSTRAINT [18_URN] PRIMARY KEY CLUSTERED 
(
       [18_URN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE adw.[tmp_PCPVisit_Last18] ADD  DEFAULT (sysdatetime()) FOR [LoadDate]
GO

ALTER TABLE adw.[tmp_PCPVisit_Last18] ADD  DEFAULT (suser_sname()) FOR [LoadBy]
GO

-- Insert Into Tables
INSERT INTO adw.[tmp_PCPVisit_Last12] ([SUBSCRIBER_ID])

SELECT  DISTINCT   
              B1.SUBSCRIBER_ID 
           --B1.SEQ_CLAIM_ID, 
           --B1.PRIMARY_SVC_DATE, 
    FROM adw.CLAIMS_HEADERS B1
         INNER JOIN
		 (	
                    SELECT DISTINCT 
                                         C6.SEQ_CLAIM_ID--,L5.VALUE_SET_NAME----wellness
                                  FROM adw.CLAIMS_DETAILS C6
                                  INNER JOIN 
                            (SELECT DISTINCT value_code from lst.List_HEDIS_CODE L6   WHERE L6.VALUE_code IN
                           ('99201',
                           '99202',
                           '99203',
                           '99204',
                           '99205',
                           '99211',
                           '99212',
                           '99213',
                           '99214',
                           '99215',
                           '99304',
                           '99305',
                           '99306',
                           '99307',
                           '99308',
                           '99309',
                           '99310',
                           '99315',
                           '99316',
                           '99318',
                           '99324',
                           '99325',
                           '99326',
                           '99327',
                           '99328',
                           '99334',
                           '99335',
                           '99336',
                           '99337',
                           '99339',
                           '99340',
                           '99341',
                           '99342',
                           '99343',
                           '99344',
                           '99345',
                           '99347',
                           '99348',
                           '99349',
                           '99350',
                           'G0402',
                           'G0438',
                           'G0439',
                           'G0463')
                 AND L6.ACTIVE = 'Y'
                 AND L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT'))L66 ON L66.VALUE_CODE = C6.PROCEDURE_CODE    

    ) AS D ON D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID 
       WHERE CONVERT(date,B1.PRIMARY_SVC_DATE) <= ( select CAST(GETDATE() AS DATE))
        and CONVERT(date,B1.PRIMARY_SVC_DATE) >= ( select DATEADD(MONTH, -12, CAST(GETDATE() AS DATE)))
GO

INSERT INTO adw.[tmp_PCPVisit_Last18] ([SUBSCRIBER_ID])

SELECT  DISTINCT   
              B1.SUBSCRIBER_ID 
           --B1.SEQ_CLAIM_ID, 
           --B1.PRIMARY_SVC_DATE 
    FROM adw.CLAIMS_HEADERS B1
         INNER JOIN
		 (	
                    SELECT DISTINCT 
                                  C6.SEQ_CLAIM_ID--,L5.VALUE_SET_NAME
                                  FROM adw.CLAIMS_DETAILS C6
                                  INNER JOIN 
                            (SELECT DISTINCT value_code FROM lst.List_HEDIS_CODE L6   WHERE L6.VALUE_code IN
                           ('99201',
                           '99202',
                           '99203',
                           '99204',
                           '99205',
                           '99211',
                           '99212',
                           '99213',
                           '99214',
                           '99215',
                           '99304',
                           '99305',
                           '99306',
                           '99307',
                           '99308',
                           '99309',
                           '99310',
                           '99315',
                           '99316',
                           '99318',
                           '99324',
                           '99325',
                           '99326',
                           '99327',
                           '99328',
                           '99334',
                           '99335',
                           '99336',
                           '99337',
                           '99339',
                           '99340',
                           '99341',
                           '99342',
                           '99343',
                           '99344',
                           '99345',
                           '99347',
                           '99348',
                           '99349',
                           '99350',
                           'G0402',
                           'G0438',
                           'G0439',
                           'G0463')
                 AND L6.ACTIVE = 'Y'
                 AND L6.VALUE_CODE_SYSTEM IN('CPT', 'CPT-CAT-II', 'HCPCS', 'CDT'))L66 ON L66.VALUE_CODE = C6.PROCEDURE_CODE    

    ) AS D ON D.SEQ_CLAIM_ID = B1.SEQ_CLAIM_ID 
       WHERE CONVERT(date,B1.PRIMARY_SVC_DATE) <= ( select CAST(GETDATE() AS DATE))
        and CONVERT(date,B1.PRIMARY_SVC_DATE) >= ( select DATEADD(MONTH, -18, CAST(GETDATE() AS DATE)))
GO
