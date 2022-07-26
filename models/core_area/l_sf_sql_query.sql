
{{
    config(
        materialized='incremental'
    )
}}

select
  MD5(h.QUERY_ID||'^'||u.LOGIN_NAME||'^'||h.ROLE_NAME||'^'||ifnull(h.WAREHOUSE_NAME,'N/A')) as L_SF_SQL_QUERY_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  MD5(h.QUERY_ID) as QUERY_SK,
  MD5(u.LOGIN_NAME) as USER_SK,
  MD5(h.ROLE_NAME) as ROLE_SK,
  ifnull(MD5(h.WAREHOUSE_ID),'N/A') as VIRT_WH_SK,
  h.START_TIME as START_TIME
from {{source('sf_source_tables','QUERY_HISTORY') }} h
join {{ref('s_user_pii_info') }} u on u.USER_NAME = h.USER_NAME

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where h.START_TIME >= (select max(t.START_TIME) from {{ this }} t)
{% endif %}
