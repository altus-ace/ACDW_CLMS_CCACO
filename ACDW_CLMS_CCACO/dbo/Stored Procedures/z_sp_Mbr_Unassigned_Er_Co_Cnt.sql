
CREATE PROCEDURE [z_sp_Mbr_Unassigned_Er_Co_Cnt]
AS
     DECLARE @table1 TABLE
     (ClientMemberKey VARCHAR(40), 
      tot_num_open    INT
     );
     INSERT INTO @table1
            SELECT zz.ClientMemberKey, 
                   SUM(zz.[MsrDen]) - SUM(zz.[MsrNum]) AS tot_num_open
            FROM [dbo].zvw_QM_MbrCareOp_Detail zz
            GROUP BY zz.ClientMemberKey;
     DECLARE @table2 TABLE
     (SUBSCRIBER_ID VARCHAR(40), 
      ER_cnt        INT
     );
     INSERT INTO @table2
            SELECT z.SUBSCRIBER_ID, 
                   COUNT(DISTINCT z.PRIMARY_SVC_DATE) AS cnt
            FROM adw.vw_AllMbrDetail_ERVisit z
            WHERE z.PRIMARY_SVC_DATE BETWEEN DATEADD(month, -12, GETDATE()) AND GETDATE()
            GROUP BY z.SUBSCRIBER_ID;
     SELECT a.[MBI], 
            a.[HICN], 
            a.[FNAME], 
            a.[LNAME], 
            a.[SEX], 
            a.[DOB], 
            a.[DOD], 
            a.[CM_Flg], 
            a.MBR_TYPE, 
            b.ER_cnt, 
            c.tot_num_open AS num_of_open_co
     FROM dbo.z_vw_Mbr_Unassigned_Exc_Deaths a
          LEFT JOIN @table2 b ON a.HICN = b.SUBSCRIBER_ID
          LEFT JOIN @table1 c ON a.HICN = c.ClientMemberKey;
