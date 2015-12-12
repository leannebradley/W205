--Create table to store raw crime data
CREATE EXTERNAL TABLE chicago_crimes(ID STRING,Case_Number STRING,Crime_date STRING,Block STRING,IUCR STRING,PrimaryType STRING,Description STRING,LocationDescription STRING,Arrest STRING,Domestic STRING,Beat STRING,District STRING,Ward STRING,CommunityArea STRING,FBICode STRING,XCoordinate STRING,YCoordinate STRING,Year STRING,UpdatedOn STRING,Latitude STRING,Longitude STRING,Location STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
LOCATION '/user/lbradley/chicago_crimes';


--Create table to store raw weather station metadata
CREATE EXTERNAL TABLE stations0(fixedwidth STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE
LOCATION '/user/lbradley/stations';


--Transform fixed-width data into stations table
CREATE TABLE stations AS
SELECT substr(fixedwidth, 1, 11) as ID
, substr(fixedwidth, 13, 8) as Latitude
, substr(fixedwidth, 22, 9) as Longitude
FROM stations0;


--Create table to store raw daily weather data. Convert fixed width columns with regex.
CREATE EXTERNAL TABLE weather0(fixedwidth STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
LOCATION '/user/lbradley/weather/ghcnd_all';


--Transform fixed-width data i data into weather table
CREATE TABLE weather_raw AS
SELECT substr(fixedwidth, 1, 11) as ID
, substr(fixedwidth, 12, 4) as YEAR
, substr(fixedwidth, 16, 2) as MONTH
, substr(fixedwidth, 18, 4) as ELEMENT
, substr(fixedwidth, 22, 5) as VALUE1
, substr(fixedwidth, 30, 5) as VALUE2
, substr(fixedwidth, 38, 5) as VALUE3
, substr(fixedwidth, 46, 5) as VALUE4
, substr(fixedwidth, 54, 5) as VALUE5
, substr(fixedwidth, 62, 5) as VALUE6
, substr(fixedwidth, 70, 5) as VALUE7
, substr(fixedwidth, 78, 5) as VALUE8
, substr(fixedwidth, 86, 5) as VALUE9
, substr(fixedwidth, 94, 5) as VALUE10
, substr(fixedwidth, 102, 5) as VALUE11
, substr(fixedwidth, 110, 5) as VALUE12
, substr(fixedwidth, 118, 5) as VALUE13
, substr(fixedwidth, 126, 5) as VALUE14
, substr(fixedwidth, 134, 5) as VALUE15
, substr(fixedwidth, 142, 5) as VALUE16
, substr(fixedwidth, 150, 5) as VALUE17
, substr(fixedwidth, 158, 5) as VALUE18
, substr(fixedwidth, 166, 5) as VALUE19
, substr(fixedwidth, 174, 5) as VALUE20
, substr(fixedwidth, 182, 5) as VALUE21
, substr(fixedwidth, 190, 5) as VALUE22
, substr(fixedwidth, 198, 5) as VALUE23
, substr(fixedwidth, 206, 5) as VALUE24
, substr(fixedwidth, 214, 5) as VALUE25
, substr(fixedwidth, 222, 5) as VALUE26
, substr(fixedwidth, 230, 5) as VALUE27
, substr(fixedwidth, 238, 5) as VALUE28
, substr(fixedwidth, 246, 5) as VALUE29
, substr(fixedwidth, 254, 5) as VALUE30
, substr(fixedwidth, 262, 5) as VALUE31
FROM weather0
where (substr(fixedwidth, 18, 4) = 'TMAX' or substr(fixedwidth, 18, 4) = 'TMIN' or substr(fixedwidth, 18, 4) = 'PRCP');


--Create table to store Community Area names
CREATE EXTERNAL TABLE communityareas(CommunityArea STRING,CommAreaName STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE
LOCATION '/user/lbradley/commareas';

