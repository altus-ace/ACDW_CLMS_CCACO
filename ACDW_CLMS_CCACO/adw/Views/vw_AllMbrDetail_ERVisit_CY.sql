
CREATE VIEW [adw].[vw_AllMbrDetail_ERVisit_CY]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM
     (
         SELECT *
         FROM adw.tvf_get_claims_w_dates('ED', '', '', '01/01/2019', '01/01/2020')
         UNION
         (
             SELECT a.*
             FROM adw.tvf_get_claims_w_dates('ED POS', '', '', '01/01/2019', '01/01/2020') a
                  JOIN adw.tvf_get_claims_w_dates('ED Procedure Code', '', '', '01/01/2019', '01/01/2020') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
         )
     ) a
     JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;

