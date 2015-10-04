--Create simple Hospital summary table
CREATE TABLE Hospital AS
	SELECT HospitalName
		, State
	FROM hosp_general;


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


--Create Survey Response summary table
CREATE TABLE SurveyResults AS
	SELECT HospitalName
		, Avg(cast(Overall_Dim as int)) as AvgOverallScore
		, Avg(cast(HCAHPSBase as int)) as AvgHCAHPSBase
		, Avg(cast(HCAHPSConsistency as int)) as AvgHCAHPSConsistency
	FROM surveys_responses;

