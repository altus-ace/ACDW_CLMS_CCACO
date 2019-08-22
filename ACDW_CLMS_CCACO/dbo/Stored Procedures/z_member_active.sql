create procedure [z_member_active]
as 
begin 
set nocount on; 

 IF OBJECT_ID('tmp_Member_Active', 'U') IS NOT NULL 
  DROP TABLE tmp_Member_Active; 

CREATE TABLE tmp_Member_Active(
MEMBER_ID varchar(250)
)


insert into tmp_Member_Active
select distinct MEMBER_ID 
from ACECAREDW.dbo.vw_UHC_ActiveMembers


end
