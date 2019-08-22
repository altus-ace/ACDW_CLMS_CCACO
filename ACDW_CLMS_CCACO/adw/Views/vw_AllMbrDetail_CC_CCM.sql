CREATE VIEW [adw].[vw_AllMbrDetail_CC_CCM]
AS
     SELECT a.SUBSCRIBER_ID, 
            a.SEQ_CLAIM_ID, 
            a.PRIMARY_SVC_DATE, 
            a.CLAIM_THRU_DATE, 
            a.PROV_SPEC, 
            a.ADMISSION_DATE, 
            a.CATEGORY_OF_SVC, 
            a.SVC_TO_DATE, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM adw.tvf_get_claims_w_dates('ACE CC CCM', '', '', '01/01/2018', '01/01/2019') a
          JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;
