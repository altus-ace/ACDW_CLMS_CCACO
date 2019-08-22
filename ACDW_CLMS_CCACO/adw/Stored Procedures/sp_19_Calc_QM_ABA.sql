--EXEC sp_ABA 2018, 'UHC'

CREATE PROCEDURE adw.[sp_19_Calc_QM_ABA] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM VARCHAR(10)= 'ABA';
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
            FROM adw.tvf_get_active_members2(concat('1/1/', @year - 1))
            WHERE AGE >= 18
            INTERSECT
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('12/31/', @year))
            WHERE AGE <= 74;
     INSERT INTO @table2
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Outpatient', '', '', concat('1/1/', @year - 1), concat('12/31/', @year));
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('BMI', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) A
            WHERE CASE
                      WHEN A.[SUBSCRIBER_ID] IN
            (
                SELECT B.SUBSCRIBER_ID
                FROM adw.tvf_get_age2(20, 74, CONVERT(VARCHAR, CONVERT(DATETIME, A.PRIMARY_SVC_DATE), 101)) B
            )
                      THEN 1
                      ELSE 0
                  END = 1;
     INSERT INTO @table2
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID--, A.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
            FROM adw.tvf_get_claims_w_dates('BMI Percentile', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) A
            WHERE CASE
                      WHEN A.[SUBSCRIBER_ID] IN
            (
                SELECT B.SUBSCRIBER_ID
                FROM adw.tvf_get_age2(0, 19, CONVERT(VARCHAR, CONVERT(DATETIME, A.PRIMARY_SVC_DATE), 101)) B
            )
                      THEN 1
                      ELSE 0
                  END = 1;
     INSERT INTO @tablenumt
            SELECT *
            FROM @table1
            UNION
            SELECT *
            FROM @table2;
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
