
CREATE PROCEDURE adw.[SP_QM_AWC]
AS
     IF OBJECT_ID('tmp_QM_AWC_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_AWC_DEN;
     CREATE TABLE dbo.tmp_QM_AWC_DEN(member VARCHAR(50));
     --Denominator: member 3-6 years old
     INSERT INTO tmp_QM_AWC_DEN
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT SUBSCRIBER_ID, 
                       DOB
                FROM adw.tvf_get_active_members(1)
            ) A
            WHERE DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 12 AND 21;

     -----------------numerator

     IF OBJECT_ID('dbo.tmp_QM_AWC_NUM_T', 'U') IS NOT NULL
         DROP TABLE dbo.tmp_QM_AWC_NUM_T;
     CREATE TABLE dbo.tmp_QM_AWC_NUM_T(member VARCHAR(50));
     --Numerator: wellcare visit with pcp measurement year
     INSERT INTO tmp_QM_AWC_NUM_T
            SELECT DISTINCT 
                   A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', '1/1/2018', '12/31/2018') a
            WHERE PROV_SPEC IN('Family Practice', 'General Practic', 'Internal Medici', 'Pediatrics', 'Obstetrics & Gy', 'Nurse Practitio', 'Physician Assis', 'Nurse Prac - Me', 'Family Nurse Pr');
     IF OBJECT_ID('tmp_QM_AWC_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_AWC_NUM;
     CREATE TABLE tmp_QM_AWC_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_AWC_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_AWC_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_AWC_DEN;
     IF OBJECT_ID('tmp_QM_AWC_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_AWC_NUM_T;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('AWC', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_AWC_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_AWC_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
