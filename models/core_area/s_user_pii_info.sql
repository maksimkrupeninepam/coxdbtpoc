
select
  MD5(UPPER(u.LOGIN_NAME)) as USER_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  u.LOGIN_NAME as LOGIN_NAME,
  u.NAME as USER_NAME,
  u.FIRST_NAME as FIRST_NAME,
  u.LAST_NAME as LAST_NAME,
  u.EMAIL as EMAIL
from {{source('sf_source_tables','USERS') }} u
