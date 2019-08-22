
CREATE PROCEDURE adw.Ahr_InsertMbrMissingCodes
AS

     /* Refactor question is the AHR only code? */

     -- DROPS tmp_MbrMissingCodes, creates, table, then loads table. THis is run during QM Processing of a data load.
     IF OBJECT_ID(N'[adw].[tmp_MbrMissingCodes]', 'U') IS NOT NULL
         DROP TABLE adw.tmp_MbrMissingCodes;
     CREATE TABLE adw.[tmp_MbrMissingCodes]
     ([SUBSCRIBER_ID]   [VARCHAR](50) NOT NULL, 
      [DiagCode]        [VARCHAR](20) NOT NULL, 
      [DiagDescription] [VARCHAR](500) NULL, 
      LoadDate DATE NOT NULL CONSTRAINT df_dboTmpMbrMissingCodes_LoadDate DEFAULT(CONVERT(DATE, GETDATE(), 101)), 
	 CreatedDate       DATETIME2 NOT NULL CONSTRAINT df_dboTmpMbrMissingCodes_CreatedDate DEFAULT(GETDATE()), 
      CreatedBy         VARCHAR(50) NOT NULL CONSTRAINT df_dboTmpMbrMissingCodes_createdBy DEFAULT(SYSTEM_USER), 
      PRIMARY KEY CLUSTERED([SUBSCRIBER_ID] ASC, [DiagCode] ASC)
      WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
     )
     ON [PRIMARY];
     INSERT INTO adw.tmp_MbrMissingCodes
     (SUBSCRIBER_ID, 
      DiagCode, 
      DiagDescription
     )
            SELECT a.SUBSCRIBER_ID, 
                   a.diagCode AS DXCODE, 
                   b.[ICD-10-CM_CODE_DESCRIPTION] AS DESCRIPTION
            FROM
            (
                SELECT a.SUBSCRIBER_ID, 
                       diagCode
                FROM adw.Claims_Diags a
                     JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                WHERE YEAR(b.PRIMARY_SVC_DATE) = YEAR(GETDATE()) - 1
                EXCEPT
                SELECT a.SUBSCRIBER_ID, 
                       diagCode
                FROM adw.Claims_Diags a
                     JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                WHERE YEAR(b.PRIMARY_SVC_DATE) = YEAR(GETDATE())
            ) a
            LEFT JOIN
            (
                SELECT b.[ICD-10-CM_CODE], 
                       b.[ICD-10-CM_CODE_DESCRIPTION]
                FROM lst.LIST_ICDCCS b
                WHERE b.Version = 'ICD10CM'
            ) AS b ON replace(a.diagCode, '.', '') = b.[ICD-10-CM_CODE];
