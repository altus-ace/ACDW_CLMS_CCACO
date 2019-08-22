


CREATE procedure [z_cptcode]
@measure_id as varchar(10),
@value_set_name as varchar(100),
@value_code_system as varchar(20),
@value_code_system2 as varchar(20),
@value_code_system3 as varchar(20)
as 
begin 
set nocount on; 
 IF OBJECT_ID('tmp_ProcCodeByCodeSystem', 'U') IS NOT NULL 
  DROP TABLE tmp_ProcCodeByCodeSystem; 

CREATE TABLE tmp_ProcCodeByCodeSystem(
value_code varchar(10),
value_set_name varchar(250),
value_code_system varchar(10)
)

insert into tmp_ProcCodeByCodeSystem

SELECT  distinct  b.value_code
      ,b.[VALUE_SET_NAME]
	  ,b.value_code_system
  FROM [ACECAREDW_TEST].[dbo].[LIST_HEDIS_MEASURE] a
  join LIST_HEDIS_CODE b on a.value_set_oid = b.value_set_oid
  where a.measure_id = @measure_id
  and b.value_code_system in(@value_code_system,@value_code_system2,@value_code_system3)
  and b.value_set_name like @value_set_name

end
