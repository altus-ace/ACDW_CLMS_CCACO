
CREATE PROCEDURE adw.[SP_QM_CDC_8]
AS
     IF OBJECT_ID('tmp_QM_CDC_DEN_1', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_DEN_1;
     CREATE TABLE tmp_QM_CDC_DEN_1(member VARCHAR(50));
     INSERT INTO tmp_QM_CDC_DEN_1
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT SUBSCRIBER_ID, 
                       DOB, 
                       DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) AS years
                FROM
                (
                    SELECT *
                    FROM adw.tvf_get_active_members(1)
                ) A
            ) a
            WHERE DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 18 AND 75;

     -------------------

     IF OBJECT_ID('tmp_QM_CDC_DEN_2', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_DEN_2;
     CREATE TABLE tmp_QM_CDC_DEN_2(member VARCHAR(50));
     INSERT INTO tmp_QM_CDC_DEN_2
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
                    FROM adw.tvf_get_claims_w_dates('Outpatient', 'ED', 'Nonacute Inpatient', '1/1/2017', '12/31/2018')
                    UNION
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.tvf_get_claims_w_dates('Observation', '', '', '1/1/2017', '12/31/2018')
                ) A
                INNER JOIN
                (
                    SELECT SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.tvf_get_claims_w_dates('Diabetes', '', '', '1/1/2017', '12/31/2018')
                ) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
            ) C
            GROUP BY SUBSCRIBER_ID
            HAVING(COUNT(DISTINCT SEQ_CLAIM_ID) >= 2)
                  AND (COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2);

     --den 3 
     IF OBJECT_ID('tmp_QM_CDC_DEN_3', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_DEN_3;
     CREATE TABLE tmp_QM_CDC_DEN_3
     (member VARCHAR(50), 
      claim  VARCHAR(50)
     );
     INSERT INTO tmp_QM_CDC_DEN_3
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID, 
                   A.SEQ_CLAIM_ID
            FROM adw.tvf_get_claims_w_dates('Acute Inpatient', '', '', '1/1/2017', '12/31/2018') A;
     IF OBJECT_ID('tmp_QM_CDC_DEN_4', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_DEN_4;
     CREATE TABLE tmp_QM_CDC_DEN_4
     (member VARCHAR(50), 
      claim  VARCHAR(50)
     );
     INSERT INTO tmp_QM_CDC_DEN_4
            SELECT A.SUBSCRIBER_ID, 
                   A.SEQ_CLAIM_ID
            FROM adw.tvf_get_claims_w_dates('Diabetes', '', '', '1/1/2017', '12/31/2018') A;
     IF OBJECT_ID('tmp_QM_CDC_DEN_5', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_DEN_5;
     CREATE TABLE tmp_QM_CDC_DEN_5(member VARCHAR(50));
     INSERT INTO tmp_QM_CDC_DEN_5
            SELECT a.member
            FROM
            (
                SELECT *
                FROM tmp_QM_CDC_DEN_3
                INTERSECT
                SELECT *
                FROM tmp_QM_CDC_DEN_4
            ) a;

     --den6
     IF OBJECT_ID('tmp_QM_CDC_DEN_6', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_DEN_6;
     CREATE TABLE tmp_QM_CDC_DEN_6(member VARCHAR(50));
     INSERT INTO tmp_QM_CDC_DEN_6
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Diabetes Medications', '', '', '1/1/2017', '12/31/2018');

     --den1 intersect (den2,den5,den6)

     IF OBJECT_ID('tmp_QM_CDC_8_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_8_DEN;
     CREATE TABLE tmp_QM_CDC_8_DEN(member VARCHAR(50));
     INSERT INTO tmp_QM_CDC_8_DEN
            SELECT *
            FROM tmp_QM_CDC_DEN_1
            INTERSECT
            (
                SELECT *
                FROM tmp_QM_CDC_DEN_2
                UNION
                SELECT *
                FROM tmp_QM_CDC_DEN_5
                UNION
                SELECT *
                FROM tmp_QM_CDC_DEN_6
            );

     -----------------numerator

     IF OBJECT_ID('tmp_QM_CDC_8_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_8_NUM_T;
     CREATE TABLE tmp_QM_CDC_8_NUM_T(member VARCHAR(50));
     INSERT INTO tmp_QM_CDC_8_NUM_T
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', '1/1/2017', '12/31/2018') a
                 JOIN
            (
                SELECT *
                FROM
                (
                    SELECT DISTINCT 
                           SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE, 
                           DENSE_RANK() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY PRIMARY_SVC_DATE DESC) AS rank, 
                           code
                    FROM
                    (
                        SELECT DISTINCT 
                               SUBSCRIBER_ID, 
                               SEQ_CLAIM_ID, 
                               PRIMARY_SVC_DATE, 
                               'HbA1c Level Less Than 7.0' AS code
                        FROM adw.tvf_get_claims_w_dates('HbA1c Level Less Than 7.0', '', '', '1/1/2018', '12/31/2018')
                        UNION
                        SELECT DISTINCT 
                               SUBSCRIBER_ID, 
                               SEQ_CLAIM_ID, 
                               PRIMARY_SVC_DATE, 
                               'HbA1c Level Greater Than 9.0' AS code
                        FROM adw.tvf_get_claims_w_dates('', 'HbA1c Level Greater Than 9.0', '', '1/1/2018', '12/31/2018')
                        UNION
                        SELECT DISTINCT 
                               SUBSCRIBER_ID, 
                               SEQ_CLAIM_ID, 
                               PRIMARY_SVC_DATE, 
                               'HbA1c Level 7.0-9.0' AS code
                        FROM adw.tvf_get_claims_w_dates('', '', 'HbA1c Level 7.0-9.0', '1/1/2018', '12/31/2018')
                    ) A
                ) C
                WHERE rank = 1
                      AND code = 'HbA1c Level Less Than 7.0'
            ) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
     IF OBJECT_ID('tmp_QM_CDC_8_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_8_NUM;
     CREATE TABLE tmp_QM_CDC_8_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_8_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CDC_8', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
