

CREATE VIEW [adw].[vw_CCACO-CDC_9_NUMs]
AS
with CTE As
(	
select distinct a. SUBSCRIBER_ID FROM [adw].[2020_tvf_Get_ClaimsByValueSet] ('Outpatient', 'ED', 'Nonacute Inpatient', 'Observation','1/1/2018', '12/31/2019') a
join [adw].[2020_tvf_Get_ClaimsByValueSet] ('Diabetes', '', '', '','1/1/2018', '12/31/2019') b on a.SUBSCRIBER_ID=b.SUBSCRIBER_ID
join [adw].[2020_tvf_Get_ActiveMembers] ('10/1/2019') c on a.SUBSCRIBER_ID=c.SUBSCRIBER_ID and AGE BETWEEN 18 AND 75
Group by a. SUBSCRIBER_ID
HAVING(COUNT(DISTINCT a.SEQ_CLAIM_ID) >= 2)
                  AND (COUNT(DISTINCT a.PRIMARY_SVC_DATE) >= 2) --546 
union
select distinct a. SUBSCRIBER_ID
from [adw].[2020_tvf_Get_ClaimsByValueSet] ('Acute Inpatient', '', '', '', '1/1/2018', '12/31/2019') a 
join [adw].[2020_tvf_Get_ClaimsByValueSet]('Diabetes', '', '', '', '1/1/2018', '12/31/2019') b on a.SUBSCRIBER_ID=b.SUBSCRIBER_ID
join [adw].[2020_tvf_Get_ActiveMembers] ('10/1/2019') c on a.SUBSCRIBER_ID=c.SUBSCRIBER_ID and AGE BETWEEN 18 AND 75 --123
union 
select a. SUBSCRIBER_ID FROM [adw].[2020_tvf_Get_ClaimsByValueSet] ('Diabetes Medications', '', '', '','1/1/2018', '12/31/2019') a
join [adw].[2020_tvf_Get_ActiveMembers] ('10/1/2019') b on a.SUBSCRIBER_ID=b.SUBSCRIBER_ID and AGE BETWEEN 18 AND 75 --0
) 
	SELECT DISTINCT a.SUBSCRIBER_ID
    FROM (SELECT DISTINCT * FROM
						( SELECT DISTINCT SUBSCRIBER_ID, SEQ_CLAIM_ID, ROW_NUMBER() OVER(PARTITION BY SUBSCRIBER_ID
							ORDER BY PRIMARY_SVC_DATE DESC) AS rank
							FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('HbA1c Tests', '','', '', CONCAT('1/1/', 2019), CONCAT('12/31/', 2019)) a
						) b
						WHERE rank = 1
					) a
    LEFT JOIN(SELECT DISTINCT SEQ_CLAIM_ID
			  FROM(SELECT DISTINCT  SEQ_CLAIM_ID FROM [adw].[2020_tvf_Get_ClaimsByValueSet]('', '','HbA1c Level Greater Than 9.0','', '1/1/2019', '12/31/2019')
			  ) A
			  ) C 
	ON a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID