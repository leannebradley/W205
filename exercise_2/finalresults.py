#!/usr/bin/python

import sys
import psycopg2

# connect to twitter feed database
conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()

# if the user does not pass a word, return all word counts in alphabetical order
if len(sys.argv) == 1:
        cur.execute("SELECT word, count FROM tweetwordcount ORDER BY word")
        records = cur.fetchall()
        for rec in records:
           print rec[0], ",", rec[1]
        conn.commit()
# if the user passes a word, return the number of instances of that word
else:
        wordarg = sys.argv[1]
        cur.execute("SELECT * FROM tweetwordcount WHERE word = %s", [wordarg])
        records = cur.fetchall()
        for rec in records:
           print 'Total number of occurences of ', rec[0],': ', rec[1]
        conn.commit()

conn.close()


