

CREATE VIEW [dbo].[vw_Dashboard_HospitalCost_OKC]
AS
     SELECT DISTINCT 
            a.*,
            CASE
                WHEN b.seq_claim_id IS NOT NULL
                THEN 1
                ELSE 0
            END AS IS_IPVIS, 
            c.LBN_Name AS vendor_name_nppes, 
            d.city, 
            d.STATE, 
            d.COUNTY
     FROM
     (
         SELECT *
         FROM adw.claims_headers
         WHERE vendor_id IS NOT NULL
     ) a
   JOIN adw.[vw_AllMbrDetail_IPVisit] b ON a.seq_claim_id = b.seq_claim_id
     LEFT JOIN
     (
         SELECT DISTINCT 
                npi, 
                lbn_name, 
                PracticeCity AS city, 
                PracticeState AS states, 
                LEFT(practiceZip, 5) AS zip
         FROM lst.LIST_NPPES
     ) c ON a.VENDOR_ID = c.NPI
     LEFT JOIN
     (
         SELECT DISTINCT 
                [ZIP], 
                [CITY], 
                [STATE], 
                [COUNTY]
         FROM lst.[LIST_NPPES_COUNTY] ) d ON d.zip = CAST(c.zip AS INT);
