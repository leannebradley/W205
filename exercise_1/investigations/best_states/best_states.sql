--Use the Relative Score defined for question one, and aggregate it at the state level.
select Hospital.State
	, sum(case when ProcedureScore.EvalType='EffTmlyCare' then 1 else 0 end) as num_EffTmlyCare_scores
	, sum(case when ProcedureScore.EvalType='ReadminDth' then 1 else 0 end) as num_ReadminDth_scores
	, avg(ProcedureScore.RelativeScore) as avgRelScore   
	, stddev_pop(ProcedureScore.RelativeScore) as stdevRelScore
from ProcedureScore
join Hospital on (Hospital.HospitalName = ProcedureScore.HospitalName)
group by Hospital.State
order by avgRelScore DESC limit 10;