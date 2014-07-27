create table if not exists count_by_username (
  user_name string,
  user_screen_name string,
  tweets_count bigint
)
row format delimited fields terminated by ","
location '${LOCATION}';