CREATE VIEW [dbo].[z_vw_QM_CareGap_By_Mbr]
AS
     SELECT ClientMemberKey AS HICN,
            MBR_TYPE,
            QmMsrId AS CGQM,
            1 AS CntCG
     FROM dbo.zvw_QM_MbrCareOp_Detail
     WHERE(MsrCO = 1);
