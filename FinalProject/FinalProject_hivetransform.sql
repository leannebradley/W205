-- Create raw crime table
CREATE TABLE chi_crime AS
SELECT Crime_date as crime_timestamp	-- format: 11/27/2015 11:51:00 PM
, CONCAT(substr(Crime_date, 7, 4),substr(Crime_date, 1, 2),substr(Crime_date, 4, 2)) as CrimeDate
, cast(trim(substr(Crime_date,12,2)) as Int) as Hour
, substr(Crime_date,21,2) as AM_PM
, PrimaryType
, Description
, CommunityArea
, cast(trim(Latitude) as decimal(16,9)) as Latitude
, cast(trim(Longitude) as decimal(16,9)) as Longitude
FROM chicago_crimes;



-- Extract necessary elements from raw weather data - focus on recent years
CREATE TABLE weather_filtered AS
SELECT * FROM weather_raw where cast(YEAR as Int) > 2000 and (ELEMENT='TMAX' or ELEMENT='PRCP');



-- Create raw station table.  Many stations only have Precipitation data.  We need to filter for stations that have temperature.
CREATE TABLE station_loc AS
SELECT s.ID
, cast(trim(s.Latitude) as decimal(16,9)) as Latitude
, cast(trim(s.Longitude) as decimal(16,9)) as Longitude
FROM stations s join 
(select distinct ID from weather_filtered where ELEMENT='TMAX') w on w.ID = s.ID;



-- Identify each Community Area's average lat/long to reduce the number of crime-to-weather lat/long joins and improve performance.
-- Remove data with missing elements on nonsensical lat/long 
CREATE TABLE CA_center AS
SELECT CommunityArea
, avg(Latitude) as avgLatitude
, avg(Longitude) as avgLongitude
FROM chi_crime
where Latitude is not null and Longitude is not null and CommunityArea is not null and abs(Latitude) < 90 and abs(Longitude) < 180
GROUP BY CommunityArea;



-- Find the Weather Station closest to each Community Area. Maximum distance is 15 miles.
CREATE TABLE CA_station AS
SELECT CommunityArea, ID FROM (
SELECT CommunityArea, ID, rank() over (PARTITION BY CommunityArea ORDER BY distance) as rank
FROM (
SELECT w.CommunityArea
, c.ID
, ( 3959 * acos( cos( radians(c.Latitude) ) * cos( radians( w.avgLatitude ) )  * cos( radians( w.avgLongitude ) - radians(c.Longitude) ) + sin( radians(c.Latitude) ) * sin( radians( w.avgLatitude ) ) ) ) AS distance 
FROM station_loc c CROSS JOIN CA_center w ) a
WHERE distance < 15 ) b
WHERE rank = 1;



-- Filter the weather data for only the required stations
CREATE TABLE weather_filter2 AS
SELECT w.* FROM weather_filtered w join (select distinct ID from CA_station) s where w.ID = s.ID;



-- Transpose weather data fields from columns to rows
CREATE TABLE weather_transpose AS
SELECT ID, CONCAT(YEAR, MONTH, "01") as weatherdate, ELEMENT, VALUE1 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "02") as weatherdate, ELEMENT, VALUE2 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "03") as weatherdate, ELEMENT, VALUE3 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "04") as weatherdate, ELEMENT, VALUE4 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "05") as weatherdate, ELEMENT, VALUE5 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "06") as weatherdate, ELEMENT, VALUE6 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "07") as weatherdate, ELEMENT, VALUE7 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "08") as weatherdate, ELEMENT, VALUE8 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "09") as weatherdate, ELEMENT, VALUE9 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "10") as weatherdate, ELEMENT, VALUE10 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "11") as weatherdate, ELEMENT, VALUE11 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "12") as weatherdate, ELEMENT, VALUE12 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "13") as weatherdate, ELEMENT, VALUE13 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "14") as weatherdate, ELEMENT, VALUE14 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "15") as weatherdate, ELEMENT, VALUE15 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "16") as weatherdate, ELEMENT, VALUE16 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "17") as weatherdate, ELEMENT, VALUE17 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "18") as weatherdate, ELEMENT, VALUE18 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "19") as weatherdate, ELEMENT, VALUE19 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "20") as weatherdate, ELEMENT, VALUE20 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "21") as weatherdate, ELEMENT, VALUE21 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "22") as weatherdate, ELEMENT, VALUE22 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "23") as weatherdate, ELEMENT, VALUE23 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "24") as weatherdate, ELEMENT, VALUE24 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "25") as weatherdate, ELEMENT, VALUE25 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "26") as weatherdate, ELEMENT, VALUE26 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "27") as weatherdate, ELEMENT, VALUE27 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "28") as weatherdate, ELEMENT, VALUE28 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "29") as weatherdate, ELEMENT, VALUE29 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "30") as weatherdate, ELEMENT, VALUE30 as Value FROM weather_filter2 union all
SELECT ID, CONCAT(YEAR, MONTH, "31") as weatherdate, ELEMENT, VALUE31 as Value FROM weather_filter2;

 
-- Consolidate data so there is one record per date (transpose temperatures and precipitation from rows to columns)
CREATE TABLE weather_consolidate AS 
SELECT ID
, weatherdate
, sum(case when ELEMENT='TMAX' then cast(trim(Value) as Int) else 0 end) as TMAX
, sum(case when ELEMENT='PRCP' then cast(trim(Value) as Int) else 0 end) as PRCP
FROM weather_transpose
where Value <> '-9999'
group by ID, weatherdate;



-- Create weather summary table with wet/dry flag, temperature bands, and number of similar days as a metric denominator
CREATE TABLE Weather_Summary AS
SELECT CommunityArea, weatherdate, WetDryFlag, TempBand, count(*) over (PARTITION BY CommunityArea, WetDryFlag, TempBand) as denom
FROM (SELECT c.CommunityArea
, w.weatherdate
, (case when w.PRCP>20 then 'w' else 'd' end) as WetDryFlag 
, round(w.TMAX/50) as TempBand -- 5 degree Celcius temperature bands
FROM CA_station c JOIN weather_consolidate w ON (c.ID = w.ID)) a;



-- Join weather, crime and community area name tables into one summary statistics table
CREATE TABLE Summary_Stats AS
SELECT c.CommAreaName, a.PrimaryType, a.DayNightFlag, a.WetDryFlag, a.TempBand, count(*) as NumberOfOccurences, max(a.denom) as DistinctDatesLikeThis
FROM (SELECT c.CommunityArea
, c.PrimaryType
, (case when (c.AM_PM = 'PM' and c.Hour > 7) or (c.AM_PM = 'AM' and c.Hour < 7)  then 'n' else 'd' end) as DayNightFlag
, w.WetDryFlag
, w.TempBand
, w.denom 
FROM chi_crime c JOIN Weather_Summary w ON (w.CommunityArea = c.CommunityArea and w.weatherdate = c.CrimeDate)) a
join communityareas c on c.CommunityArea = a.CommunityArea
group by c.CommAreaName, a.PrimaryType, a.DayNightFlag, a.WetDryFlag, a.TempBand;




