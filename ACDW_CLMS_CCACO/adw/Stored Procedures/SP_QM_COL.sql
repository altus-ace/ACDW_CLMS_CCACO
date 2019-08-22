
CREATE PROCEDURE adw.[SP_QM_COL]
as
if OBJECT_ID('tmp_QM_COL_DEN','U') is not null
drop table tmp_QM_COL_DEN

create table tmp_QM_COL_DEN (
member varchar(50)
)
--Denominator: member 3-6 years old
insert into tmp_QM_COL_DEN
SELECT DISTINCT SUBSCRIBER_ID
FROM (
	SELECT SUBSCRIBER_ID
		,DOB
		,datediff(year, DOB, convert(DATE, '12/31/2018', 101)) AS years
	FROM (
		select * from adw.tvf_get_active_members(1) 
	) A) a

WHERE datediff(year, DOB, convert(DATE, '12/31/2018', 101)) BETWEEN 51 and 75






-----------------numerator



if OBJECT_ID('tmp_QM_COL_NUM_T','U') is not null
drop table tmp_QM_COL_NUM_T


create table tmp_QM_COL_NUM_T (
member varchar(50)
)
--Numerator: wellcare visit with pcp measurement year
insert into tmp_QM_COL_NUM_T
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('FOBT', '', '', '1/1/2018', '12/31/2018') a
union 
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('Flexible Sigmoidoscopy', '', '', '1/1/2014', '12/31/2018') a	
union 
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('Colonoscopy', '', '', '1/1/2009', '12/31/2018') a	
union 
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('CT Colonography', '', '', '1/1/2014', '12/31/2018') a	
union 
SELECT DISTINCT A.SUBSCRIBER_ID
	FROM adw.tvf_get_claims_w_dates('FIT-DNA', '', '', '1/1/2016', '12/31/2018') a	





  
if OBJECT_ID('tmp_QM_COL_NUM','U') is not null
drop table tmp_QM_COL_NUM

create table tmp_QM_COL_NUM(
member varchar(50)
)


--meas year screening by professional
insert into tmp_QM_COL_NUM
select distinct * from tmp_QM_COL_NUM_T
intersect 
select distinct * from tmp_QM_COL_DEN









insert into tmp_QM_MSR_CNT values('COL',  (select count(*) from tmp_QM_COL_DEN), (select count(*) from tmp_QM_COL_NUM), 0,convert(date,getdate(),101),NULL,NULL)
