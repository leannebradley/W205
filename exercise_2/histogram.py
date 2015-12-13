#!/usr/bin/python

import sys
import psycopg2

# connect to twitter feed database
conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()

k1 = sys.argv[1]  #minimum number of occurences passed by user
k2 = sys.argv[2]  #maximum number of occurences passed by user

#print all words and wordcounts where the count is between k1 and k2, sort by count descending
cur.execute("SELECT word, count FROM tweetwordcount WHERE count >= %s AND count <= %s ORDER BY count DESC", (k1, k2))
records = cur.fetchall()
for rec in records:
   print rec[0], ": ", rec[1]
conn.commit()


conn.close()
