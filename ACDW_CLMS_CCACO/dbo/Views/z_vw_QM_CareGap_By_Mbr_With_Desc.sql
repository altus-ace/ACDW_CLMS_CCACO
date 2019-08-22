
CREATE VIEW [dbo].[z_vw_QM_CareGap_By_Mbr_With_Desc]
AS
     SELECT DISTINCT 
            ClientMemberKey AS SUBSCRIBER_ID, 
            MBR_TYPE, 
            QmMsrId AS CGQM, 
            b.QM_DESC AS CGQMDESC, 
            1 AS CntCG, 
            c.Line, 
            c.Documentation, 
            c.Tips, 
            c.Codes
     FROM dbo.zvw_QM_MbrCareOp_Detail a
          LEFT JOIN lst.LIST_QM_Mapping b ON a.QmMsrId = b.QM
          LEFT JOIN lst.LIST_AHRTIPS c ON a.QmMsrId = c.QM_ID
     WHERE(MsrCO = 1);
