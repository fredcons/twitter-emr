add jar s3://fredcons/libs/hive-json-serde/json-serde-1.1.9.2-jar-with-dependencies.jar;
set hive.optimize.s3.query=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;
set hive.enforce.bucketing = true;
