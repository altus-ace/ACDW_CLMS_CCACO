CREATE VIEW dbo.zvw_QM_PotentialMbrStats
AS
     SELECT ClientMemberKey, 
            SUM(MsrDen) SumDen, 
            SUM(MsrNum) AS SumNum, 
            SUM(MsrCO) AS SumMsrCO, 
            SUM(MsrNum) AS SumAdherence, 
            ROUND(CAST(SUM(MsrNum) AS FLOAT) / SUM(MsrDen), 2) AS AdPercent
     FROM dbo.zvw_QM_MbrCareOp_Detail
     WHERE MBR_TYPE = 'P'
     GROUP BY CLientMemberKey;
