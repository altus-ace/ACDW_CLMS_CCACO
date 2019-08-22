CREATE PROCEDURE adw.[SP_QM_BCS]
AS
     IF OBJECT_ID('tmp_QM_BCS_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_BCS_DEN;
     CREATE TABLE tmp_QM_BCS_DEN(member VARCHAR(50));
     INSERT INTO tmp_QM_BCS_DEN
            SELECT *
            FROM adw.tvf_get_gender('F')
            INTERSECT
            SELECT *
            FROM adw.tvf_get_age(52, 75, '12/31/2018');
     IF OBJECT_ID('dbo.tmp_QM_BCS_EXC', 'U') IS NOT NULL
         DROP TABLE tmp_QM_BCS_EXC;
     CREATE TABLE dbo.tmp_QM_BCS_EXC(member VARCHAR(50));
     INSERT INTO dbo.tmp_QM_BCS_EXC
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Bilateral Mastectomy', '', '', '1/1/1900', '12/31/2018')
            UNION
            SELECT A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Mastectomy', '', '', '1/1/1900', '12/31/2018') A
                 JOIN adw.tvf_get_claims_w_dates('Bilateral Modifier', '', '', '1/1/1900', '12/31/2018') B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
            UNION
            SELECT A.SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Unilateral Mastectomy', '', '', '1/1/1900', '12/31/2018') A
                 JOIN adw.tvf_get_claims_w_dates('Unilateral Mastectomy', '', '', '1/1/1900', '12/31/2018') B ON(DATEADD(day, 14, A.PRIMARY_SVC_DATE) <= B.PRIMARY_SVC_DATE)
                                                                                                                AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
            UNION
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('History of Bilateral Mastectomy', '', '', '1/1/1900', '12/31/2018')
            UNION
            (
             (
                 SELECT A.SUBSCRIBER_ID
                 FROM adw.tvf_get_claims_w_dates('Unilateral Mastectomy', '', '', '1/1/1900', '12/31/2018') A
                      JOIN adw.tvf_get_claims_w_dates('Left Modifier', '', '', '1/1/1900', '12/31/2018') B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
                 UNION
                 SELECT A.SUBSCRIBER_ID
                 FROM adw.tvf_get_claims_w_dates('Absence of Left Breast', '', '', '1/1/1900', '12/31/2018') A
                 UNION
                 SELECT A.SUBSCRIBER_ID
                 FROM adw.tvf_get_claims_w_dates('Unilateral Mastectomy Left Value', '', '', '1/1/1900', '12/31/2018') A
             )
             INTERSECT
             (
                 SELECT A.SUBSCRIBER_ID
                 FROM adw.tvf_get_claims_w_dates('Unilateral Mastectomy', '', '', '1/1/1900', '12/31/2018') A
                      JOIN adw.tvf_get_claims_w_dates('Right Modifier', '', '', '1/1/1900', '12/31/2018') B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
                 UNION
                 SELECT A.SUBSCRIBER_ID
                 FROM adw.tvf_get_claims_w_dates('Absence of Right Breast', '', '', '1/1/1900', '12/31/2018') A
                 UNION
                 SELECT A.SUBSCRIBER_ID
                 FROM adw.tvf_get_claims_w_dates('Unilateral Mastectomy Right Value', '', '', '1/1/1900', '12/31/2018') A
             )
            );
     --cond. 9 Numerator

     IF OBJECT_ID('dbo.tmp_QM_BCS_NUM_T', 'U') IS NOT NULL
         DROP TABLE dbo.tmp_QM_BCS_NUM_T;
     CREATE TABLE dbo.tmp_QM_BCS_NUM_T(member VARCHAR(50));
     INSERT INTO dbo.tmp_QM_BCS_NUM_T
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Mammography', '', '', '10/1/2016', '12/31/2018');
     IF OBJECT_ID('dbo.tmp_QM_BCS_NUM', 'U') IS NOT NULL
         DROP TABLE dbo.tmp_QM_BCS_NUM;
     CREATE TABLE dbo.tmp_QM_BCS_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO dbo.tmp_QM_BCS_NUM
            SELECT DISTINCT 
                   *
            FROM dbo.tmp_QM_BCS_NUM_T
            INTERSECT
            (
                SELECT DISTINCT 
                       *
                FROM dbo.tmp_QM_BCS_DEN
                EXCEPT
                SELECT DISTINCT 
                       *
                FROM dbo.tmp_QM_BCS_EXC
            );
     IF OBJECT_ID('dbo.tmp_QM_BCS_NUM_T', 'U') IS NOT NULL
         DROP TABLE dbo.tmp_QM_BCS_NUM_T;
     INSERT INTO dbo.tmp_QM_MSR_CNT
     VALUES
     ('BCS', 
     (
         SELECT COUNT(*)
         FROM dbo.tmp_QM_BCS_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM dbo.tmp_QM_BCS_NUM
     ), 
     (
         SELECT COUNT(*)
         FROM dbo.tmp_QM_BCS_EXC
     ), 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
