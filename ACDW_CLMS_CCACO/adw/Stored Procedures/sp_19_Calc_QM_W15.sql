CREATE PROCEDURE adw.[sp_19_Calc_QM_W15] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM0 VARCHAR(10)= 'W15_0';
     DECLARE @QM1 VARCHAR(10)= 'W15_1';
     DECLARE @QM2 VARCHAR(10)= 'W15_2';
     DECLARE @QM3 VARCHAR(10)= 'W15_3';
     DECLARE @QM4 VARCHAR(10)= 'W15_4';
     DECLARE @QM5 VARCHAR(10)= 'W15_5';
     DECLARE @QM6 VARCHAR(10)= 'W15_6';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt0	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum0	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop0  AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt1	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum1	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop1  AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt2	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum2	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop2  AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt3	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum3	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop3  AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt4	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum4	   AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop4  AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt5 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum5 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop5 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt6 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum6 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop6 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT SUBSCRIBER_ID
            FROM adw.tvf_get_active_members2(concat('1/1/', @year))
            WHERE YEAR(DATEADD(month, 15, DOB)) = @year;
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE AGE <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) > 0;
     INSERT INTO @tablenumt0
            SELECT *
            FROM @table1;
     INSERT INTO @tablenum0
            SELECT a.*
            FROM @tablenumt0 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop0
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum0 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM0, 
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
                   @QM0, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum0;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM0, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop0;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE age <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) > 1;
     INSERT INTO @tablenumt1
            SELECT *
            FROM @table1
            EXCEPT
            SELECT *
            FROM @tablecareop0;
     INSERT INTO @tablenum1
            SELECT a.*
            FROM @tablenumt1 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop1
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum1 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM1, 
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
                   @QM1, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum1;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM1, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop1;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE age <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) > 2;
     INSERT INTO @tablenumt2
            SELECT *
            FROM @table1
            EXCEPT
            SELECT *
            FROM @tablecareop0
            EXCEPT
            SELECT *
            FROM @tablecareop1;
     INSERT INTO @tablenum2
            SELECT a.*
            FROM @tablenumt2 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop2
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM2, 
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
                   @QM2, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum2;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM2, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop2;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE age <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) > 3;
     INSERT INTO @tablenumt3
            SELECT *
            FROM @table1
            EXCEPT
            SELECT *
            FROM @tablecareop0
            EXCEPT
            SELECT *
            FROM @tablecareop1
            EXCEPT
            SELECT *
            FROM @tablecareop2;
     INSERT INTO @tablenum3
            SELECT a.*
            FROM @tablenumt3 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop3
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum3 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM3, 
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
                   @QM3, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum3;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM3, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop3;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE age <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) > 4;
     INSERT INTO @tablenumt4
            SELECT *
            FROM @table1
            EXCEPT
            SELECT *
            FROM @tablecareop0
            EXCEPT
            SELECT *
            FROM @tablecareop1
            EXCEPT
            SELECT *
            FROM @tablecareop2
            EXCEPT
            SELECT *
            FROM @tablecareop3;
     INSERT INTO @tablenum4
            SELECT a.*
            FROM @tablenumt4 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop4
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum4 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM4, 
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
                   @QM4, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum4;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM4, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop4;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE age <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) > 5;
     INSERT INTO @tablenumt5
            SELECT *
            FROM @table1
            EXCEPT
            SELECT *
            FROM @tablecareop0
            EXCEPT
            SELECT *
            FROM @tablecareop1
            EXCEPT
            SELECT *
            FROM @tablecareop2
            EXCEPT
            SELECT *
            FROM @tablecareop3
            EXCEPT
            SELECT *
            FROM @tablecareop4;
     INSERT INTO @tablenum5
            SELECT a.*
            FROM @tablenumt5 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop5
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum5 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM5, 
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
                   @QM5, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum5;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM5, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop5;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT a.SUBSCRIBER_ID--, count(distinct PRIMARY_SVC_DATE) as visits 
            FROM
            (
                SELECT *
                FROM adw.tvf_get_active_members2(concat('1/1/', @year))
                WHERE age <= 3
            ) a
            LEFT JOIN
            (
                SELECT a.*
                FROM adw.tvf_get_claims_w_dates('Well-Care', '', '', concat('1/1/', @year - 100), concat('12/31/', @year)) a
                     JOIN adw.tvf_get_provspec(1, 8, 11, 16, 37, 38) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            ) b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                   AND DATEADD(month, 15, DOB) >= b.PRIMARY_SVC_DATE
            GROUP BY a.SUBSCRIBER_ID
            HAVING COUNT(DISTINCT PRIMARY_SVC_DATE) < 6;
     INSERT INTO @tablenumt6
            SELECT *
            FROM @table1;
     INSERT INTO @tablenum6
            SELECT a.*
            FROM @tablenumt6 a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop6
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum6 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM6, 
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
                   @QM6, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum6;
     INSERT INTO adw.QM_ResultByMember_History
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM6, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop6;
