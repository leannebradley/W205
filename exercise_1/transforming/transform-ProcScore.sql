--Create summarized Procecure Score table.  Add scores from Effective and Timely Care table
--Define a "Relative Score" as this hospital's position in terms of standard deviations better than the national mean
CREATE TABLE ProcedureScore AS
SELECT effective_care.MeasureID
, effective_care.MeasureName
, effective_care.HospitalName
, 'EffTmlyCare' as EvalType  --for this category, high scores are good
, Avg(case when effective_care.Score = 'Not Available' then null else cast(effective_care.Score as decimal(10,2)) end) as AvgScore
, (Avg(case when effective_care.Score = 'Not Available' then null else cast(effective_care.Score as decimal(10,2)) end) - Avg(MeasureSummary.AvgScore))/Avg(MeasureSummary.StDevScore) as RelativeScore
FROM effective_care
join MeasureSummary on (MeasureSummary.MeasureID = effective_care.MeasureID)
group by effective_care.MeasureID, effective_care.MeasureName, effective_care.HospitalName;
--Add scores from Readmissions and Death table
INSERT INTO TABLE ProcedureScore 
select effective_care.MeasureID
, effective_care.MeasureName
, effective_care.HospitalName
, 'ReadminDth'   --for this category, high scores are bad
, Avg(case when effective_care.Score = 'Not Available' then null else cast(effective_care.Score as decimal(10,2)) end)
--reverse the relative score calculation for ReadminDth because, in this case, lower is better
, (Avg(MeasureSummary.AvgScore) - Avg(case when effective_care.Score = 'Not Available' then null else cast(effective_care.Score as decimal(10,2)) end))/Avg(MeasureSummary.StDevScore)
FROM effective_care
join MeasureSummary on (MeasureSummary.MeasureID = effective_care.MeasureID)
group by effective_care.MeasureID, effective_care.MeasureName, effective_care.HospitalName;