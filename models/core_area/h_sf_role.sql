select
  MD5(UPPER(r.NAME)) as ROLE_SK,
  r.NAME as ROLE_NAME,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME
from {{source('sf_source_tables','ROLES') }} r