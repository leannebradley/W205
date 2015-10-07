--Create summarized Procecure Score table.  Add scores from Effective and Timely Care table
--Define a "Relative Score" as this hospital's position in terms of standard deviations better than the national mean
DROP TABLE ProcedureScore;
CREATE TABLE ProcedureScore AS
SELECT a.MeasureID
, a.MeasureName
, a.HospitalName
, 'EffTmlyCare' as EvalType  --for this category, high scores are good
, Avg(a.score) as AvgScore
, (Avg(a.score) - Avg(MeasureSummary.AvgScore))/Avg(MeasureSummary.StDevScore) as RelativeScore
from (
select HospitalName, MeasureID, MeasureName, cast(regexp_replace(Score, '"', '') as decimal(10,2)) as Score
from effective_care) a
join MeasureSummary on (MeasureSummary.MeasureID = a.MeasureID)
where Score is not null 
group by a.MeasureID, a.MeasureName, a.HospitalName;
--Add scores from Readmissions and Death table
INSERT INTO TABLE ProcedureScore 
select a.MeasureID
, a.MeasureName
, a.HospitalName
, 'ReadminDth'   --for this category, high scores are bad
, Avg(a.score)
--reverse the relative score calculation for ReadminDth because, in this case, lower is better
, (Avg(MeasureSummary.AvgScore) - Avg(a.score))/Avg(MeasureSummary.StDevScore)
FROM (
select HospitalName, MeasureID, MeasureName, cast(regexp_replace(Score, '"', '') as decimal(10,2)) as Score
from readmissions) a
join MeasureSummary on (MeasureSummary.MeasureID = a.MeasureID)
where Score is not null 
group by a.MeasureID, a.MeasureName, a.HospitalName;