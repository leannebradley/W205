# extract results from Hive for use in Tableau
hive -e 'select * from summary_stats' > finalresults.txt

