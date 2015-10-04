--Create summarized Measure table.  Add scores from Effective and Timely Care table
CREATE TABLE MeasureSummary AS
	SELECT MeasureID
		, MeasureName
		, 'EffTmlyCare' as EvalType  --for this category, high scores are good
		, Avg(case when Score = 'Not Available' then null else cast(Score as decimal(10,2)) end) as AvgScore
		, stddev_pop(case when Score = 'Not Available' then null else cast(Score as decimal(10,2)) end) as StDevScore
	FROM effective_care
	group by MeasureID, MeasureName;
	
--Add scores from Readmissions and Death table
INSERT INTO TABLE MeasureSummary 
	select MeasureID
		, MeasureName
		, 'ReadminDth'   --for this category, high scores are bad
		, Avg(case when Score = 'Not Available' then null else cast(Score as decimal(10,2)) end) 
		, stddev_pop(case when Score = 'Not Available' then null else cast(Score as decimal(10,2)) end)
	FROM readmissions
	group by MeasureID, MeasureName;