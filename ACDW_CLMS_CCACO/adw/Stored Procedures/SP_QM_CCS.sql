
CREATE PROCEDURE adw.[SP_QM_CCS]
AS
     IF OBJECT_ID('tmp_QM_CCS_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CCS_DEN;
     CREATE TABLE tmp_QM_CCS_DEN(member VARCHAR(50));
     --Denominator: women 24-64
     INSERT INTO tmp_QM_CCS_DEN
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT SUBSCRIBER_ID, 
                       DOB, 
                       DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) AS years
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           DOB
                    FROM
                    (
                        SELECT *
                        FROM adw.tvf_get_active_members(1)
                        WHERE gender = 'F'
                    ) a
                ) A
            ) A
            WHERE DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 24 AND 64;

     -----------------numerator
     IF OBJECT_ID('tmp_QM_CCS_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CCS_NUM_T;
     CREATE TABLE tmp_QM_CCS_NUM_T(member VARCHAR(50));
     IF OBJECT_ID('tmp_QM_CCS_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CCS_NUM_T;
     CREATE TABLE tmp_QM_CCS_NUM_T(member VARCHAR(50));
     --Numerator step 1 
     INSERT INTO tmp_QM_CCS_NUM_T
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Cervical Cytology', '', '', '1/1/2016', '12/31/2018') a;
     --Numerator step 2 
     INSERT INTO tmp_QM_CCS_NUM_T
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT SUBSCRIBER_ID, 
                       DOB, 
                       DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) AS years
                FROM
                (
                    SELECT SUBSCRIBER_ID, 
                           DOB
                    FROM
                    (
                        SELECT *
                        FROM adw.tvf_get_active_members(1)
                        WHERE gender = 'F'
                    ) a
                ) A
            ) A
            WHERE DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 30 AND 64
            INTERSECT
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID--, case when A.[SUBSCRIBER_ID] in (select B.SUBSCRIBER_ID from [tvf_get_age](30,65,CONVERT(varchar, A.PRIMARY_SVC_DATE,101))B ) then 1 else 0 end as is_30 
            FROM adw.tvf_get_claims_w_dates('Cervical Cytology', '', '', '1/1/2014', '12/31/2018') A
                 JOIN adw.tvf_get_claims_w_dates('HPV Tests', '', '', '1/1/2014', '12/31/2018') B ON ABS((DATEDIFF(d, B.PRIMARY_SVC_DATE, A.PRIMARY_SVC_DATE))) <= 4
                                                                                                     AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                                                                                                     AND CASE
                                                                                                             WHEN A.[SUBSCRIBER_ID] IN(SELECT B.SUBSCRIBER_ID
                                                                                                                                       FROM adw.tvf_get_age(30, 64, CONVERT(VARCHAR, A.PRIMARY_SVC_DATE, 101)) B)
                                                                                                             THEN 1
                                                                                                             ELSE 0
                                                                                                         END = 1;
     IF OBJECT_ID('tmp_QM_CCS_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CCS_NUM;
     CREATE TABLE tmp_QM_CCS_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CCS_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CCS_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CCS_DEN;
     IF OBJECT_ID('tmp_QM_CCS_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CCS_NUM_T;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CCS', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CCS_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CCS_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
