CREATE VIEW adw.vw_AllMbrDetail_IPVisit
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI, 
            b.TOTAL_BILLED_AMT
     FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/2001', '01/01/2099') a
          JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;
