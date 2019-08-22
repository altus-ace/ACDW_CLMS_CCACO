CREATE PROCEDURE adw.[SP_QM_WC6]
AS
     IF OBJECT_ID('tmp_QM_WC6_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC6_NUM_T;
     CREATE TABLE tmp_QM_WC6_NUM_T(member VARCHAR(50));
     INSERT INTO tmp_QM_WC6_NUM_T
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT a.SUBSCRIBER_ID, 
                       a.DOB, 
                       DATEADD(month, 15, a.DOB) AS x15_mth, 
                (
                    SELECT COUNT(DISTINCT SEQ_CLAIM_ID)
                    FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', '1/1/1900', DATEADD(month, 15, a.DOB)) b
                    WHERE PROV_SPEC IN('Family Practice', 'General Practic', 'Internal Medici', 'Pediatrics', 'Obstetrics & Gy', 'Nurse Practitio', 'Physician Assis', 'Nurse Prac - Me', 'Family Nurse Pr')
                    AND b.SUBSCRIBER_ID = a.SUBSCRIBER_ID
                ) AS num_of_wc_vis
                FROM
                (
                    SELECT DISTINCT 
                           SUBSCRIBER_ID, 
                           DOB
                    FROM adw.tvf_get_active_members(1)
                ) a
                WHERE YEAR(DATEADD(month, 15, DOB)) = 2018
            ) A
            WHERE A.num_of_wc_vis >= 6;
     IF OBJECT_ID('tmp_QM_WC6_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC6_NUM;
     CREATE TABLE tmp_QM_WC6_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_WC6_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC6_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC0_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('WC6', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC0_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC6_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
