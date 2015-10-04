#! /bin/bash

#move to the right folder 
cd /...
mkdir exercise1_raw_data
cd exercise1_raw_data

#pull data from online source
wget -0 ./hospital.zip https://data.medicare.gov/views/bg9k-emty/files/Nqcy71p9Ss2RSBWDmP77H1DQXcyacr2khotGbDHHW_s?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_Flatfiles.zip

#unzip
unzip hospital.zip

#rename files and remove header row
tail -n +2 Hospital\ General\ Information.csv > hosp_general.csv
tail -n +2 Timely\ and\ Effective\ Care\ -\ Hospital.csv > effective_care.csv
tail -n +2 Readmissions\ and\ Deaths\ -\ Hospital.csv > readmissions.csv
tail -n +2 hvbp_hcahps_05_28_2015.csv > surveys_responses.csv


#create HDFS folders
hdfs dfs -mkdir /user/lbradley/hospital_compare
hdfs dfs -put hosp_general.csv /user/lbradley/hospital_compare
hdfs dfs -put effective_care.csv /user/lbradley/hospital_compare
hdfs dfs -put readmissions.csv /user/lbradley/hospital_compare
hdfs dfs -put surveys_responses.csv /user/lbradley/hospital_compare