-- I've defined RelativeScore as the hospital's position, in terms of standard deviation, compared to the national mean
select HospitalName
, sum(case when EvalType='EffTmlyCare' then 1 else 0 end) as num_EffTmlyCare_scores
, sum(case when EvalType='ReadminDth' then 1 else 0 end) as num_ReadminDth_scores
, avg(RelativeScore) as avgRelScore   
, stddev_pop(RelativeScore) as stdevRelScore
from ProcedureScore
group by HospitalName
order by avgRelScore DESC limit 10;