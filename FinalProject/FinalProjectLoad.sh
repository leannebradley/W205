# establish a raw data folder
mkdir finalproj_raw_data
cd finalproj_raw_data/

# pull raw data from City of Chicago and National Centers for Environmental Information
wget -O ./crimes.csv https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD  
wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd_all.tar.gz
wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt
tar -xzvf ghcnd_all.tar.gz


# rename text files and remove header row
tail -n +2 crimes.csv > chicago_crimes.csv
mv ghcnd-stations.txt stations.txt

cd ghcnd_all
rename .dly .txt *.dly

cd ..

# pull Chicago community area names in from Git folder
mv /data/Git/W205/FinalProject/CommunityAreas.csv CommunityAreas.csv


# create HDFS folders
hdfs dfs -mkdir /user/lbradley/chicago_crimes
hdfs dfs -put chicago_crimes.csv /user/lbradley/chicago_crimes
hdfs dfs -mkdir /user/lbradley/weather
hdfs dfs -put ghcnd_all /user/lbradley/weather
hdfs dfs -mkdir /user/lbradley/stations
hdfs dfs -put stations.txt /user/lbradley/stations
hdfs dfs -mkdir /user/lbradley/commareas
hdfs dfs -put CommunityAreas.csv /user/lbradley/commareas


