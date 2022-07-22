
{{
    config(
        materialized='incremental',
        unique_key='QUERY_SK'
    )
}}
select
  MD5(h.QUERY_ID) as QUERY_SK,
  h.QUERY_ID as QUERY_ID,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME
from {{source('sf_source_tables','QUERY_HISTORY') }} h

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where h.START_TIME >= (select dateadd(hour,-1, max(t.SYS_LOAD_TIME)) from {{ this }} t)
{% endif %}
