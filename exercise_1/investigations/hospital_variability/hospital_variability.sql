--Calculate the maximum hospital relative score for each procedure, minus the minimum hospital relative score for each procedure.
select MeasureID
	, MeasureName
	, max(RelativeScore) as maxRelScore
	, min(RelativeScore) as minRelScore
	, max(RelativeScore) - min(RelativeScore) as rangeRelScore
from ProcedureScore
group by MeasureID, MeasureName
order by rangeRelScore DESC limit 10;