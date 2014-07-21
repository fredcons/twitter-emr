add jar s3://fredcons/libs/hive-json-serde/json-serde-1.1.9.2-jar-with-dependencies.jar;
SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec;
insert overwrite table tweets_flat select distinct t.id, t.created_at, t.user_name, t.user_screen_name, regexp_replace(t.text, '\\n', ''), t.user_followers_count, t.user_friends_count from tweets t;
