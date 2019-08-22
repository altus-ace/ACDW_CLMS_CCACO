CREATE PROCEDURE adw.[SP_QM_CDC_N]
AS

     ---- NUMERATOR CALC

     IF OBJECT_ID('tmp_QM_CDC_N_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_N_NUM_T;
     CREATE TABLE tmp_QM_CDC_N_NUM_T(member VARCHAR(50));

     --meas year conditions 
     INSERT INTO tmp_QM_CDC_N_NUM_T
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Urine Protein Tests', 'Nephropathy Treatment', 'CKD Stage 4', '1/1/2018', '12/31/2018') a;
     INSERT INTO tmp_QM_CDC_N_NUM_T
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('ESRD', 'Kidney Transplant', 'ACE Inhibitor/ARB Medications', '1/1/2018', '12/31/2018') a;
     INSERT INTO tmp_QM_CDC_N_NUM_T
            SELECT DISTINCT 
                   a.SUBSCRIBER_ID
            FROM adw.Claims_Headers a
            WHERE PROV_SPEC IN('Nephrology')
            AND YEAR(PRIMARY_SVC_DATE) = 2018;
     IF OBJECT_ID('tmp_QM_CDC_N_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_N_NUM;
     CREATE TABLE tmp_QM_CDC_N_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_N_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_N_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CDC_N', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_N_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
