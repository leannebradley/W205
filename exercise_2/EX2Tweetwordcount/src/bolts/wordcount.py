from __future__ import absolute_import, print_function, unicode_literals

from collections import Counter
from streamparse.bolt import Bolt
import psycopg2


class WordCounter(Bolt):

    def initialize(self, conf, ctx):
        self.counts = Counter()

    def process(self, tup):
        word = tup.values[0]

        # Increment the local count
        self.counts[word] += 1
        self.emit([word, self.counts[word]])

	#Insert new words into tweetwordcount
	conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
	cur = conn.cursor()
	cur.execute("INSERT INTO tweetwordcount (word,count) \
      		SELECT %s, 0 WHERE NOT EXISTS (SELECT word FROM tweetwordcount WHERE word = %s)", (word, word));
	conn.commit()

	#Update word counts in the database
	cur.execute("UPDATE tweetwordcount SET count = %s WHERE word = %s", (self.counts[word],word))
	conn.commit()

        # DEPRECATED - Log the count - just to see the topology running
        self.log('%s: %d' % (word, self.counts[word]))
