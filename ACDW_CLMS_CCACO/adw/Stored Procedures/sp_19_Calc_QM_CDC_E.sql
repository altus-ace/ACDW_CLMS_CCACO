CREATE PROCEDURE adw.[sp_19_Calc_QM_CDC_E] @years INT, 
                                       @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM VARCHAR(10)= 'CDC_E';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop AS TABLE(SUBSCRIBER_ID VARCHAR(20));
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
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetic Retinal Screening', '', '', concat('1/1/', @year), concat('12/31/', @year)) a
                 JOIN adw.tvf_get_provspec(18, 41, '', '', '', '') c ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID;

     --prior year negative result from screening by professional
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetic Retinal Screening', '', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1)) a
                 JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID
                FROM adw.tvf_get_claims_w_dates('', 'Diabetic Retinal Screening Negative', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1))
            ) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                 JOIN adw.tvf_get_provspec(18, 41, '', '', '', '') c ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID;

     --prior year diabetes mellitus without comp from screening by professional
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetic Retinal Screening', '', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1)) a
                 JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID
                FROM adw.tvf_get_claims_w_dates('', 'Diabetes Mellitus Without Complications', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1))
            ) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                 JOIN adw.tvf_get_provspec(18, 41, '', '', '', '') c ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID;

     --meas year diabetes ret screening with eye care professional value code
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetic Retinal Screening With Eye Care Professional', '', '', concat('1/1/', @year), concat('12/31/', @year)) a;

     --prior year diabetes ret screening with eye care professional value code with negative result
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetic Retinal Screening With Eye Care Professional', '', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1)) a
                 JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID
                FROM adw.tvf_get_claims_w_dates('', 'Diabetic Retinal Screening Negative', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1))
            ) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;

     --meas year screening negative result
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetic Retinal Screening Negative', '', '', concat('1/1/', @year), concat('12/31/', @year)) a;

     --unilateral eye enucleation with a bilateral modifier
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                 JOIN
            (
                SELECT DISTINCT 
                       SEQ_CLAIM_ID
                FROM adw.tvf_get_claims_w_dates('Bilateral', '', '', concat('1/1/', @year - 100), concat('12/31/', @year))
            ) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;

     --two unilateral eye enucleation 14 days or more apart
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                 JOIN
            (
                SELECT DISTINCT 
                       *
                FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation', '', '', concat('1/1/', @year - 100), concat('12/31/', @year))
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                   AND ABS(DATEDIFF(day, a.PRIMARY_SVC_DATE, b.PRIMARY_SVC_DATE)) >= 14;

     --two unilateral eye enucleation 14 days or more apart
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                 JOIN
            (
                SELECT DISTINCT 
                       *
                FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Left', '', '', concat('1/1/', @year - 100), concat('12/31/', @year))
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                   AND ABS(DATEDIFF(day, a.PRIMARY_SVC_DATE, b.PRIMARY_SVC_DATE)) >= 14;

     --two unilateral eye enucleation 14 days or more apart
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                 JOIN
            (
                SELECT DISTINCT 
                       *
                FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Right', '', '', concat('1/1/', @year - 100), concat('12/31/', @year))
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                   AND ABS(DATEDIFF(day, a.PRIMARY_SVC_DATE, b.PRIMARY_SVC_DATE)) >= 14;

     --left and right unilateral eye enucleation 
     INSERT INTO @table1
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Left', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                 JOIN
            (
                SELECT DISTINCT 
                       *
                FROM adw.tvf_get_claims_w_dates('Unilateral Eye Enucleation Right', '', '', concat('1/1/', @year - 100), concat('12/31/', @year))
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
     INSERT INTO @tablenumt
            SELECT DISTINCT 
                   *
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
