

CREATE procedure [z_diagcode]
@measure_id as varchar(10),
@value_set_name as varchar(50),
@value_code_system as varchar(20) 
as 
begin 
set nocount on; 
 IF OBJECT_ID('tmp_MemberByCodeByICD10CM', 'U') IS NOT NULL 
  DROP TABLE tmp_CodeByICD10CM; 

CREATE TABLE tmp_CodeByICD10CM(
value_code varchar(10),
VALUE_CODE_NAME varchar(250)
)

insert into tmp_CodeByICD10CM
select distinct hc.value_code,hc.VALUE_CODE_NAME
--hm.MEASURE_ID,hm.VALUE_SET_NAME,hm.VALUE_SET_OID,hc.VALUE_CODE,hc.VALUE_CODE_NAME,hc.value_code_system
 from [ACECAREDW_TEST].[dbo].[LIST_HEDIS_MEASURE]
hm
join LIST_HEDIS_CODE hc on hm.VALUE_SET_OID = hc.VALUE_SET_OID
where hm.MEASURE_ID = @measure_id and hc.value_set_name = @value_set_name
and hc.value_code_system =@value_code_system

end
