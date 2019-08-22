



CREATE view [adw].[vw_Dashboard_Sub_npi_performance_caregap_OKC]
  as 
    SELECT a.NPI, 
           a.NPI_NAME, 
           a.TIN, 
           a.TIN_NAME, 
           a.QMDATE, 
           a.tot_den, 
           a.tot_num, 
           a.perc, 
           DENSE_RANK() OVER(
           ORDER BY perc DESC) AS rank
    FROM
    (
        SELECT b.NPI, 
               b.NPI_NAME, 
               [TIN], 
               [TIN_NAME], 
               QMDATE, 
               SUM([MsrDen]) AS tot_den, 
               SUM([MsrNum]) AS tot_num, 
               ROUND(CAST(SUM([MsrNum]) AS FLOAT) / SUM([MsrDen]), 2) AS perc
        FROM
        (
            SELECT a.ClientMemberKey, 
                   a.QMDate, 
                   a.QmMsrID, 
                   a.MsrDen, 
                   a.MsrNum, 
                   a.Mbr_Type, 
                   a.MsrCO
            FROM [adw].[vw_Dashboard_Sub_QM_MbrCareOp_Detail_CL] a 
            WHERE QmMsrID NOT IN
            (
                SELECT DISTINCT 
                       QM
                FROM lst.LIST_QM_Mapping
                WHERE active = 'N'
            )
        ) a
        JOIN
        (
            SELECT hicn, 
                   [NPI], 
                   [NPI_NAME], 
                   [TIN], 
                   [TIN_NAME]
            FROM adw.tmp_Active_Members
        ) b ON a.clientMemberkey = b.hicn
        GROUP BY b.NPI, 
                 b.npi_name, 
                 [TIN], 
                 [TIN_NAME], 
                 QMDATE
        HAVING b.npi IS NOT NULL
    ) a;
