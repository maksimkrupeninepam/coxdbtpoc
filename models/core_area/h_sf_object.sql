
{{
    config(
        materialized='table'
    )
}}
select
  MD5(t.TABLE_ID) as SF_OBJECT_SK,
  t.TABLE_ID as SF_OBJECT_ID,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME
from {{source('sf_source_tables','TABLES') }} t