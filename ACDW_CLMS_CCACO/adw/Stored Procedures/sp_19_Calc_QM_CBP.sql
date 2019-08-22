CREATE PROCEDURE adw.[sp_19_Calc_QM_CBP] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM VARCHAR(10)= 'CBP';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE
     (SUBSCRIBER_ID VARCHAR(20), 
      maxdate       DATE
     );
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('1/1/', @year - 1)) a
            WHERE AGE BETWEEN 18 AND 85;
     INSERT INTO @table2
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID, 
                   MAX(a.PRIMARY_SVC_DATE) AS maxdate
            FROM adw.tvf_get_claims_w_dates('Outpatient Without UBREV', 'Telephone Visits', 'Online Assessments', concat('1/1/', @year - 1), concat('12/31/', @year)) a
                 JOIN adw.tvf_get_claims_w_dates('Essential Hypertension', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT a.PRIMARY_SVC_DATE) >= 2;
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
     DELETE FROM @table1;

     --select * from @tableden
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Systolic Less Than 140', '', '', concat('1/1/', @year), concat('12/31/', @year)) a
                 JOIN adw.tvf_get_claims_w_dates('Diastolic Less Than 80', 'Diastolic 80-89', '', concat('1/1/', @year), concat('12/31/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                 JOIN @table2 c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                   AND a.PRIMARY_SVC_DATE >= c.maxdate;
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
