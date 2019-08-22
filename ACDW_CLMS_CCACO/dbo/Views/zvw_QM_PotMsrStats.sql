CREATE VIEW dbo.zvw_QM_PotMsrStats
AS
     SELECT qm.QmMsrId, 
            m.QM_DESC AS QmMsrDesc, 
            qm.SumDen, 
            qm.SumNum, 
            qm.SumMsrCO, 
            qm.SumAdherence, 
            qm.AdPercent
     FROM
     (
         SELECT QmMsrId, 
                SUM(MsrDen) SumDen, 
                SUM(MsrNum) AS SumNum, 
                SUM(MsrCO) AS SumMsrCO, 
                SUM(MsrNum) AS SumAdherence, 
                ROUND(CAST(SUM(MsrNum) AS FLOAT) / SUM(MsrDen), 2) AS AdPercent
         FROM dbo.zvw_QM_MbrCareOp_Detail
         WHERE MBR_TYPE = 'P'
         GROUP BY QmMsrId
     ) qm
     JOIN lst.LIST_QM_Mapping m ON qm.QmMsrId = m.QM;
