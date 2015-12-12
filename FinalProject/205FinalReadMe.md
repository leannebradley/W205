# ReadMe file for MIDS w205 Final Project - L Bradley

Goal of the project

  - Load and format Chicago Crimes and Weather Station data
  - Stitch data together 
  - Make data available to Tableau to explore relationship between weather and violent crime

Steps to run this project:

  - Run FinalProjectLoad.sh in bash to import data and create HDFS folders
  - Run finalproject_hivebase.sql in Hive to create raw data tables 
  - Run finalproject_hivetransform.sql in Hive to stitch weather and crime data together and generate summary statistics
  - Run ExtractResults.sh in bash to extract results from Hive for use in Tableau
  - Open the Tableau workbook CrimeandWeather.twb to explore the data
