


CREATE VIEW [adw].[vw_AllMbrDetail_CC_CCM_CY]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM adw.tvf_get_claims_w_dates('ACE CC CCM', '', '', '01/01/2019', '01/01/2020') a
          JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;


