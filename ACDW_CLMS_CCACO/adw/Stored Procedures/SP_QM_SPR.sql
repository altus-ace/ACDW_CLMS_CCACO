CREATE PROCEDURE adw.[SP_QM_SPR]
AS
     IF OBJECT_ID('tmp_QM_SPR_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_SPR_DEN;
     CREATE TABLE tmp_QM_SPR_DEN(member VARCHAR(50));

     --Create temp table for member, episode dates and minimum episode dates, and 730 days prior date from EISD in 

     IF OBJECT_ID('tmp_QM_SPR_EPISODE', 'U') IS NOT NULL
         DROP TABLE tmp_QM_SPR_EPISODE;
     CREATE TABLE tmp_QM_SPR_EPISODE
     (member      VARCHAR(50), 
      IESD_date   DATE, 
      prior730day DATE
     );
     IF OBJECT_ID('tmp_QM_SPR_EPISODE2', 'U') IS NOT NULL
         DROP TABLE tmp_QM_SPR_EPISODE2;
     CREATE TABLE tmp_QM_SPR_EPISODE2
     (member    VARCHAR(50), 
      IESD_date DATE
     );
     INSERT INTO tmp_QM_SPR_EPISODE
            SELECT D.SUBSCRIBER_ID, 
                   D.EPISODE_DATE, 
                   D.prior730days
            FROM
            (
                SELECT DISTINCT 
                       C.SUBSCRIBER_ID, 
                       C.EPISODE_DATE, 
                       DATEADD(day, -730, c.EPISODE_DATE) AS prior730days
                FROM
                (
                    SELECT DISTINCT 
                           B.SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           EPISODE_DATE, 
                           DENSE_RANK() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY EPISODE_DATE) AS rank
                    FROM
                    (
                        SELECT A.SUBSCRIBER_ID, 
                               A.SEQ_CLAIM_ID, 
                               A.PRIMARY_SVC_DATE AS EPISODE_DATE
                        FROM
                        (
                            SELECT DISTINCT 
                                   A.SUBSCRIBER_ID, 
                                   A.SEQ_CLAIM_ID, 
                                   A.PRIMARY_SVC_DATE
                            FROM adw.tvf_get_claims_w_dates('ED', '', '', '07/01/2017', '06/30/2018') a
                                 JOIN adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', '07/01/2017', '06/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                        --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
                            EXCEPT
                            (
                                SELECT DISTINCT 
                                       A.SUBSCRIBER_ID, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.tvf_get_claims_w_dates('ED', '', '', '07/01/2017', '06/30/2018') a
                                     JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '07/01/2017', '06/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                UNION
                                SELECT DISTINCT 
                                       A.SUBSCRIBER_ID, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.tvf_get_claims_w_dates('ED', '', '', '07/01/2017', '06/30/2018') a
                                     JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '07/01/2017', '06/30/2018') b ON(ABS(DATEDIFF(day, b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <= 1)
                                                                                                                               AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                                                                                                                               AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                            )
                        ) A
                        UNION
                        --Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
                        (
                            SELECT DISTINCT 
                                   A.SUBSCRIBER_ID, 
                                   A.SEQ_CLAIM_ID, 
                                   a.SVC_TO_DATE AS EpisodeDate
                            FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '07/01/2017', '06/30/2018') a
                                 JOIN adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', '07/01/2017', '06/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                 JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '07/01/2017', '06/30/2018') c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                                                            AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                                                            AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                                                            AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
                            WHERE A.SEQ_CLAIM_ID NOT IN
                            (
                                SELECT SEQ_CLAIM_ID
                                FROM adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '', '07/01/2017', '06/30/2018') b
                            )
                        )
                    ) B
                ) C
                WHERE C.rank = 1
            ) D;
     INSERT INTO tmp_QM_SPR_EPISODE2
            SELECT E.SUBSCRIBER_ID, 
                   E.EPISODE_DATE
            FROM
            (
                SELECT DISTINCT 
                       C.SUBSCRIBER_ID, 
                       C.EPISODE_DATE
                FROM
                (
                    SELECT DISTINCT 
                           B.SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           EPISODE_DATE, 
                           DENSE_RANK() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY EPISODE_DATE) AS rank
                    FROM
                    (
                        SELECT A.SUBSCRIBER_ID, 
                               A.SEQ_CLAIM_ID, 
                               A.PRIMARY_SVC_DATE AS EPISODE_DATE
                        FROM
                        (
                            SELECT DISTINCT 
                                   A.SUBSCRIBER_ID, 
                                   A.SEQ_CLAIM_ID, 
                                   A.PRIMARY_SVC_DATE
                            FROM adw.tvf_get_claims_w_dates('ED', '', '', '01/01/1900', '06/30/2018') a
                                 JOIN adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', '01/01/1900', '06/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                        --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
                            EXCEPT
                            (
                                SELECT DISTINCT 
                                       A.SUBSCRIBER_ID, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.tvf_get_claims_w_dates('ED', '', '', '01/01/1900', '06/30/2018') a
                                     JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/1900', '06/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                UNION
                                SELECT DISTINCT 
                                       A.SUBSCRIBER_ID, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.tvf_get_claims_w_dates('ED', '', '', '01/01/1900', '06/30/2018') a
                                     JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/1900', '06/30/2018') b ON(ABS(DATEDIFF(day, b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <= 1)
                                                                                                                               AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                                                                                                                               AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                            )
                        ) A
                        UNION
                        --Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
                        (
                            SELECT DISTINCT 
                                   A.SUBSCRIBER_ID, 
                                   A.SEQ_CLAIM_ID, 
                                   a.SVC_TO_DATE AS EpisodeDate
                            FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/1900', '06/30/2018') a
                                 JOIN adw.tvf_get_claims_w_dates('COPD', 'Emphysema', 'Chronic Bronchitis', '01/01/1900', '06/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                 JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/1900', '06/30/2018') c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                                                            AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                                                            AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                                                            AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
                            WHERE A.SEQ_CLAIM_ID NOT IN
                            (
                                SELECT SEQ_CLAIM_ID
                                FROM adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '', '01/01/1900', '06/30/2018') b
                            )
                        )
                    ) B
                ) C
                WHERE C.rank = 1
            ) E;

     --Denominator: 40 years or older on jan of meas year
     INSERT INTO tmp_QM_SPR_DEN
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT SUBSCRIBER_ID, 
                       DOB, 
                       DATEDIFF(year, DOB, CONVERT(DATE, '01/31/2018', 101)) AS years
                FROM
                (
                    SELECT *
                    FROM adw.tvf_get_active_members(1)
                ) A
            ) a
            WHERE DATEDIFF(year, DOB, CONVERT(DATE, '01/31/2018', 101)) BETWEEN 42 AND 120
            INTERSECT
            SELECT DISTINCT 
                   member
            FROM
            (
                SELECT A.member,
                       CASE
                           WHEN B.IESD_date <= A.prior730day
                           THEN 0
                           ELSE 1
                       END AS is_den
                FROM tmp_QM_SPR_EPISODE A
                     LEFT JOIN tmp_QM_SPR_EPISODE2 B ON A.member = B.member
            ) A
            WHERE is_den = 1;

     -----------------numerator

     IF OBJECT_ID('tmp_QM_SPR_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_SPR_NUM_T;
     CREATE TABLE tmp_QM_SPR_NUM_T(member VARCHAR(50));

     --Numerator step 1 
     INSERT INTO tmp_QM_SPR_NUM_T
            SELECT DISTINCT 
                   member
            FROM
            (
                SELECT DISTINCT 
                       A.member, 
                       A.IESD_date, 
                (
                    SELECT COUNT(B.SEQ_CLAIM_ID)
                    FROM adw.tvf_get_claims_w_dates('Spirometry', '', '', '01/01/1900', '06/30/2018') B
                    WHERE A.member = B.SUBSCRIBER_ID
                ) AS cnt
                FROM
                (
                    SELECT *
                    FROM
                    (
                        SELECT A.member, 
                               A.IESD_date, 
                               A.prior730day,
                               CASE
                                   WHEN B.IESD_date <= A.prior730day
                                   THEN 0
                                   ELSE 1
                               END AS is_den
                        FROM tmp_QM_SPR_EPISODE A
                             LEFT JOIN tmp_QM_SPR_EPISODE2 B ON A.member = B.member
                    ) A
                    WHERE is_den = 1
                ) A
            ) Z
            WHERE cnt >= 1;
     IF OBJECT_ID('tmp_QM_SPR_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_SPR_NUM;
     CREATE TABLE tmp_QM_SPR_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_SPR_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_SPR_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_SPR_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('SPR', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_SPR_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_SPR_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
