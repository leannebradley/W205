--Create table to store raw general hospital data
DROP TABLE hosp_general;
CREATE EXTERNAL TABLE hosp_general(
	ProviderID STRING,HospitalName STRING,Address STRING,City STRING,State STRING,Zip STRING,County STRING,PhoneNumber STRING,HospitalType STRING,Ownership STRING,EmergencySvcs STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/lbradley/hospital_compare/hg';

--Create table to store effective care scores
DROP TABLE effective_care;
CREATE EXTERNAL TABLE effective_care(
	ProviderID STRING,
 	HospitalName STRING,
 	Address STRING,
 	City STRING,
 	State STRING,
 	Zip STRING,
 	County STRING,
 	PhoneNumber STRING,
 	Condition STRING,
 	MeasureID STRING,
 	MeasureName STRING,
 	Score STRING,
 	Sample STRING,
 	Footnote STRING,
 	MeasureStartDt STRING,
 	MeasureEndDt STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/lbradley/hospital_compare/ec';

--Create table to store readmission and death scores
DROP TABLE readmissions;
CREATE EXTERNAL TABLE readmissions(
	ProviderID STRING,
 	HospitalName STRING,
 	Address STRING,
 	City STRING,
 	State STRING,
 	Zip STRING,
 	County STRING,
 	PhoneNumber STRING,
 	MeasureName STRING,
 	MeasureID STRING,
 	CompToNational STRING,
 	Denominator STRING,
 	Score STRING,
 	LowEstimate STRING,
 	HighEstimate STRING,
 	Footnote STRING,
 	MeasureStartDt STRING,
 	MeasureEndDt STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/lbradley/hospital_compare/re';

--Create table to store survey response scores
DROP TABLE surveys_responses;
CREATE EXTERNAL TABLE surveys_responses(
	ProviderID STRING,
 	HospitalName STRING,
 	Address STRING,
 	City STRING,
 	State STRING,
 	Zip STRING,
 	County STRING,
 	CommNurse_Ach STRING,
 	CommNurse_Imp STRING,
 	CommNurse_Dim STRING,
 	CommDoctor_Ach STRING,
 	CommDoctor_Imp STRING,
 	CommDoctor_Dim STRING,
 	CommStaff_Ach STRING,
 	CommStaff_Imp STRING,
 	CommStaff_Dim STRING,
 	PainMgmt_Ach STRING,
 	PainMgmt_Imp STRING,
 	PainMgmt_Dim STRING,
 	CommMeds_Ach STRING,
 	CommMeds_Imp STRING,
 	CommMeds_Dim STRING,
 	CleanQuiet_Ach STRING,
 	CleanQuiet_Imp STRING,
 	CleanQuiet_Dim STRING,
 	Discharge_Ach STRING,
 	Discharge_Imp STRING,
 	Discharge_Dim STRING,
 	Overall_Ach STRING,
 	Overall_Imp STRING,
 	Overall_Dim STRING,
 	HCAHPSBase STRING,
 	HCAHPSConsistency STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/lbradley/hospital_compare/sr';
