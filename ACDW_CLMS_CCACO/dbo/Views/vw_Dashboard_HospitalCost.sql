CREATE VIEW [dbo].[vw_Dashboard_HospitalCost]
AS
     SELECT DISTINCT 
            a.*,
            CASE
                WHEN b.SEQ_CLAIM_ID IS NOT NULL
                THEN 1
                ELSE 0
            END AS IS_IPVIS, 
            c.LBN_Name AS vendor_name_nppes, 
            d.city, 
            d.state, 
            d.county
     FROM
     (
         SELECT *
         FROM adw.Claims_Headers
         WHERE VENDOR_ID IS NOT NULL
     ) a
     LEFT JOIN adw.vw_AllMbrDetail_IPVisit b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
     LEFT JOIN
     (
         SELECT DISTINCT 
                NPI, 
                LBN_Name, 
                PracticeCity AS city, 
                PracticeState AS states, 
                LEFT(PracticeZip, 5) AS zip
         FROM lst.LIST_NPPES
     ) c ON a.VENDOR_ID = c.NPI
     LEFT JOIN
     (
         SELECT DISTINCT 
                [zip], 
                [city], 
                [state], 
                [county]
         FROM lst.LIST_NPPES_COUNTY
     ) d ON d.zip = CAST(c.zip AS INT);
