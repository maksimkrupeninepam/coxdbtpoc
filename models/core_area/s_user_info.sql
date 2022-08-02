select
  MD5(UPPER(u.LOGIN_NAME)) as USER_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  u.CREATED_ON as SF_CREATION_DATE,
  u.DISABLED as IS_DISABLED
from {{source('sf_source_tables','USERS') }} u
where DELETED_ON is NULL