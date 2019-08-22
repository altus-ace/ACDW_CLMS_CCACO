CREATE VIEW dbo.z_vw_Mbr_Unassigned_VisitSummaryByMbr
AS
     SELECT DISTINCT 
            a_1.HICN, 
            a_1.MBR_TYPE,
            CASE
                WHEN b.Had_AWV IS NULL
                THEN 0
                ELSE b.Had_AWV
            END AS Had_AWV,
            CASE
                WHEN c.Had_PCP_Visit IS NULL
                THEN 0
                ELSE c.Had_PCP_Visit
            END AS Had_PCP_Visit
     FROM
     (
         SELECT HICN, 
                MBR_TYPE
         FROM dbo.z_vw_Mbr_Unassigned_Exc_Deaths AS a
     ) AS a_1
     LEFT OUTER JOIN
     (
         SELECT [SUBSCRIBER_ID], 
                [SEQ_CLAIM_ID], 
                [PRIMARY_SVC_DATE], 
                [CLAIM_THRU_DATE], 
                [PROV_SPEC], 
                [ADMISSION_DATE], 
                [CATEGORY_OF_SVC], 
                [SVC_TO_DATE], 
                [VENDOR_ID], 
                [SVC_PROV_NPI], 
                1 AS Had_AWV
         FROM adw.vw_AllMbrDetail_AWV_CY
     ) AS b ON a_1.HICN = b.SUBSCRIBER_ID
     LEFT OUTER JOIN
     (
         SELECT [SUBSCRIBER_ID], 
                [SEQ_CLAIM_ID], 
                [PRIMARY_SVC_DATE], 
                [CLAIM_THRU_DATE], 
                [PROV_SPEC], 
                [ADMISSION_DATE], 
                [CATEGORY_OF_SVC], 
                [SVC_TO_DATE], 
                [VENDOR_ID], 
                [SVC_PROV_NPI], 
                1 AS Had_PCP_Visit
         FROM adw.vw_AllMbrDetail_PCPVisit_CY
     ) AS c ON a_1.HICN = c.SUBSCRIBER_ID;
