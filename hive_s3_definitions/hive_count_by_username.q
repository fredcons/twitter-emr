SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec;

set hive.optimize.s3.query=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;
set hive.enforce.bucketing = true;

insert overwrite directory 's3://fredcons/fluentd/twitter/worldcup/output/hive_users_by_count/' SELECT user_name, user_screen_name, COUNT(*) as total FROM tweets_flat GROUP BY user_name, user_screen_name  order by total desc;