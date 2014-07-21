add jar s3://fredcons/libs/hive-json-serde/json-serde-1.1.9.2-jar-with-dependencies.jar;
create external table if not exists tweets (
   coordinates_coordinates array <float>,
   coordinates_type string,
   created_at string,
   entities_hashtags array <struct <
         indices: array <int>,
         text: string>>,
   entities_media array <struct <
         display_url: string,
         expanded_url: string,
         id: bigint,
         id_str: binary,
         indices: array <int>,
         media_url: string,
         media_url_https: string,
         sizes: struct <
            large: struct <
               h: smallint,
               resize: string,
               w: smallint>,
            medium: struct <
               h: smallint,
               resize: string,
               w: smallint>,
            small: struct <
               h: smallint,
               resize: string,
               w: smallint>,
            thumb: struct <
               h: smallint,
               resize: string,
               w: smallint>>,
         source_status_id: bigint,
         source_status_id_str: binary,
         type: string,
         url: string>>,
   entities_urls array <struct <
         display_url: string,
         expanded_url: string,
         indices: array <int>,
         url: string>>,
   entities_user_mentions array <struct <
         id: int,
         id_str: string,
         indices: array <int>,
         name: string,
         screen_name: string>>,
   favorite_count int,
   favorited boolean,
   filter_level string,
   geo_coordinates array <float>,
   geo_type string,
   id bigint,
   id_str binary,
   in_reply_to_screen_name string,
   in_reply_to_status_id bigint,
   in_reply_to_status_id_str binary,
   in_reply_to_user_id int,
   in_reply_to_user_id_str string,
   lang string,
   place_bounding_box_coordinates array <array <array <float>>>,
   place_bounding_box_type string,
   place_country string,
   place_country_code string,
   place_full_name string,
   place_id binary,
   place_name string,
   place_place_type string,
   place_url string,
   possibly_sensitive boolean,
   retweet_count int,
   retweeted boolean,
   retweeted_status_coordinates_coordinates array <float>,
   retweeted_status_coordinates_type string,
   retweeted_status_created_at string,
   retweeted_status_entities_hashtags array <struct <
         indices: array <int>,
         text: string>>,
   retweeted_status_entities_media array <struct <
         display_url: string,
         expanded_url: string,
         id: bigint,
         id_str: binary,
         indices: array <smallint>,
         media_url: string,
         media_url_https: string,
         sizes: struct <
            large: struct <
               h: smallint,
               resize: string,
               w: smallint>,
            medium: struct <
               h: smallint,
               resize: string,
               w: smallint>,
            small: struct <
               h: smallint,
               resize: string,
               w: smallint>,
            thumb: struct <
               h: smallint,
               resize: string,
               w: smallint>>,
         source_status_id: bigint,
         source_status_id_str: binary,
         type: string,
         url: string>>,
   retweeted_status_entities_urls array <struct <
         display_url: string,
         expanded_url: string,
         indices: array <int>,
         url: string>>,
   retweeted_status_entities_user_mentions array <struct <
         id: int,
         id_str: string,
         indices: array <int>,
         name: string,
         screen_name: string>>,
   retweeted_status_favorite_count int,
   retweeted_status_favorited boolean,
   retweeted_status_filter_level string,
   retweeted_status_geo_coordinates array <float>,
   retweeted_status_geo_type string,
   retweeted_status_id bigint,
   retweeted_status_id_str string,
   retweeted_status_in_reply_to_screen_name string,
   retweeted_status_in_reply_to_status_id bigint,
   retweeted_status_in_reply_to_status_id_str binary,
   retweeted_status_in_reply_to_user_id int,
   retweeted_status_in_reply_to_user_id_str string,
   retweeted_status_lang string,
   retweeted_status_place_bounding_box_coordinates array <array <array <float>>>,
   retweeted_status_place_bounding_box_type string,
   retweeted_status_place_country string,
   retweeted_status_place_country_code string,
   retweeted_status_place_full_name string,
   retweeted_status_place_id binary,
   retweeted_status_place_name string,
   retweeted_status_place_place_type string,
   retweeted_status_place_url string,
   retweeted_status_possibly_sensitive boolean,
   retweeted_status_retweet_count int,
   retweeted_status_retweeted boolean,
   retweeted_status_scopes_followers boolean,
   retweeted_status_source string,
   retweeted_status_text string,
   retweeted_status_truncated boolean,
   retweeted_status_user_contributors_enabled boolean,
   retweeted_status_user_created_at string,
   retweeted_status_user_default_profile boolean,
   retweeted_status_user_default_profile_image boolean,
   retweeted_status_user_description string,
   retweeted_status_user_favourites_count int,
   retweeted_status_user_followers_count smallint,
   retweeted_status_user_friends_count smallint,
   retweeted_status_user_geo_enabled boolean,
   retweeted_status_user_id int,
   retweeted_status_user_id_str string,
   retweeted_status_user_is_translator boolean,
   retweeted_status_user_lang string,
   retweeted_status_user_listed_count int,
   retweeted_status_user_location string,
   retweeted_status_user_name string,
   retweeted_status_user_profile_background_color binary,
   retweeted_status_user_profile_background_image_url string,
   retweeted_status_user_profile_background_image_url_https string,
   retweeted_status_user_profile_background_tile boolean,
   retweeted_status_user_profile_banner_url string,
   retweeted_status_user_profile_image_url string,
   retweeted_status_user_profile_image_url_https string,
   retweeted_status_user_profile_link_color binary,
   retweeted_status_user_profile_sidebar_border_color binary,
   retweeted_status_user_profile_sidebar_fill_color binary,
   retweeted_status_user_profile_text_color binary,
   retweeted_status_user_profile_use_background_image boolean,
   retweeted_status_user_protected boolean,
   retweeted_status_user_screen_name string,
   retweeted_status_user_statuses_count smallint,
   retweeted_status_user_time_zone string,
   retweeted_status_user_url string,
   retweeted_status_user_utc_offset int,
   retweeted_status_user_verified boolean,
   scopes_place_ids array <binary>,
   source string,
   text string,
   truncated boolean,
   user_contributors_enabled boolean,
   user_created_at string,
   user_default_profile boolean,
   user_default_profile_image boolean,
   user_description string,
   user_favourites_count int,
   user_followers_count int,
   user_friends_count int,
   user_geo_enabled boolean,
   user_id int,
   user_id_str string,
   user_is_translator boolean,
   user_lang string,
   user_listed_count int,
   user_location string,
   user_name string,
   user_profile_background_color binary,
   user_profile_background_image_url string,
   user_profile_background_image_url_https string,
   user_profile_background_tile boolean,
   user_profile_banner_url string,
   user_profile_image_url string,
   user_profile_image_url_https string,
   user_profile_link_color binary,
   user_profile_sidebar_border_color binary,
   user_profile_sidebar_fill_color binary,
   user_profile_text_color binary,
   user_profile_use_background_image boolean,
   user_protected boolean,
   user_screen_name string,
   user_statuses_count smallint,
   user_time_zone string,
   user_url string,
   user_utc_offset int,
   user_verified boolean
)
PARTITIONED BY (
  date STRING
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://fredcons/fluentd/twitter/worldcup/input_combined/';

ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140529') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140529';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140530') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140530';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140531') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140531';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140601') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140601';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140602') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140602';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140603') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140603';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140604') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140604';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140605') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140605';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140606') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140606';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140607') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140607';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140608') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140608';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140609') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140609';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140610') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140610';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140611') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140611';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140612') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140612';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140613') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140613';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140614') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140614';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140615') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140615';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140616') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140616';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140617') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140617';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140618') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140618';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140619') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140619';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140620') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140620';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140621') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140621';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140622') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140622';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140623') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140623';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140624') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140624';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140625') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140625';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140626') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140626';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140627') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140627';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140628') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140628';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140629') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140629';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140630') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140630';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140701') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140701';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140702') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140702';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140703') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140703';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140704') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140704';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140705') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140705';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140706') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140706';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140707') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140707';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140708') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140708';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140709') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140709';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140710') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140710';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140711') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140711';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140712') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140712';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140713') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140713';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140714') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140714';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140715') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140715';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140716') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140716';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140717') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140717';
ALTER TABLE tweets ADD IF NOT EXISTS PARTITION(date='20140718') location 's3://fredcons/fluentd/twitter/worldcup/input_combined/date=20140718';

