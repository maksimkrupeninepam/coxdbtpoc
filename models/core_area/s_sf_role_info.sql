
select
  MD5(UPPER(r.NAME)) as ROLE_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  r.NAME as ROLE_NAME,
  r.CREATED_ON as CREATED_ON,
  r.COMMENT as ROLE_COMMENT
from {{source('sf_source_tables','ROLES') }} r
where r.DELETED_ON is NULL