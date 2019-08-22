create view [zvw_top_ten_rerank_tin_performers]
as 
select tin, tot_den, tot_num, perc,perc_of_memb*100*percentile as true_rank 
from (

select TIN, tot_den, tot_num, perc, cast(tot_den as float) /(select sum(tot_den) from vw_tin_performance_caregap) as perc_of_memb,PERCENT_RANK( )  
    OVER ( order by perc ) as   percentile  from 
[vw_tin_performance_caregap]) a