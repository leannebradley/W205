--Calculate the maximum hospital relative score for each procedure, minus the minimum hospital relative score for each procedure.
select * from (
SELECT MeasureID, MeasureName, rank() over (ORDER BY rangeRelScore DESC) as rank, maxRelScore, minRelScore, rangeRelScore
FROM (select MeasureID
, MeasureName
, max(RelativeScore) as maxRelScore
, min(RelativeScore) as minRelScore
, max(RelativeScore) - min(RelativeScore) as rangeRelScore
from ProcedureScore
group by MeasureID, MeasureName ) a ) b
where rank < 11;