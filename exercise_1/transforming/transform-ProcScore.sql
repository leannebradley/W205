--Create summarized Procecure Score table.  Add scores from Effective and Timely Care table
CREATE TABLE ProcedureScore AS
	SELECT MeasureID
		, MeasureName
		, HospitalName
		, 'EffTmlyCare' as EvalType  --for this category, high scores are good
		, Avg(cast(Score as int)) as AvgScore
	FROM effective_care;
--Add scores from Readmissions and Death table
INSERT INTO TABLE ProcedureScore 
	select MeasureID
		, MeasureName
		, HospitalName
		, 'ReadminDth' as EvalType  --for this category, high scores are bad
		, Avg(cast(Score as int)) as AvgScore 
	FROM readmissions;