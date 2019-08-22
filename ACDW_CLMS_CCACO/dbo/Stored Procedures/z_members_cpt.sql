

CREATE procedure [z_members_cpt]-----NEED TO WORK ON
@measure_id as varchar(10),
@value_set_name as varchar(100),
@value_code_system as varchar(20) ,
@value_code_system2 as varchar(20),
@value_code_system3 as varchar(20)
as 
begin 
set nocount on; 

 IF OBJECT_ID('tmp_MemberByCodeByCPT', 'U') IS NOT NULL 
  DROP TABLE tmp_MemberByCodeByCPT; 

CREATE TABLE tmp_MemberByCodeByCPT(
MEMBER_ID varchar(250)
)


exec cptcode @measure_id,@value_set_name,@value_code_system ,@value_code_system2 ,@value_code_system3 

insert into tmp_MemberByCodeByCPT
select distinct b.SUBSCRIBER_ID 
from Claims_Headers b 
  join Claims_Details c on b.[SEQ_CLAIM_ID] = c.[SEQ_CLAIM_ID]
  join tmp_ProcCodeByCodeSystem e on c.PROCEDURE_CODE = e.[VALUE_CODE]


end
