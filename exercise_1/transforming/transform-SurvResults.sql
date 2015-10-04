--Create Survey Response summary table
CREATE TABLE SurveyResults AS
	SELECT HospitalName
		, Avg(cast(Overall_Dim as int)) as AvgOverallScore
		, Avg(cast(HCAHPSBase as int)) as AvgHCAHPSBase
		, Avg(cast(HCAHPSConsistency as int)) as AvgHCAHPSConsistency
	FROM surveys_responses;

