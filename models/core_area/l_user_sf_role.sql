{{
    config(
        materialized='table'
    )
}}

select
  MD5(UPPER(r.GRANTEE_NAME)||'^'||UPPER(r.ROLE)) as L_USER_SF_ROLE_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  MD5(UPPER(r.GRANTEE_NAME)) as USER_SK,
  MD5(UPPER(r.ROLE)) as ROLE_SK
from {{source('sf_source_tables','GRANTS_TO_USERS') }} r
join {{ref('h_cai_user') }} u on r.GRANTEE_NAME = u.LOGIN_NAME
where r.DELETED_ON is NULL
