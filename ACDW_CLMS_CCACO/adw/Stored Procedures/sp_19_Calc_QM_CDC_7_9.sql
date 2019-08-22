CREATE PROCEDURE adw.[sp_19_Calc_QM_CDC_7_9] @years INT, 
                                         @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM9 VARCHAR(10)= 'CDC_9';
     DECLARE @QM7_9 VARCHAR(10)= 'CDC_8';
     DECLARE @QM7 VARCHAR(10)= 'CDC_7';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table3 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt9 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum9 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop9 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt7_9 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum7_9 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop7_9 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt7 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum7 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop7 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('12/31/', @year)) a
                 JOIN
            (
                SELECT DISTINCT 
                       SUBSCRIBER_ID
                FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', concat('1/1/', @year), concat('12/31/', @year))
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE AGE BETWEEN 18 AND 75;
     INSERT INTO @table2
            SELECT DISTINCT 
                   SUBSCRIBER_ID --, count(distinct SEQ_CLAIM_ID), count(distinct PRIMARY_SVC_DATE)
            FROM
            (
                SELECT A.*
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.tvf_get_claims_w_dates('Outpatient', 'ED', 'Nonacute Inpatient', concat('1/1/', @year - 1), concat('12/31/', @year))
                    UNION
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.tvf_get_claims_w_dates('Observation', '', '', concat('1/1/', @year - 1), concat('12/31/', @year))
                ) A
                INNER JOIN
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.tvf_get_claims_w_dates('Diabetes', '', '', concat('1/1/', @year - 1), concat('12/31/', @year))
                ) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
            ) C
            GROUP BY SUBSCRIBER_ID
            HAVING(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
                  AND (COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);
     INSERT INTO @table2
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID--, A.SEQ_CLAIM_ID
            FROM adw.tvf_get_claims_w_dates('Acute Inpatient', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) A
                 JOIN adw.tvf_get_claims_w_dates('Diabetes', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
     INSERT INTO @table2
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetes Medications', '', '', concat('1/1/', @year - 1), concat('12/31/', @year));
     INSERT INTO @table3
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM
            (
                SELECT *
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY PRIMARY_SVC_DATE DESC) AS rank
                    FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', concat('1/1/', @year), concat('12/31/', @year)) a
                ) b
                WHERE rank = 1
            ) a
            LEFT JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID, 
                       code
                FROM
                (
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           1 AS code
                    FROM adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0', '', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           2 AS code
                    FROM adw.tvf_get_claims_w_dates('', 'HbA1c Level 7.0-9.0', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           3 AS code
                    FROM adw.tvf_get_claims_w_dates('', '', 'HbA1c Level Greater Than 9.0', concat('1/1/', @year), concat('12/31/', @year))
                ) A
            ) C ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
            WHERE c.code IN(1, 2, 3);
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                 JOIN @table3 c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID;
     DELETE FROM @table1;
     DELETE FROM @table2;
     DELETE FROM @table3;
     INSERT INTO @table1 --num for 9 
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM
            (
                SELECT *
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY PRIMARY_SVC_DATE DESC) AS rank
                    FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', concat('1/1/', @year), concat('12/31/', @year)) a
                ) b
                WHERE rank = 1
            ) a
            LEFT JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID, 
                       code
                FROM
                (
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           1 AS code
                    FROM adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0', '', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           2 AS code
                    FROM adw.tvf_get_claims_w_dates('', 'HbA1c Level 7.0-9.0', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           3 AS code
                    FROM adw.tvf_get_claims_w_dates('', '', 'HbA1c Level Greater Than 9.0', concat('1/1/', @year), concat('12/31/', @year))
                ) A
            ) C ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
            WHERE c.code IN(1, 2);
     INSERT INTO @tablenumt9
            SELECT *
            FROM @table1;
     INSERT INTO @tablenum9
            SELECT a.*
            FROM @tablenumt9 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop9
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum9 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM9, 
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
                   @QM9, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum9;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM9, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop9;
     INSERT INTO @table2 --num for 7-9 
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM
            (
                SELECT *
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY PRIMARY_SVC_DATE DESC) AS rank
                    FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', concat('1/1/', @year), concat('12/31/', @year)) a
                ) b
                WHERE rank = 1
            ) a
            LEFT JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID, 
                       code
                FROM
                (
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           1 AS code
                    FROM adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0', '', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           2 AS code
                    FROM adw.tvf_get_claims_w_dates('', 'HbA1c Level 7.0-9.0', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           3 AS code
                    FROM adw.tvf_get_claims_w_dates('', '', 'HbA1c Level Greater Than 9.0', concat('1/1/', @year), concat('12/31/', @year))
                ) A
            ) C ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
            WHERE c.code IN(1);
     INSERT INTO @tablenumt7_9 --exclude results from 9 
            SELECT DISTINCT 
                   *
            FROM @table2
            EXCEPT
            SELECT DISTINCT 
                   *
            FROM @tablecareop9;
     INSERT INTO @tablenum7_9
            SELECT a.*
            FROM @tablenumt7_9 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop7_9
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum7_9 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM7_9, 
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
                   @QM7_9, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum7_9;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM7_9, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop7_9;
     INSERT INTO @table3 --num for 7
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM
            (
                SELECT *
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY PRIMARY_SVC_DATE DESC) AS rank
                    FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', concat('1/1/', @year), concat('12/31/', @year)) a
                ) b
                WHERE rank = 1
            ) a
            LEFT JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID, 
                       code
                FROM
                (
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           1 AS code
                    FROM adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0', '', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           2 AS code
                    FROM adw.tvf_get_claims_w_dates('', 'HbA1c Level 7.0-9.0', '', concat('1/1/', @year), concat('12/31/', @year))
                    UNION
                    SELECT DISTINCT 
                           SEQ_CLAIM_ID, 
                           3 AS code
                    FROM adw.tvf_get_claims_w_dates('', '', 'HbA1c Level Greater Than 9.0', concat('1/1/', @year), concat('12/31/', @year))
                ) A
            ) C ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
            WHERE c.code IN(2, 3);
     INSERT INTO @tablenumt7
            SELECT DISTINCT 
                   *
            FROM @table3;
     INSERT INTO @tablenum7
            SELECT a.*
            FROM @tablenumt7 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop7
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum7 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM7, 
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
                   @QM7, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum7;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM7, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop7;
