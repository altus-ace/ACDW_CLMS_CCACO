
CREATE PROCEDURE adw.[SP_QM_ABA]
AS
     IF OBJECT_ID('tmp_QM_ABA_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ABA_DEN;
     CREATE TABLE tmp_QM_ABA_DEN(member VARCHAR(50));
     --Denominator: --18 years as of January 1 of the year prior to the measurement year to 74 years as of December 31 of the measurement year.
     INSERT INTO tmp_QM_ABA_DEN
            SELECT *
            FROM
            (
                SELECT DISTINCT 
                       SUBSCRIBER_ID
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           DOB
                    FROM
                    (
                        SELECT DISTINCT 
                               SUBSCRIBER_ID, 
                               DOB
                        FROM
                        (
                            SELECT SUBSCRIBER_ID, 
                                   DOB
                            FROM adw.tvf_get_active_members(1)
                        ) aa
                    ) a
                ) A
                WHERE DATEDIFF(year, DOB, CONVERT(DATE, '01/01/2017', 101)) >= 18
                INTERSECT
                SELECT DISTINCT 
                       SUBSCRIBER_ID
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           DOB
                    FROM
                    (
                        SELECT DISTINCT 
                               SUBSCRIBER_ID, 
                               DOB
                        FROM
                        (
                            SELECT SUBSCRIBER_ID, 
                                   DOB
                            FROM adw.tvf_get_active_members(1)
                        ) aa
                    ) a
                ) A
                WHERE DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) <= 74
            ) A
            WHERE A.SUBSCRIBER_ID IN
            (
                SELECT DISTINCT 
                       b.SUBSCRIBER_ID
                FROM adw.tvf_get_claims_w_dates('Outpatient', '', '', '1/1/2017', '12/31/2018') b
            );

     -----------------numerator

     IF OBJECT_ID('tmp_QM_ABA_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ABA_NUM_T;
     CREATE TABLE tmp_QM_ABA_NUM_T(member VARCHAR(50));
     --Numerator: BMI
     INSERT INTO tmp_QM_ABA_NUM_T
            SELECT *
            FROM
            (
                SELECT DISTINCT 
                       A.SUBSCRIBER_ID--, A.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
                FROM adw.tvf_get_claims_w_dates('BMI', '', '', '1/1/2017', '12/31/2018') A
                WHERE CASE
                          WHEN A.[SUBSCRIBER_ID] IN
                (
                    SELECT B.SUBSCRIBER_ID
                    FROM adw.tvf_get_age(20, 74, CONVERT(VARCHAR, CONVERT(DATETIME, A.PRIMARY_SVC_DATE), 101)) B
                )
                          THEN 1
                          ELSE 0
                      END = 1
                UNION
                SELECT DISTINCT 
                       A.SUBSCRIBER_ID--, A.SEQ_CLAIM_ID, a.PRIMARY_SVC_DATE
                FROM adw.tvf_get_claims_w_dates('BMI Percentile', '', '', '1/1/2017', '12/31/2018') A
                WHERE CASE
                          WHEN A.[SUBSCRIBER_ID] IN
                (
                    SELECT B.SUBSCRIBER_ID
                    FROM adw.tvf_get_age(0, 19, CONVERT(VARCHAR, CONVERT(DATETIME, A.PRIMARY_SVC_DATE), 101)) B
                )
                          THEN 1
                          ELSE 0
                      END = 1
            ) A;
     IF OBJECT_ID('dbo.tmp_QM_ABA_NUM', 'U') IS NOT NULL
         DROP TABLE dbo.tmp_QM_ABA_NUM;
     CREATE TABLE dbo.tmp_QM_ABA_NUM(member VARCHAR(50) primary key);

     --meas year screening by professional
     INSERT INTO tmp_QM_ABA_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_ABA_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_ABA_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('ABA', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_ABA_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_ABA_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
