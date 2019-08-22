
--EXEC sp_ART 2018, 'UHC'

CREATE PROCEDURE adw.[sp_19_Calc_QM_ART] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM VARCHAR(10)= 'ART';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('12/31/', @year))
            WHERE AGE BETWEEN 18 AND 120;
     INSERT INTO @table2
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT DISTINCT 
                       A.SUBSCRIBER_ID, 
                       A.SEQ_CLAIM_ID, 
                       A.PRIMARY_SVC_DATE
                FROM adw.tvf_get_claims_w_dates('Outpatient', '', '', concat('1/1/', @year), concat('11/30/', @year)) a
                     JOIN adw.tvf_get_claims_w_dates('Rheumatoid Arthritis', '', '', concat('1/1/', @year), concat('11/30/', @year)) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
                UNION
                SELECT DISTINCT 
                       A.SUBSCRIBER_ID, 
                       A.SEQ_CLAIM_ID, 
                       A.PRIMARY_SVC_DATE
                FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('1/1/', @year), concat('11/30/', @year)) a
                     JOIN adw.tvf_get_claims_w_dates('Rheumatoid Arthritis', '', '', concat('1/1/', @year), concat('11/30/', @year)) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
                     JOIN adw.tvf_get_claims_w_dates('Nonacute Inpatient', '', '', concat('1/1/', @year), concat('11/30/', @year)) C ON A.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID
            ) X
            GROUP BY SUBSCRIBER_ID
            HAVING COUNT(DISTINCT SEQ_CLAIM_ID) >= 2
                   AND COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2;
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('DMARD', 'DMARD Medications', '', concat('1/1/', @year), concat('12/31/', @year)) a;
     INSERT INTO @tablenumt
            SELECT *
            FROM @table1;
     INSERT INTO @tablenum
            SELECT a.*
            FROM @tablenumt a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM, 
                   'DEN', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tableden;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop;
