
select
  MD5(UPPER(r.GRANTEE_NAME)||'^'||UPPER(r.ROLE)) as L_USER_SF_ROLE_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  MD5(UPPER(r.GRANTEE_NAME)) as USER_SK,
  MD5(UPPER(r.ROLE)) as ROLE_SK
from {{source('sf_source_tables','GRANTS_TO_USERS') }} r