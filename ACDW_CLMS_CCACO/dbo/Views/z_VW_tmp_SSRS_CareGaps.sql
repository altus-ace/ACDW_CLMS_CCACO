







CREATE VIEW [dbo].[z_VW_tmp_SSRS_CareGaps]
AS

select a.HICN as Subscriber_ID
	,a.CGQM as CareGap
	,b.cgqmdesc
FROM [ACDW_CLMS_CCACO].[dbo].[vw_QM_CareGap_By_Mbr] a
inner join 
(
SELECT distinct CGQM, [CGQMDESC]
  FROM [ACDW_CLMS_CCACO].[dbo].[vw_QM_CareGap_By_Mbr_With_Desc]
) b on b.cgqm = a.cgqm
where a.HICN in ('{9858821310','{9944615146', '047446051A','049521046A','{6054816810','037581666A','041563129A')
