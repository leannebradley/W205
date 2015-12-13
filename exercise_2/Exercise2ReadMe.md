# ReadMe file for MIDS w205 Exercise 2 - L Bradley

Steps to run this project:

  - Clone exercise_2 folder from Github.
  - Start Postgres:
```sh
$ mount /dev/xvdf /data
$ cd /data
$ sh start_postgres.sh 
```
  - Open psql, create a database name tcount with a table called tweetwordcount:
```sh
$ psql -U postgres
# CREATE DATABASE tcount;
# \c tcount
# CREATE TABLE tweetwordcount
#        (word TEXT PRIMARY KEY NOT NULL,
#        count INT NOT NULL);
# \q
```
  - Open EX2Tweetwordcount/src/spouts/tweets.py and update the Twitter credentials.
  - Run streamparse in bash: 
 ```sh
$ cd /exercise_2/EX2Tweetwordcount
$ streamparse run
```
  - Allow the twitter stream to run for several minutes (you can monitor on screen).  
  - Type ctrl-c to close the stream.
  - Use finalresults.py to explore the wordcounts: 
```sh
$ cd /exercise_2
$ python finalresults.py you
$ python finalresults.py
```
  - Use histogram.py to explore words with counts within a certain range: 
```sh
$ python histogram.py 100 400
```
