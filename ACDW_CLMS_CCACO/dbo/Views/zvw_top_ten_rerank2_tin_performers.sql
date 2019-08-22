

create view [dbo].[zvw_top_ten_rerank2_tin_performers]
as 

select tin, tot_den, perc, perc_of_memb*.9+perc_gap*.1/.4 as rerank from (
select tin, percent_rank() over (order by perc_of_memb) as perc_mbr,tot_den, perc_of_memb, perc, perc_gap
from (

select tin, tot_den, tot_num, perc, cast(tot_den as float) /(select sum(tot_den) from vw_tin_performance_caregap) as perc_of_memb,PERCENT_RANK( )  
    OVER ( order by perc ) as   perc_gap  from 
vw_tin_performance_caregap) a) z
--order by perc_of_memb*.9+perc_gap/.4*.1 desc
