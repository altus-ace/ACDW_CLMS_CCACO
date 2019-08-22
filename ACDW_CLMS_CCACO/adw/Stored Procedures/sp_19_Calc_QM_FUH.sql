CREATE PROCEDURE adw.[sp_19_Calc_QM_FUH] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM VARCHAR(10)= 'FUH_30';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @tableAIP AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tableMH AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tableEXC AS TABLE(SEQ_CLAIM_ID VARCHAR(30));
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tableden AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tablenum1 AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tablenumt AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tablenum AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );
     DECLARE @tablecareop AS TABLE
     (SUBSCRIBER_ID    VARCHAR(20), 
      SEQ_CLAIM_ID     VARCHAR(30), 
      PRIMARY_SVC_DATE DATE, 
      ADMISSION_DATE   DATE, 
      DISCHARGE_DATE   DATE
     );

     --acute ip 
     INSERT INTO @tableAIP
            SELECT a.SUBSCRIBER_ID, 
                   a.SEQ_CLAIM_ID, 
                   a.PRIMARY_SVC_DATE, 
                   a.ADMISSION_DATE, 
                   a.SVC_TO_DATE
            FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) a
                 LEFT JOIN
            (
                SELECT *
                FROM adw.tvf_get_claims_w_dates('Nonacute Inpatient Stay', '', '', concat('1/1/', @year - 1), concat('12/31/', @year))
            ) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            WHERE b.SEQ_CLAIM_ID IS NULL;

     --mental health 
     INSERT INTO @tableMH
            SELECT SUBSCRIBER_ID, 
                   SEQ_CLAIM_ID, 
                   PRIMARY_SVC_DATE, 
                   ADMISSION_DATE, 
                   SVC_TO_DATE
            FROM adw.tvf_get_claims_w_dates('Mental Health Diagnosis', 'Intentional Self-Harm', '', concat('1/1/', @year - 1), concat('12/31/', @year));
     INSERT INTO @table1
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('12/31/', @year))
            WHERE AGE BETWEEN 6 AND 120;
     INSERT INTO @table2
            SELECT a.*
            FROM @tableAIP a
                 JOIN @tableMH b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;
     INSERT INTO @tableden
            SELECT a.*
            FROM @table2 a
                 JOIN @table1 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID;

     --DELETE FROM @table1
     --DELETE FROM @table2

     INSERT INTO @tablenumt
            SELECT a.*
            FROM @tableden a
                 JOIN adw.tvf_get_provspec(26, 62, 68, '', '', '') b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                                                                        AND ABS(DATEDIFF(day, a.DISCHARGE_DATE, b.PRIMARY_SVC_DATE)) <= 30;

     --insert into @table2
     --SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, ADMISSION_DATE, SVC_TO_DATE
     --FROM adw.tvf_get_claims_w_dates('Mental Health Practitioner', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) 

     INSERT INTO @tablenum
            SELECT a.*
            FROM @tablenumt a;
     INSERT INTO @tablecareop
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            WHERE b.SEQ_CLAIM_ID IS NULL;

     --select *, count(distinct SEQ_CLAIM_ID) as visits , concat(@QM, '_DEN') ,@RUNDATE ,@RUNTIME from @tableden a group by SUBSCRIBER_ID
     --select *, count(distinct SEQ_CLAIM_ID) as visits , concat(@QM, '_NUM') ,@RUNDATE,@RUNTIME from @tablenum a group by SUBSCRIBER_ID
     --select *, count(distinct SEQ_CLAIM_ID) as visits , concat(@QM, '_COP') ,@RUNDATE ,@RUNTIME from @tablecareop a group by SUBSCRIBER_ID

     INSERT INTO @tablecareop
            SELECT a.SUBSCRIBER_ID, 
                   a.SEQ_CLAIM_ID, 
                   a.PRIMARY_SVC_DATE, 
                   a.ADMISSION_DATE, 
                   a.DISCHARGE_DATE
            FROM
            (
                SELECT *
                FROM
                (
                    SELECT *, 
                           ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
                           ORDER BY PRIMARY_SVC_DATE DESC) AS rank
                    FROM @tableden
                ) z
                WHERE rank = 1
            ) a
            LEFT JOIN @tablenum b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            WHERE b.SEQ_CLAIM_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT SUBSCRIBER_ID, 
                   @QM, 
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
            SELECT SUBSCRIBER_ID, 
                   @QM, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT SUBSCRIBER_ID, 
                   @QM, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop;
