#!/bin/sh
reference_date=$1
mkdir twitter-worldcup-$reference_date
aws s3 sync s3://fredcons/fluentd/twitter/worldcup/input/$reference_date/ twitter-worldcup-$reference_date
(cd twitter-worldcup-$reference_date && gunzip *)
(cd twitter-worldcup-$reference_date && cat * > combined)
find twitter-worldcup-$reference_date -type f |grep -v combined | xargs rm -f
(cd twitter-worldcup-$reference_date && gzip combined)
aws s3 sync twitter-worldcup-$reference_date s3://fredcons/fluentd/twitter/worldcup/input_combined/date=$reference_date/ --delete
rm -rf twitter-worldcup-$reference_date
