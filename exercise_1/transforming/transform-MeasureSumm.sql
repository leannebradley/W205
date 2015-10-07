--Create summarized Measure table.  Add scores from Effective and Timely Care table
DROP TABLE MeasureSummary;
CREATE TABLE MeasureSummary AS
SELECT MeasureID
, MeasureName
, 'EffTmlyCare' as EvalType  --for this category, high scores are good
, Avg(Score) as AvgScore
, stddev_pop(Score) as StDevScore
FROM (
select MeasureID, MeasureName, cast(regexp_replace(Score, '"', '') as decimal(10,2)) as Score
from effective_care) a
where Score is not null 
group by MeasureID, MeasureName;
--Add scores from Readmissions and Death table
INSERT INTO TABLE MeasureSummary 
select MeasureID
, MeasureName
, 'ReadminDth'   --for this category, high scores are bad
, Avg(Score) as AvgScore
, stddev_pop(Score) as StDevScore
FROM (
select MeasureID, MeasureName, cast(regexp_replace(Score, '"', '') as decimal(10,2)) as Score
from readmissions) a
where Score is not null 
group by MeasureID, MeasureName;


