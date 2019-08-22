CREATE VIEW [dbo].[vw_Dashboard_Cost_Cluster_CCS]
AS
     SELECT DISTINCT 
            a.[SEQ_CLAIM_ID], 
            a.[SUBSCRIBER_ID], 
            [ICD_FLAG], 
            [diagNumber], 
            diagCode2, 
            [diagPoa], 
            b.CCS_CATEGORY, 
            b.CCS_CATEGORY_DESCRIPTION, 
            b.MULTI_CCS_LVL1, 
            b.MULTI_CCS_LVL1_LABEL, 
            b.MULTI_CCS_LVL2, 
            b.MULTI_CCS_LVL2_LABEL, 
            b.MULTI_CCS_LVL3, 
            c.TOTAL_BILLED_AMT, 
            c.CATEGORY_OF_SVC, 
            c.PRIMARY_SVC_DATE, 
            d.[HCCV23] AS HCCCODE
            ,
            --,d.[RXHCC] as RXHCCCODE 
            d.[VERSIONS] AS ICD_VERSION, 
            d.[ICD10_DESCRIPTION] AS ICD_DESC, 
            e.VALUE_CODE_SET_NAME, 
            d.HCC_Description AS HCC_DESC, 
            d.Disease_Hier AS HCC_DISEASE_CAT
     FROM
     (
        SELECT *, 
		  replace([diagCode], '.', '') AS diagCode2
	   FROM adw.Claims_Diags
     ) a
     LEFT JOIN
     (
         SELECT *
         FROM lst.LIST_ICDCCS
     ) b ON a.diagCode2 = b.[ICD-10-CM_CODE]
     JOIN adw.Claims_Headers c ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID
     LEFT JOIN adw.vw_ICD_HCC_Crosswalk d ON a.diagCode2 = d.ICD10
     LEFT JOIN adw.vw_ValueCode_ValueSetName_Crosswalk e ON a.diagCode2 = e.VALUE_CODE
     --left join LIST_HCC_CODES f on d.[HCCV23] = cast(f.HCC_No as int) 
     -- left join LIST_HCC_CODES g on d.[RXHCC] = cast(f.HCC_No as int) 
     WHERE ICD_FLAG = '1';
