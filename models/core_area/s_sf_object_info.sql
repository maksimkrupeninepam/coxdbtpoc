
{{
    config(
        materialized='table'
    )
}}

select
  MD5(UPPER(t.TABLE_CATALOG||'.'||t.TABLE_SCHEMA||'.'||t.TABLE_NAME)) as SF_OBJECT_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  t.TABLE_TYPE as OBJECT_TYPE,
  t.TABLE_ID as OBJECT_ID,
  t.TABLE_CATALOG||'.'||t.TABLE_SCHEMA||'.'||t.TABLE_NAME as SF_OBJECT_NAME,
  t.TABLE_CATALOG as DB_NAME,
  t.TABLE_SCHEMA as SCHEMA,
  t.TABLE_NAME as OBJECT_NAME,
  t.CREATED as CREATED,
  t.COMMENT as OBJECT_COMMENT
from {{source('sf_source_tables','TABLES') }} t