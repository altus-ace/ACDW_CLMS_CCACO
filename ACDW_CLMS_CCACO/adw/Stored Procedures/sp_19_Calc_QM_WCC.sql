CREATE PROCEDURE adw.[sp_19_Calc_QM_WCC] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QMBM VARCHAR(10)= 'WCC_BM';
     DECLARE @QMCN VARCHAR(10)= 'WCC_CN';
     DECLARE @QMPA VARCHAR(10)= 'WCC_PA';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumtb AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumb AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareopb AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumtc AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumc AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareopc AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumtp AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenump AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareopp AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('12/31/', @year))
            WHERE AGE BETWEEN 3 AND 17;
     INSERT INTO @table2
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Outpatient', '', '', concat('1/1/', @year - 2), concat('12/31/', @year));
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('BMI Percentile', '', '', concat('01/01/', @year), concat('12/31/', @year));
     INSERT INTO @tablenumtb
            SELECT *
            FROM @table1;
     INSERT INTO @tablenumb
            SELECT a.*
            FROM @tablenumtb a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareopb
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenumb b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QMBM, 
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
                   @QMBM, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenumb;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QMBM, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareopb;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Physical Activity Counseling', '', '', concat('01/01/', @year), concat('12/31/', @year));
     INSERT INTO @tablenumtp
            SELECT *
            FROM @table1;
     INSERT INTO @tablenump
            SELECT a.*
            FROM @tablenumtp a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareopp
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenump b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QMPA, 
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
                   @QMPA, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenump;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QMPA, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareopp;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM adw.tvf_get_claims_w_dates('Nutrition Counseling', '', '', concat('01/01/', @year), concat('12/31/', @year));
     INSERT INTO @tablenumtc
            SELECT *
            FROM @table1;
     INSERT INTO @tablenumc
            SELECT a.*
            FROM @tablenumtc a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareopc
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenumc b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QMCN, 
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
                   @QMCN, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenumc;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QMCN, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareopc;
