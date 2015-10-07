--Create Survey Response summary table
DROP TABLE SurveyResults;
CREATE TABLE SurveyResults AS
SELECT HospitalName
, Avg(Overall_Dim) as AvgOverallScore
, stddev_pop(Overall_Dim) as StDevOverallScore
from
(SELECT HospitalName
, cast(trim(substr(Overall_Dim, 2, 2)) as decimal(10,2)) as Overall_Dim
FROM surveys_responses
where Overall_Dim <> 'Not Available') a
group by HospitalName;


