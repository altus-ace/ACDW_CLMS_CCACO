
CREATE VIEW [adw].[vw_AllMbrDetail_Readmission_CY]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM
     (
         SELECT b.*
         FROM adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/2019', '01/01/2020') a
              JOIN adw.tvf_get_claims_w_dates('Inpatient Stay', '', '', '01/01/2019', '01/01/2020') b ON a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                                                                                                             AND a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
                                                                                                             AND ABS(DATEDIFF(day, a.SVC_TO_DATE, b.ADMISSION_DATE)) <= 30
                                                                                                             AND a.SVC_TO_DATE <= b.ADMISSION_DATE
     ) a
     JOIN adw.Claims_Headers b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID;

