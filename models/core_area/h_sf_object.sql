
{{
    config(
        materialized='table'
    )
}}
select
  MD5(UPPER(t.TABLE_CATALOG||'.'||t.TABLE_SCHEMA||'.'||t.TABLE_NAME)) as SF_OBJECT_SK,
  UPPER(t.TABLE_CATALOG||'.'||t.TABLE_SCHEMA||'.'||t.TABLE_NAME) as SF_OBJECT_NAME,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME
from {{source('sf_source_tables','TABLES') }} t