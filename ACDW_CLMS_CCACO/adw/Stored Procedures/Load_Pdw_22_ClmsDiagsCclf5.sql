
CREATE PROCEDURE adw.Load_Pdw_22_ClmsDiagsCclf5
AS
     -- insert claims diags for CCLF5
     INSERT INTO adw.Claims_Diags
     ([SEQ_CLAIM_ID], 
      [SUBSCRIBER_ID], 
      [ICD_FLAG], 
      [diagNumber], 
      [diagCode]
     )
            SELECT src.CUR_CLM_UNIQ_ID AS SEQ_CLAIM_ID, 
                   src.BENE_HIC_NUM AS SUBSCRIBER_ID, 
                   src.[DGNS_PRCDR_ICD_IND] AS ICD_FLAG, 
                   src.ClmNum AS diagNum, 
                   src.ClmCd AS diagCode
            FROM
            (
                SELECT CUR_CLM_UNIQ_ID, 
                       BENE_HIC_NUM, 
                       DGNS_PRCDR_ICD_IND, 
                       ClmNum, 
                       ClmCd
                FROM
                (
                    SELECT c.CUR_CLM_UNIQ_ID, 
                           c.BENE_HIC_NUM, 
                           c.[DGNS_PRCDR_ICD_IND], 
                           c.CLM_DGNS_1_CD AS [1], 
                           c.[CLM_DGNS_2_CD] AS [2], 
                           c.[CLM_DGNS_3_CD] AS [3], 
                           c.[CLM_DGNS_4_CD] AS [4], 
                           [CLM_DGNS_5_CD] AS [5], 
                           [CLM_DGNS_6_CD] AS [6], 
                           [CLM_DGNS_7_CD] AS [7], 
                           [CLM_DGNS_8_CD] AS [8]
                    FROM adi.CCLF5 c
                         JOIN ast.pstcDeDupClms_Cclf5 d ON c.URN = d.urn
                    WHERE c.CLM_LINE_NUM = 1
                ) p UNPIVOT(ClmCd FOR ClmNum IN([1], 
                                                [2], 
                                                [3], 
                                                [4], 
                                                [5], 
                                                [6], 
                                                [7], 
                                                [8])) AS unpvt
            ) AS src
            WHERE src.clmCd <> '~';

     /* why is this here???? */
