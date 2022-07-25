
select
  MD5(UPPER(u.LOGIN_NAME)) as USER_SK,
  u.LOGIN_NAME as LOGIN_NAME,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME
from {{source('sf_source_tables','USERS') }} u
where DELETED_ON is NULL