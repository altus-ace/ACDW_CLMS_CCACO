


CREATE VIEW [adw].[vw_Dashboard_Sub_QM_MbrCareOp_Detail_CL_History]
AS
     SELECT co.ClientMemberKey, 
            co.[QMDate], 
            co.QmMsrID, 
            co.MsrDen, 
            co.MsrNum, 
            co.Mbr_Type, 
            co.MsrDen - co.MsrNum AS MsrCO
     FROM
     (
         SELECT src.ClientMemberKey, 
                src.[QMDate], 
                src.QmMsrID, 
                src.MsrDen, 
                src.MsrNum, 
                m.Mbr_Type
         FROM
         (
             SELECT ClientMemberKey, 
                    [QMDate], 
                    QmMsrID, 
                     case when SUM(CASE
                            WHEN(QmCntCat = 'DEN')
                            THEN 1
                            ELSE 0
                        END) >= 1 then 1 else 0 end AS MsrDen, 
                    case when SUM(CASE
                            WHEN(QmCntCat = 'NUM')
                            THEN 1
                            ELSE 0
                        END) >= 1 then 1 else 0 end AS MsrNum
             FROM adw.QM_ResultByMember_History
             GROUP BY ClientMemberKey, 
                      [QMDate], 
                      QmMsrId
         ) src
         JOIN
         (
             select hicn, mbr_type from adw.tmp_active_members where exclusion = 'N'-- and [Plan] <>''
         ) m ON src.ClientMemberKey = m.HICN
     ) co;
