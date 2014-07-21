

LOAD DATA INPATH 's3://fredcons/fluentd/twitter/worldcup/input/20140531/' OVERWRITE INTO TABLE tweets;

SELECT hashtag, COUNT(*) FROM tweets LATERAL VIEW explode(split(entities_hashtags.text, ' ')) lTable as hashtag GROUP BY hashtag;

SELECT hashtag, COUNT(*) FROM tweets LATERAL VIEW explode(entities_hashtags.text) lTable as hashtag GROUP BY hashtag;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/hashtags_by_count/' SELECT hashtag, COUNT(*) as total FROM tweets LATERAL VIEW explode(entities_hashtags.text) temp_table as hashtag GROUP BY hashtag order by total desc;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/users_by_count/' SELECT user_name, user_screen_name, COUNT(*) as total FROM tweets GROUP BY user_name, user_screen_name  order by total desc;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/words_by_count/' SELECT word, COUNT(*) as total FROM tweets LATERAL VIEW  explode(split(lower(text), ' ')) temp_table as word GROUP BY word order by total desc;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/top_100_ngrams/' select ngrams(sentences(lower(text)), 3, 100) FROM tweets;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/top_100_support_ngrams/' select context_ngrams(sentences(lower(text)), array("support", null), 100) from tweets;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/emoticons/' SELECT hashtag, regexp_extract(text, "((?:\\;|:|=|8|\\\\^|X|:\\'|<|>)(?:-|O|c|\\\\.|_|\\\\^)?(?:D|P|<|>|\\\\)\\\\)|\\\\(\\\\(|\\\\|\\\\||\\;|=|X|O|\\\\*|S|\\\\|\\\\{|\\\\}|\\\\[|\\\\]|\\\\(|\\\\)))", 0) as emoticon, COUNT(*) as total FROM tweets LATERAL VIEW explode(entities_hashtags.text) temp_table as hashtag GROUP BY hashtag, regexp_extract(text, "((?:\\;|:|=|8|\\\\^|X|:\\'|<|>)(?:-|O|c|\\\\.|_|\\\\^)?(?:D|P|<|>|\\\\)\\\\)|\\\\(\\\\(|\\\\|\\\\||\\;|=|X|O|\\\\*|S|\\\\|\\\\{|\\\\}|\\\\[|\\\\]|\\\\(|\\\\)))", 0) order by total desc;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/emojis/' SELECT hashtag, regexp_extract(text, "[\u1F60-\u1F64]|[\u2702-\u27B0]|[\u1F68-\u1F6C]|[\u1F30-\u1F70]", 0) as emoticon, COUNT(*) as total FROM tweets LATERAL VIEW explode(entities_hashtags.text) temp_table as hashtag GROUP BY hashtag, regexp_extract(text, "[\u1F60-\u1F64]|[\u2702-\u27B0]|[\u1F68-\u1F6C]|[\u1F30-\u1F70]", 0) order by total desc;


Time taken: 138.594 seconds, Fetched: 53891 row(s)
Time taken: 110.191 seconds, Fetched: 8568 row(s)

TABLESAMPLE(0.1 PERCENT)

-- insert data from local table





((?:\\;|:|=|8|\\\\^|X|:\\'|<|>)(?:-|O|c|\\\\.|_|\\\\^)?(?:D|P|<|>|\\\\)\\\\)|\\\\(\\\\(|\\\\|\\\\||\\;|=|X|O|\\\\*|S|\\\\||\\\\{|\\\\}|\\\\[|\\\\]|\\\\(|\\\\)))



