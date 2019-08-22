create procedure [z_members_diag]
@measure_id as varchar(10),
@value_set_name as varchar(50),
@value_code_system as varchar(20) 
as 
begin 
set nocount on; 

 IF OBJECT_ID('tmp_MemberByCodeByICD10CM', 'U') IS NOT NULL 
  DROP TABLE tmp_MemberByCodeByICD10CM; 

CREATE TABLE tmp_MemberByCodeByICD10CM(
MEMBER_ID varchar(250)
)


exec diagcode @measure_id,@value_set_name,@value_code_system  

insert into tmp_MemberByCodeByICD10CM
select distinct b.SUBSCRIBER_ID 
from Claims_Headers b 
  join Claims_Details c on b.[SEQ_CLAIM_ID] = c.[SEQ_CLAIM_ID]
  join Claims_Diags d on b.[SEQ_CLAIM_ID] = d.[SEQ_CLAIM_ID] 
  join tmp_CodeByICD10CM e on d.diagcode = e.[VALUE_CODE]


end
