




CREATE procedure [z_get_MemberByCareGap]
@Measure_Desc as varchar(100),
@Sub_Meas as varchar(100)
as 
begin 
set nocount on; 
 IF OBJECT_ID('tmp_MemberByCareGap', 'U') IS NOT NULL 
  DROP TABLE tmp_MemberByCareGap; 

CREATE TABLE tmp_MemberByCareGap(
MEMBER_ID varchar(250)
)
insert into tmp_MemberByCareGap 
SELECT  distinct [MemberID]
  FROM [ACECAREDW].[dbo].[UHC_CareOpps]
  where month(A_LAST_UPDATE_DATE) = month(getdate())
  and Measure_Desc = @Measure_Desc
  and Sub_Meas = @Sub_Meas


end
