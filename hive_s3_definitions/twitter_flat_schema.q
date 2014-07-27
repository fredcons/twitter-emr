create external table if not exists tweets_flat (
  id bigint, 
  created_at string,
  user_name string,
  user_screen_name string,
  text string,
  user_followers_count int,
  user_friends_count int
) 
row format delimited fields terminated by ","
location '${LOCATION}';