CREATE PROCEDURE adw.[SP_QM_CDC_HB]
AS
     IF OBJECT_ID('tmp_QM_CDC_HB_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_HB_NUM_T;
     CREATE TABLE tmp_QM_CDC_HB_NUM_T(member VARCHAR(50));

     --Numerator condition: had hba1c test
     INSERT INTO tmp_QM_CDC_HB_NUM_T
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('HbA1c Tests', '', '', '1/1/2018', '12/31/2018');
     IF OBJECT_ID('tmp_QM_CDC_HB_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_HB_NUM;
     CREATE TABLE tmp_QM_CDC_HB_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_HB_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_HB_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CDC_HB', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_HB_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
