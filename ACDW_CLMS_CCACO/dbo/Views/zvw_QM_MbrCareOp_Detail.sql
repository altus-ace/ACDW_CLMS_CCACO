CREATE VIEW dbo.zvw_QM_MbrCareOp_Detail
AS
SELECT co.ClientMemberKey,
       co.QmMsrId,
       co.MsrDen,
       co.MsrNum,       
       co.MBR_TYPE,
       co.MsrDen - co.MsrNum AS MsrCO
FROM
(
    SELECT src.ClientMemberKey,
           src.QmMsrId,
           src.MsrDen,
           src.MsrNum,
           m.MBR_TYPE
    FROM
(
    SELECT ClientMemberKey,
           QmMsrId,
           SUM(CASE
                   WHEN(QmCntCat = 'DEN')
                   THEN 1
                   ELSE 0
               END) AS MsrDen,
           SUM(CASE
                   WHEN(QmCntCat = 'NUM')
                   THEN 1
                   ELSE 0
               END) AS MsrNum
    FROM dbo.zQM_ResultByMember
    GROUP BY ClientMemberKey,
             QmMsrId
) src
JOIN dbo.z_Active_Members m ON src.ClientMemberKey = m.HICN
) co;
