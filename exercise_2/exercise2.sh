sparse quickstart EX2Tweetwordcount
cd ~
mkdir ex2
git clone https://github.com/UC-Berkeley-I-School/w205-labs-exercises.git

cd ~/EX2Tweetwordcount/

cp ~/ex2/w205-labs-exercises/exercise_2/tweetwordcount/src/spouts/tweets.py ~/EX2Tweetwordcount/src/spouts/tweets.py
cp ~/ex2/w205-labs-exercises/exercise_2/tweetwordcount/src/bolts/parse.py ~/EX2Tweetwordcount/src/bolts/parse.py
cp ~/ex2/w205-labs-exercises/exercise_2/tweetwordcount/src/bolts/wordcount.py ~/EX2Tweetwordcount/src/bolts/wordcount.py
cp ~/ex2/w205-labs-exercises/exercise_2/tweetwordcount/topologies/tweetwordcount.clj ~/EX2Tweetwordcount/topologies/tweetwordcount.clj

mv tweetwordcount.clj EX2tweetwordcount.clj
vim EX2tweetwordcount.clj  #change number of parallels to 3,3,2

mount /dev/xvdf /data
cd /data
sh start_postgres.sh 

# In Postgres
# CREATE DATABASE tcount;
# \c tcount
# CREATE TABLE tweetwordcount
#       (word TEXT PRIMARY KEY NOT NULL,
#       count INT NOT NULL);

# make updates to EX2tweetwordcount.clj and tweets.py

streamparse run  #let this run for a few minutes



