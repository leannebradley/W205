--Create Survey Response summary table
CREATE TABLE SurveyResults AS
	SELECT HospitalName
		, Avg(case when Overall_Dim = 'Not Available' then null else cast(Overall_Dim as decimal(10,2)) end) as AvgOverallScore
		, Avg(case when HCAHPSBase = 'Not Available' then null else cast(HCAHPSBase as decimal(10,2)) end) as AvgHCAHPSBase
		, Avg(case when HCAHPSConsistency = 'Not Available' then null else cast(HCAHPSConsistency as decimal(10,2)) end) as AvgHCAHPSConsistency
		, stddev_pop(case when Overall_Dim = 'Not Available' then null else cast(Overall_Dim as decimal(10,2)) end) as StDevOverallScore
		, stddev_pop(case when HCAHPSBase = 'Not Available' then null else cast(HCAHPSBase as decimal(10,2)) end) as StDevHCAHPSBase
		, stddev_pop(case when HCAHPSConsistency = 'Not Available' then null else cast(HCAHPSConsistency as decimal(10,2)) end) as StDevHCAHPSConsistency
	FROM surveys_responses
	group by HospitalName;

