--Calculate the correlation between hospitals' overall survey scores and their relative score,
--calculated based on Timely and Effective Care and Readmissions and Death
select corr(a.avgRelScore, SurveyResults.AvgOverallScore) as corr_scores
from
	(
	select HospitalName
		, avg(RelativeScore) as avgRelScore 
	from ProcedureScore
	group by HospitalName
	) a
join SurveyResults on (a.HospitalName = SurveyResults.HospitalName);