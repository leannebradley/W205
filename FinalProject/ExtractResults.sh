# extract results from Hive, export to Git repository
hive -e 'select * from summary_stats' > finalresults.txt

mv finalresults.txt /data/Git/W205/FinalProject/finalresults.txt

cd /data/Git/W205/FinalProject
git add .
git commit -am "final project results"
git push